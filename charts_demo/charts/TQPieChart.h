//
//  TQPieChart.h
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQPieChartDrawManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TQPieChartSegment : NSObject

@property (nonatomic, strong, nullable) NSString *valueString;
@property (nonatomic, assign) double value; // if valueString is nil, using value.
@property (nonatomic, strong) UIColor *color; // default is [UIColor clearColor].

@end

@protocol TQPieChartDelegate;
@interface TQPieChart : UIView

@property (nonatomic, weak) id<TQPieChartDelegate> delegate;
@property (nonatomic, strong, readonly) TQPieChartDrawManager *drawManager;
@property (nonatomic, strong, readonly) NSArray<TQPieChartSegment *> *segments;
@property (nonatomic, assign, readonly) BOOL isInAnimation;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Only through `-initWithFrame:drawManager:` to initialize.
- (instancetype)initWithFrame:(CGRect)frame drawManager:(TQPieChartDrawManager *)drawManager NS_DESIGNATED_INITIALIZER;

- (void)reloadSegments:(NSArray<TQPieChartSegment *> *)segments; // reload data
- (void)restartAnimationCompletion:(void (^ __nullable)(BOOL finished))completion; // reload animation

@end

@protocol TQPieChartDelegate <NSObject>
@optional

// 点击了内圆区域
- (void)pieChartDidClickedInnerCircle:(TQPieChart *)pieChart;

// 点击了圆环分段区域 (`position`为每段区域的中心点位置)
- (void)pieChart:(TQPieChart *)pieChart didClickedSegmentAtIndex:(NSInteger)index positionOfCenter:(CGPoint)position;

// 将要显示每段区域
- (void)pieChart:(TQPieChart *)pieChart willDisplaySegmentWithIndex:(NSInteger)index positionOfCenter:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
