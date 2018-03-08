//
//  TQTextLayer.h
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface TQTextLayer : CATextLayer

+ (CATextLayer *)textLayerWithText:(NSString *)text;

+ (CATextLayer *)textLayerWithText:(NSString *)text
                         textColor:(UIColor *)textColor;

+ (CATextLayer *)textLayerWithText:(NSString *)text
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font;
@end
