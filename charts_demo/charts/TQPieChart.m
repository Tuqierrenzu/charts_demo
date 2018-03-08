//
//  TQPieChart.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "TQPieChart.h"
#import "TQChartUtilities.h"

@implementation TQPieChartSegment

@end

@interface TQPieChart () <CAAnimationDelegate>

@property (nonatomic, strong, readonly) CAShapeLayer *containerLayer;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *percentages;
@property (nonatomic, strong) CAShapeLayer *highlightLayer;
@property (nonatomic, assign, readonly) CGFloat startRadian;
@property (nonatomic, strong) CALayer *clickedLayer;
@property (nonatomic, copy) void (^finishedCallback)(BOOL finished);

@end

@implementation TQPieChart

- (instancetype)initWithFrame:(CGRect)frame drawManager:(TQPieChartDrawManager *)drawManager {
    if (self = [super initWithFrame:CGRectIntegral(frame)]) {
        _drawManager = drawManager;
        _containerLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_containerLayer];
    }
    return self;
}

- (void)reloadSegments:(NSArray<TQPieChartSegment *> *)segments {
    NSParameterAssert(segments);
    _segments = segments;
    
    NSMutableArray<id> *values = [NSMutableArray array];
    NSMutableArray<UIColor *> *colors = [NSMutableArray array];
    for (TQPieChartSegment *segment in segments) {
        if (segment.valueString) {
            [values addObject:segment.valueString];
        } else {
            [values addObject:@(segment.value)];
        }
        [colors addObject:segment.color];
    }
    
    self.percentages = [NSMutableArray array];
    CGFloat sum = [[values valueForKeyPath:@"@sum.doubleValue"] doubleValue];
    CGFloat currentSum = 0;
    for (id obj in values) {
        if (sum <= 0) continue;
        currentSum += [obj doubleValue];
        [self.percentages addObject:@(currentSum / sum)]; // 计算百分比
    }
    
    for (NSInteger i = 0; i < self.percentages.count; i++) {
        CGFloat startPercentage = 0;
        if (i > 0) {
            startPercentage = [self.percentages[i-1] doubleValue];
        }
        CGFloat endPercentage = [self.percentages[i] doubleValue];
        
        if ([self.delegate respondsToSelector:@selector(pieChart:willDisplaySegmentWithIndex:positionOfCenter:)]) {
            CGFloat rad = self.drawManager.radius;
            if (self.drawManager.fillChart) {
                rad = self.drawManager.radius * 0.5;
            }
            CGFloat centerPercentage = (startPercentage + endPercentage) * 0.5;
            CGFloat radian = centerPercentage * 2 * M_PI - (2 * M_PI - self.startRadian);
            CGPoint p = [TQChartUtilities coordinatePointOfCenter:self.drawManager.center radius:rad radian:radian];
            if ([self.delegate respondsToSelector:@selector(pieChart:willDisplaySegmentWithIndex:positionOfCenter:)]) {
                [self.delegate pieChart:self willDisplaySegmentWithIndex:i positionOfCenter:p];
            }
        }
        
        CAShapeLayer *shapeLayer = [self createLayerWithCenter:self.drawManager.center
                                                        radius:self.drawManager.radius
                                                  startPercent:startPercentage
                                                    endPercent:endPercentage
                                                   strokeColor:colors[i]];
        [self.containerLayer addSublayer:shapeLayer];
    }
    
    CAShapeLayer *maskLayer = [self createLayerWithCenter:self.drawManager.center
                                                   radius:self.drawManager.radius
                                             startPercent:0
                                               endPercent:1
                                              strokeColor:[UIColor whiteColor]];
    self.containerLayer.mask = maskLayer;
    
    [self restartAnimationCompletion:NULL];
    
}

- (CAShapeLayer *)createLayerWithCenter:(CGPoint)center
                                 radius:(CGFloat)radius
                           startPercent:(CGFloat)startPercent
                             endPercent:(CGFloat)endPercent
                            strokeColor:(UIColor *)strokeColor {
    CGFloat lineWidth = self.drawManager.lineWidth;
    CGFloat pieRadius = radius;
    if (self.drawManager.fillChart) {
        lineWidth = radius;
        pieRadius = radius / 2;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:pieRadius
                                                          startAngle:self.startRadian
                                                            endAngle:M_PI * 2 + self.startRadian
                                                           clockwise:self.drawManager.clockwise];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeStart = startPercent;
    shapeLayer.strokeEnd = endPercent;
    return shapeLayer;
}

