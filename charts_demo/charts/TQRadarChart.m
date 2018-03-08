//
//  TQRadarChart.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "TQRadarChart.h"
#import "UIBezierPath+TQChartExtend.h"
#import "TQChartUtilities.h"
#import "TQTextLayer.h"

@implementation TQRadarChartDrawManager

+ (instancetype)defaultManager {
    TQRadarChartDrawManager *manager = [[TQRadarChartDrawManager alloc] init];
    manager.numberOfLaps = 4;
    manager.numberOfSides = 5;
    manager.center = CGPointMake(150, 150);
    manager.radius = 30;
    manager.radiusOfincrements = 30;
    manager.borderWidth = 2;
    manager.borderColor = [UIColor clearColor];
    manager.fillColor = [UIColor darkGrayColor];
    manager.layerIndex = 0;
    manager.displayDot = NO;
    manager.layerColor = [UIColor darkGrayColor];
    manager.dotColor = [UIColor blackColor];
    return manager;
}

@end

@implementation TQRadarChartModel

@end

@interface TQRadarChart () <CAAnimationDelegate>

@property (nonatomic, strong, readonly) CALayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *radarLayer;
@property (nonatomic, copy) void (^finishedCallback)(BOOL finished);

@end

@implementation TQRadarChart

- (instancetype)initWithFrame:(CGRect)frame drawManager:(TQRadarChartDrawManager *)drawManager {
    if (self = [super initWithFrame:CGRectIntegral(frame)]) {
        _drawManager = drawManager;
        _containerLayer = [CALayer layer];
        [self.layer addSublayer:_containerLayer];
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    NSInteger laps = self.drawManager.numberOfLaps;
    while (laps) {
        laps--;
        CGFloat raduis = self.drawManager.radius + self.drawManager.radiusOfincrements * laps;
        UIBezierPath *path = [UIBezierPath tq_bezierPathWithEquilateralCenter:self.drawManager.center
                                                                       radius:raduis
                                                                numberOfsides:self.drawManager.numberOfSides];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        CGFloat alpha = (self.drawManager.numberOfLaps - laps) * (1.f / self.drawManager.numberOfLaps);
        shapeLayer.fillColor = [self.drawManager.fillColor colorWithAlphaComponent:alpha].CGColor;
        shapeLayer.strokeColor = self.drawManager.borderColor.CGColor;
        shapeLayer.lineWidth = self.drawManager.borderWidth;
        [self.containerLayer addSublayer:shapeLayer];
    }
}

- (void)setModelOfArray:(NSArray<TQRadarChartModel *> *)modelOfArray {
    NSParameterAssert(modelOfArray.count);
    _modelOfArray = modelOfArray;
    CGFloat maximaEvaluative = 100; // 评估最大值
    CGFloat outermostCircleRaduis = self.drawManager.radius + (self.drawManager.numberOfLaps - 1) * self.drawManager.radiusOfincrements; // 最大半径
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [modelOfArray enumerateObjectsUsingBlock:^(TQRadarChartModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat radian = 2 * M_PI / self.drawManager.numberOfSides * idx - M_PI_2;
        double value = model.value;
        if (model.valueString) {
            value = [model.valueString doubleValue];
        }
        CGFloat refValue = value / maximaEvaluative * outermostCircleRaduis;
        CGPoint anyPoint = [TQChartUtilities coordinatePointOfCenter:self.drawManager.center radius:refValue - self.drawManager.borderWidth radian:radian];
        if (idx <= 0) {
            [path moveToPoint:anyPoint];
        } else {
            [path addLineToPoint:anyPoint];
        }
        
        // textLayer
        if (model.text) {
            CGPoint apex = [TQChartUtilities coordinatePointOfCenter:self.drawManager.center radius:outermostCircleRaduis + 20 radian:radian];
            CATextLayer *textLayer =[TQTextLayer textLayerWithText:model.text
                                                         textColor:[UIColor darkGrayColor]];
            textLayer.position = apex;
            [self.layer addSublayer:textLayer];
        }
        
        // dotLayer
        if (self.drawManager.displayDot) {
            CAShapeLayer *dotLayer = [self dotLayerWithCenter:anyPoint radius:4];
            [self.layer addSublayer:dotLayer];
        }
    }];
    [path closePath];
    
    self.radarLayer = [CAShapeLayer layer];
    self.radarLayer.path = path.CGPath;
    UIColor *fillColor = self.drawManager.layerColor;
    self.radarLayer.fillColor = [fillColor colorWithAlphaComponent:0.8].CGColor;
    if (self.drawManager.layerIndex) {
        [self.containerLayer insertSublayer:self.radarLayer atIndex:(unsigned)self.drawManager.layerIndex];
    } else {
        [self.containerLayer addSublayer:self.radarLayer];
    }
    [self refreshAnimationCompletion:NULL];
}

- (void)refreshAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    UIBezierPath *fromPath = [UIBezierPath tq_bezierPathWithEquilateralCenter:self.drawManager.center
                                                                       radius:self.drawManager.radius
                                                                numberOfsides:self.drawManager.numberOfSides];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.duration = 0.55;
    animation.fromValue = (__bridge id _Nullable)(fromPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(self.radarLayer.path);
    animation.removedOnCompletion = YES;
    [self.radarLayer addAnimation:animation forKey:@"TQAnimationPath_key"];
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

- (CAShapeLayer *)dotLayerWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle:2 * M_PI
                                                     clockwise:YES];
    layer.path = path.CGPath;
    layer.fillColor = [self.drawManager.dotColor colorWithAlphaComponent:0.75].CGColor;
    layer.strokeColor = [self.drawManager.dotColor colorWithAlphaComponent:0.25].CGColor;
    layer.lineWidth = radius / 3;
    return layer;
}

@end
