//
//  TQRadarChart.h
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TQRadarChartStyle) {
    TQRadarChartStyleEquilateral,
    TQRadarChartStyleRoundness
};

@interface TQRadarChartDrawManager : NSObject

@property (nonatomic, assign) TQRadarChartStyle style;
@property (nonatomic, assign) NSUInteger numberOfLaps; // 圈数
@property (nonatomic, assign) NSUInteger numberOfSides; // 正多边形边数 >=3
@property (nonatomic, assign) CGPoint center; // 圆心
@property (nonatomic, assign) CGFloat radius; // 最小的半径
@property (nonatomic, assign) CGFloat radiusOfincrements; // 半径增量
@property (nonatomic, assign) CGFloat borderWidth; // 边框宽度
@property (nonatomic, strong, nullable) UIColor *borderColor; // 边框颜色
@property (nonatomic, strong, nullable) UIColor *fillColor; // 填充颜色
@property (nonatomic, strong, nullable) UIColor *layerColor; 
@property (nonatomic, assign) NSInteger layerIndex;
@property (nonatomic, assign) BOOL displayDot;
@property (nonatomic, strong, nullable) UIColor *dotColor; 

+ (instancetype)defaultManager;

@end

@interface TQRadarChartModel : NSObject

@property (nonatomic, strong) NSString *valueString;
@property (nonatomic, assign) double value;
@property (nonatomic, strong) NSString *text;

@end

@interface TQRadarChart : UIView

@property (nonatomic, strong, readonly) TQRadarChartDrawManager *drawManager;
@property (nonatomic, assign, readonly) BOOL isInAnimation;

- (instancetype)initWithFrame:(CGRect)frame
                  drawManager:(TQRadarChartDrawManager *)drawManager;

@property (nonatomic, strong) NSArray<TQRadarChartModel *> *modelOfArray;

- (void)refreshAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