- (void)restartAnimationCompletion:(void (^)(BOOL))completion {
    self.finishedCallback = completion;
    if (!_containerLayer.mask) return;
    NSString *keyPath = @"strokeEnd";
    NSString *key = [NSString stringWithFormat:@"pieAnimationKey_%@", keyPath];
    [self.containerLayer removeAnimationForKey:key];
    if (self.drawManager.animateDuration <= 0) return;
    if (self.highlightLayer) {
        [self disableHandler:^{
            self.clickedLayer.hidden = NO;
        }];
        [self.highlightLayer removeFromSuperlayer];
    }
    [self arcAnimationForLayer:_containerLayer.mask
                   withKeyPath:keyPath
                     fromValue:@0
                       toValue:@1
                      duration:self.drawManager.animateDuration];
}

- (void)arcAnimationForLayer:(CALayer *)layer
                 withKeyPath:(NSString *)path
                   fromValue:(id)fromValue
                     toValue:(id)toValue
                    duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:path];
    animation.delegate = self;
    animation.duration = duration;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.removedOnCompletion = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSString *key = [NSString stringWithFormat:@"pieAnimationKey_%@", path];
    [layer addAnimation:animation forKey:key];
    [layer setValue:toValue forKey:path];
}

- (void)animationDidStart:(CAAnimation *)anim {
    _isInAnimation = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isInAnimation = !flag;
    if (self.finishedCallback) {
        self.finishedCallback(flag);
        self.finishedCallback = nil;
    }
}

- (void)disableHandler:(void (^)(void))handler {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    handler();
    [CATransaction commit];
}

- (CGFloat)startRadian {
    switch (self.drawManager.startPosition) {
        case TQPieChartStartPositionRight:
            return 0;
        case TQPieChartStartPositionBottom:
            return M_PI_2;
        case TQPieChartStartPositionLeft:
            return M_PI;
        default: // TQPieSegmentStartPositionTop
            return 3 * M_PI_2;
    }
}

- (CGFloat)degreesOfRadian:(CGFloat)radian dx:(CGFloat)dx dy:(CGFloat)dy {
    switch (self.drawManager.startPosition) {
        case TQPieChartStartPositionLeft: {
            if (dx > 0) {
                radian += M_PI;
            } else if (dy > 0) {
                radian += 2 * M_PI;
            }
        } break;
        case TQPieChartStartPositionRight: {
            if (dx < 0) {
                radian += M_PI;
            } else if (dy < 0) {
                radian += 2 * M_PI;
            }
        } break;
        default: { // TQPieChartStartPositionTop/Bottom
            if (dx > 0) {
                radian += (2 * M_PI - self.startRadian);
            } else {
                radian += self.startRadian;
            }
        } break;
    }
    if (!self.drawManager.clockwise) radian = 2 * M_PI - radian;
    return 180 / M_PI * radian;
}

//- (CGPoint)centerOfRadius:(CGFloat)radius
//                    start:(CGFloat)startPercentage
//                      end:(CGFloat)endPercentage {
//    CGFloat centerPercentage = (startPercentage + endPercentage) * 0.5;
//    CGFloat radian = centerPercentage * 2 * M_PI + M_PI_2;
//    CGPoint center = self.drawManager.center;
//    CGPoint p = CGPointZero;
//    if (radian < M_PI_2) {
//        p.x = center.x + radius * sin(radian);
//        p.y = center.y - radius * cos(radian);
//    } else if (radian < M_PI) {
//        p.x = center.x + radius * sin(M_PI-radian);
//        p.y = center.y + radius * cos(M_PI-radian);
//    } else if (radian < 3 * M_PI_2) {
//        p.x = center.x - radius * cos(3 * M_PI_2 - radian);
//        p.y = center.y + radius * sin(3 * M_PI_2 - radian);
//    } else {
//        p.x = center.x - radius * sin(2 * M_PI - radian);
//        p.y = center.y - radius * cos(2 * M_PI - radian);
//    }
//    return p; // 求每个区域的中心点坐标
//}

