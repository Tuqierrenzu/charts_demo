//
//  Draw2ViewController.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "Draw2ViewController.h"
#import "TQRadarChart.h"

@interface Draw2ViewController ()

@property (nonatomic, strong) TQRadarChart *chartView;
@property (nonatomic, strong) TQRadarChart *chartView2;

@end

@implementation Draw2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup1];
    [self setup2];
}

- (void)setup1 {
    CGRect rect = CGRectMake(20, 85, 300, 300);
    TQRadarChartDrawManager *drawManager = [TQRadarChartDrawManager defaultManager];
    drawManager.displayDot = YES;
    drawManager.layerColor = [self colorWithHex:@"#4682B4"];
    
    _chartView = [[TQRadarChart alloc] initWithFrame:rect drawManager:drawManager];
    _chartView.center = CGPointMake(self.view.bounds.size.width / 2, _chartView.center.y);
    _chartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chartView];
    
    NSArray *valueArray = @[@70.2, @55.7, @65, @92.7, @61.5];
    NSArray *textArray = @[@"力量", @"耐力", @"技术", @"柔韧", @"速度"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < valueArray.count; i++) {
        TQRadarChartModel *model = [[TQRadarChartModel alloc] init];
        model.value = [valueArray[i] doubleValue];
        model.text = textArray[i];
        [array addObject:model];
    }
    
    _chartView.modelOfArray = array;
}

#pragma mark - setup2

- (void)setup2 {
    CGRect rect = CGRectMake(20, 400, 300, 300);
    TQRadarChartDrawManager *drawManager = [TQRadarChartDrawManager defaultManager];
    drawManager.numberOfLaps = 2;
    drawManager.numberOfSides = 3;
    drawManager.radius = 35;
    drawManager.radiusOfincrements = 80;
    drawManager.layerIndex = 1;
    drawManager.layerColor = [self colorWithHex:@"#4682B4"];
    
    _chartView2 = [[TQRadarChart alloc] initWithFrame:rect drawManager:drawManager];
    _chartView2.center = CGPointMake(self.view.bounds.size.width / 2, _chartView2.center.y);
    _chartView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chartView2];
    
    NSArray *valueArray = @[@65, @92.7, @61.5];
    NSArray *textArray = @[@"技术", @"柔韧", @"速度"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < valueArray.count; i++) {
        TQRadarChartModel *model = [[TQRadarChartModel alloc] init];
        model.value = [valueArray[i] doubleValue];
        model.text = textArray[i];
        [array addObject:model];
    }
    
    _chartView2.modelOfArray = array;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_chartView refreshAnimationCompletion:NULL];
    [_chartView2 refreshAnimationCompletion:NULL];
}

@end
