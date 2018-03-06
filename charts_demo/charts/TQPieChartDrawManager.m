//
//  TQPieChartDrawManager.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "TQPieChartDrawManager.h"

@implementation TQPieChartDrawManager

+ (instancetype)defaultManager {
    TQPieChartDrawManager *manager = [[TQPieChartDrawManager alloc] init];
    manager.center = CGPointMake(100, 100);
    manager.lineWidth = 35;
    manager.radius = 50;
    manager.clockwise = YES;
    manager.startPosition = TQPieChartStartPositionTop;
    manager.fillChart = NO;
    manager.animateDuration = 0.75;
    manager.clickedEffect = TQPieChartClickedEffectNone;
    manager.effectOffset = 10;
    return manager;
}

@end
