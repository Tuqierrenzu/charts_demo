//
//  TQTextLayer.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/8.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "TQTextLayer.h"

@implementation TQTextLayer

+ (CATextLayer *)textLayerWithText:(NSString *)text {
    return [self textLayerWithText:text
                         textColor:[UIColor whiteColor]
                              font:[UIFont systemFontOfSize:12]];
}

+ (CATextLayer *)textLayerWithText:(NSString *)text textColor:(UIColor *)textColor {
    return [self textLayerWithText:text
                         textColor:textColor
                              font:[UIFont systemFontOfSize:12]];
}

+ (CATextLayer *)textLayerWithText:(NSString *)text
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font {
    CATextLayer *textLayer = [CATextLayer layer];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    attri[NSForegroundColorAttributeName] = textColor;
    [attriText addAttributes:attri range:[text rangeOfString:text]];
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin |    NSStringDrawingUsesFontLeading
                                  attributes:attri
                                     context:nil].size;
    textLayer.frame = CGRectMake(0, 0, size.width, size.height);
    textLayer.string = attriText;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

@end
