//
//  TQChartUtilities.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "TQChartUtilities.h"

@implementation TQChartUtilities

+ (CGPoint)coordinatePointOfCenter:(CGPoint)center
                            radius:(CGFloat)radius
                            radian:(CGFloat)radian {
    radian += M_PI_2;
    if (radian < M_PI_2) {
        return CGPointMake(center.x + radius * sin(radian),
                           center.y - radius * cos(radian));
    } else if (radian < M_PI) {
        return CGPointMake(center.x + radius * sin(M_PI-radian),
                           center.y + radius * cos(M_PI-radian));
    } else if (radian < 3 * M_PI_2) {
        return CGPointMake(center.x - radius * cos(3 * M_PI_2 - radian),
                           center.y + radius * sin(3 * M_PI_2 - radian));
    } else {
        return CGPointMake(center.x - radius * sin(2 * M_PI - radian),
                           center.y - radius * cos(2 * M_PI - radian));
    }
}

@end
