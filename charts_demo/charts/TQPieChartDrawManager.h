//
//  TQPieChartDrawManager.h
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TQPieChartStartPosition) {
    TQPieChartStartPositionTop = 0,
    TQPieChartStartPositionLeft,
    TQPieChartStartPositionBottom,
    TQPieChartStartPositionRight
};

typedef NS_ENUM(NSInteger, TQPieChartClickedEffect) {
    TQPieChartClickedEffectNone = 0,
    TQPieChartClickedEffectHighlight,
    TQPieChartClickedEffectDisconnect
};

@interface TQPieChartDrawManager : NSObject

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BOOL clockwise; // default is YES

@property (nonatomic, assign) TQPieChartStartPosition startPosition;// default is TQPieChartStartPositionTop

@property (nonatomic, assign) CFTimeInterval animateDuration; // default is 0.75s

@property (nonatomic, assign) BOOL fillChart; // default is NO, if YES lineWidth is invalid.

@property (nonatomic, assign) TQPieChartClickedEffect clickedEffect; // default is TQPieChartClickedEffectNone

@property (nonatomic, assign) CGFloat effectOffset; // default is 10, when clickedEffect is not TQPieChartClickedEffectNone is valid.

+ (instancetype)defaultManager;

@end
