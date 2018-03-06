//
//  BaseViewController.m
//  charts_demo
//
//  Created by zhanghao on 2018/3/6.
//  Copyright © 2018年 TQTeam. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIColor *)colorWithHex:(NSString *)hexString {
    if (!hexString) return nil;
    NSString *hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if (hex.length == 6) {
        hex = [hex stringByAppendingString:@"FF"];
    } else if (hex.length != 8) {
        return nil;
    }
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [self r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}

- (UIColor *)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a {
    return [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.f green:aGreenValue / 255.f blue:aBlueValue / 255.f alpha:1.f];
    return randColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"charts_demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