#pragma mark - Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self]; // 获取触摸点
    double distanceToCenter = hypot(fabs(location.x - self.drawManager.center.x), fabs(location.y - self.drawManager.center.y));
    
    CGFloat outerCircleRadius = self.drawManager.radius + self.drawManager.lineWidth * 0.5;
    if (self.drawManager.fillChart) {
        outerCircleRadius = self.drawManager.radius;
    }
    if (distanceToCenter > outerCircleRadius) {
        return [super touchesBegan:touches withEvent:event]; // 超出范围则将事件交给父类
    }
    
    if (self.highlightLayer) {
        [self disableHandler:^{
            self.clickedLayer.hidden = NO;
        }];
        [self.highlightLayer removeFromSuperlayer];
    }
    
    CGFloat innerCircleRadius = self.drawManager.radius - self.drawManager.lineWidth * 0.5;
    if (self.drawManager.fillChart) {
        innerCircleRadius = 0;
    }
    if (distanceToCenter < innerCircleRadius) { // 内圆区域
        if ([self.delegate respondsToSelector:@selector(pieChartDidClickedInnerCircle:)]) {
            [self.delegate pieChartDidClickedInnerCircle:self];
        }
    } else { // 圆环区域
        CGFloat dx = location.x - self.drawManager.center.x;
        CGFloat dy = location.y - self.drawManager.center.y;
        CGFloat radianf = atanf(dy / dx);
        CGFloat degrees = [self degreesOfRadian:radianf dx:dx dy:dy];
        [self.percentages enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (degrees < obj.doubleValue * 360) {
                CGFloat startPercentage = 0;
                if (idx > 0) startPercentage = self.percentages[idx - 1].doubleValue;
                CGFloat endPercentage = obj.doubleValue;
                if (self.drawManager.clickedEffect == TQPieChartClickedEffectHighlight) {
                    UIColor *originalColor = [self.segments[idx] color];
                    UIColor *color = [originalColor colorWithAlphaComponent:CGColorGetAlpha(originalColor.CGColor) * 0.5];
                    self.highlightLayer = [self createLayerWithCenter:self.drawManager.center
                                                               radius:self.drawManager.radius + self.drawManager.effectOffset
                                                         startPercent:startPercentage
                                                           endPercent:endPercentage
                                                          strokeColor:color];
                    [self.layer insertSublayer:self.highlightLayer above:self.containerLayer];
                } else if (self.drawManager.clickedEffect == TQPieChartClickedEffectDisconnect) {
                    self.clickedLayer = self.containerLayer.sublayers[idx];
                    [self disableHandler:^{
                        self.clickedLayer.hidden = YES;
                    }];
                    UIColor *originalColor = [self.segments[idx] color];
                    CGFloat centerPercentage = (startPercentage + endPercentage) * 0.5;
                    CGFloat radian = centerPercentage * 2 * M_PI - (2 * M_PI - self.startRadian);
                    CGPoint p = [TQChartUtilities coordinatePointOfCenter:self.drawManager.center radius:self.drawManager.effectOffset  radian:radian];
                    self.highlightLayer = [self createLayerWithCenter:p
                                                               radius:self.drawManager.radius
                                                         startPercent:startPercentage
                                                           endPercent:endPercentage
                                                          strokeColor:originalColor];
                    [self.layer insertSublayer:self.highlightLayer above:self.containerLayer];
                } else {}
                
                if ([self.delegate respondsToSelector:@selector(pieChart:didClickedSegmentAtIndex:positionOfCenter:)]) {
                    CGFloat rad = self.drawManager.radius;
                    if (self.drawManager.fillChart) {
                        rad = self.drawManager.radius * 0.5;
                    }
                    CGFloat centerPercentage = (startPercentage + endPercentage) * 0.5;
                    CGFloat radian = centerPercentage * 2 * M_PI - (2 * M_PI - self.startRadian);
                    CGPoint p = [TQChartUtilities coordinatePointOfCenter:self.drawManager.center radius:rad radian:radian];
                    [self.delegate pieChart:self didClickedSegmentAtIndex:idx positionOfCenter:p];
                }
                *stop = YES;
            }
        }];
    }
}

@end
