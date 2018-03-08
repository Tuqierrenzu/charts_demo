//
//  Draw1ViewController.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "Draw1ViewController.h"
#import "TQPieChart.h"

@interface Draw1ViewController () <TQPieChartDelegate>

@property (nonatomic, strong) TQPieChart *pieChart1;
@property (nonatomic, strong) TQPieChart *pieChart2;

@property (nonatomic, strong) NSArray<TQPieChartSegment *> *data1;
@property (nonatomic, strong) NSArray<TQPieChartSegment *> *data2;

@end

@implementation Draw1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup1];
    [self setup2];
}

#pragma mark - setup1

- (void)setup1 {
    CGRect rect = CGRectMake(20, 100, 200, 200);
    TQPieChartDrawManager *drawManager = [TQPieChartDrawManager defaultManager];
    drawManager.lineWidth = 70;
    CGFloat w = rect.size.width / 2;
    drawManager.center = CGPointMake(w, w);
    drawManager.radius = w - drawManager.lineWidth / 2;
    drawManager.clickedEffect = TQPieChartClickedEffectDisconnect;
    
    
    _pieChart1 = [[TQPieChart alloc] initWithFrame:rect drawManager:drawManager];
    _pieChart1.center = CGPointMake(self.view.bounds.size.width / 2, _pieChart1.center.y);
    _pieChart1.backgroundColor = [UIColor whiteColor];
    _pieChart1.delegate = self;
    [self.view addSubview:_pieChart1];
    
    [_pieChart1 reloadSegments:self.data1];
}

#pragma mark - TQPieChartDelegate

- (void)pieChart:(TQPieChart *)pieChart willDisplaySegmentWithIndex:(NSInteger)index positionOfCenter:(CGPoint)position {
    NSArray *array = @[@"余额", @"余额宝", @"基金", @"黄金"];
    CATextLayer *textLayer = [self createTextLayerWithText:array[index]];
    textLayer.position = position;
    [pieChart.layer addSublayer:textLayer];
}

- (void)pieChart:(TQPieChart *)pieChart didClickedSegmentAtIndex:(NSInteger)index positionOfCenter:(CGPoint)position {
    NSLog(@"valueString is: %@", self.data1[index].valueString);
}

#pragma mark - TextLayer

- (CATextLayer *)createTextLayerWithText:(NSString *)text {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attri[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [attriText addAttributes:attri range:[text rangeOfString:text]];
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin |    NSStringDrawingUsesFontLeading
                                  attributes:attri
                                     context:nil].size;
    textLayer.frame = CGRectMake(0, 0, size.width, size.height);
    textLayer.string = attriText;
    return textLayer;
}

- (NSArray<TQPieChartSegment *> *)data1 {
    if (!_data1) {
        NSMutableArray<TQPieChartSegment *> *segments = [NSMutableArray array];
        NSArray *values = @[@660.0, @1602.5, @2013.7, @315.5];
        NSArray *colors = @[@"#5F9EA0", @"#CD853F", @"#6495ED", @"#FFD700"];
        for (NSInteger i = 0; i < 4; i++) {
            TQPieChartSegment *segment = [[TQPieChartSegment alloc] init];
            segment.valueString = values[i];
            segment.color = [self colorWithHex:colors[i]];
            [segments addObject:segment];
        }
        _data1 = [NSArray arrayWithArray:segments];
    }
    return _data1;
}


#pragma mark - setup2

- (void)setup2 {
    CGRect rect = CGRectMake(20, 370, 200, 200);
    TQPieChartDrawManager *drawManager = [TQPieChartDrawManager defaultManager];
    CGFloat w = rect.size.width / 2;
    drawManager.center = CGPointMake(w, w);
    drawManager.radius = 100;
    drawManager.fillChart = YES;
    drawManager.clickedEffect = TQPieChartClickedEffectHighlight;
    drawManager.effectOffset = 20;
    drawManager.startPosition = TQPieChartStartPositionRight;
    
    _pieChart2 = [[TQPieChart alloc] initWithFrame:rect drawManager:drawManager];
    _pieChart2.center = CGPointMake(self.view.bounds.size.width / 2, _pieChart2.center.y);
    _pieChart2.backgroundColor = [UIColor whiteColor];
    _pieChart2.delegate = self;
    
    [self.view addSubview:_pieChart2];
    
    [_pieChart2 reloadSegments:self.data2];
}

- (NSArray<TQPieChartSegment *> *)data2 {
    if (!_data2) {
        NSMutableArray<TQPieChartSegment *> *segments = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            // arc4random_uniform 会随机返回一个0到上界之间(不含上界)的整数
            CGFloat dp = arc4random_uniform(10);
            CGFloat tmp = arc4random_uniform(100);
            NSString *tmpString = [NSString stringWithFormat:@"%@.%@", @(tmp), @(dp)];
            TQPieChartSegment *segment = [[TQPieChartSegment alloc] init];
            segment.valueString = tmpString;
            segment.color = [self randomColor];
            [segments addObject:segment];
        }
        _data2 = [NSArray arrayWithArray:segments];
    }
    return _data2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.pieChart1.isInAnimation) return;
    
    [self.pieChart1 restartAnimationCompletion:^(BOOL finished) {
        NSLog(@"_pieChart1");
    }];
    
    [self.pieChart2 restartAnimationCompletion:^(BOOL finished) {
        NSLog(@"_pieChart2");
    }];
}

- (void)dealloc {
    NSLog(@"Draw1ViewController - dealloc");
}

@end
