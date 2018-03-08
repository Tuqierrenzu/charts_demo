//
//  UIBezierPath+TQChartExtend.h
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TQBezierPathEquilateralStartPosition) {
    TQBezierPathEquilateralStartPositionTop = 0,
    TQBezierPathEquilateralStartPositionBottom,
    TQBezierPathEquilateralStartPositionLeft,
    TQBezierPathEquilateralStartPositionRight
};

@interface UIBezierPath (TQChartExtend)

/// 绘制正N边形路径 (N>=3)
+ (UIBezierPath *)tq_bezierPathWithEquilateralCenter:(CGPoint)center
                                              radius:(CGFloat)radius
                                       numberOfsides:(NSInteger)numberOfsides;

/// 绘制正N边形路径 (N>=3) 增加上左下右位置可选
+ (UIBezierPath *)tq_bezierPathWithEquilateralCenter:(CGPoint)center
                                              radius:(CGFloat)radius
                                       numberOfsides:(NSInteger)numberOfsides
                                       startPosition:(TQBezierPathEquilateralStartPosition)startPosition;

@end
