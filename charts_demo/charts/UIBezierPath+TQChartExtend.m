//
//  UIBezierPath+TQChartExtend.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "UIBezierPath+TQChartExtend.h"

@implementation UIBezierPath (TQChartExtend)

+ (UIBezierPath *)tq_bezierPathWithEquilateralCenter:(CGPoint)center
                                              radius:(CGFloat)radius
                                       numberOfsides:(NSInteger)numberOfsides {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(center.x, center.y - radius)];
    for (NSInteger i = 1; i <= numberOfsides; i++) {
        CGFloat radian = 2 * M_PI * i / numberOfsides;
        CGPoint apex = CGPointMake(center.x + radius * sin(radian), center.y - radius * cos(radian));
        [bezierPath addLineToPoint:CGPointMake(apex.x, apex.y)];
    }
    [bezierPath closePath];
    return bezierPath;
}

+ (UIBezierPath *)tq_bezierPathWithEquilateralCenter:(CGPoint)center
                                              radius:(CGFloat)radius
                                       numberOfsides:(NSInteger)numberOfsides
                                       startPosition:(TQBezierPathEquilateralStartPosition)startPosition {
    CGFloat x = center.x, y = center.y;
    CGPoint (^callback)(CGFloat) = ^(CGFloat radian) {
        switch (startPosition) {
            case TQBezierPathEquilateralStartPositionTop: {
                if (radian < 0) return CGPointMake(x, y - radius);
                return CGPointMake(x + radius * sin(radian), y - radius * cos(radian));
            } break;
            case TQBezierPathEquilateralStartPositionBottom: {
                if (radian < 0) return CGPointMake(x, y + radius);
                return CGPointMake(x + radius * sin(radian), y + radius * cos(radian));
            } break;
            case TQBezierPathEquilateralStartPositionLeft: {
                if (radian < 0) return CGPointMake(x - radius, y);
                return CGPointMake(x - radius * cos(radian), y + radius * sin(radian));
            } break;
            case TQBezierPathEquilateralStartPositionRight: {
                if (radian < 0) return CGPointMake(x + radius, y);
                return CGPointMake(x + radius * cos(radian), y + radius * sin(radian));
            } break;
            default: return CGPointZero;
        }
    };
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:callback(-1)];
    for (NSInteger i = 1; i <= numberOfsides; i++) {
        CGFloat radian = 2 * M_PI * i / numberOfsides;
        [bezierPath addLineToPoint:callback(radian)];
    }
    [bezierPath closePath];
    return bezierPath;
}

@end
