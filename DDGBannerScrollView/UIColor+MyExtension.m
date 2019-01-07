//
//  UIColor+MyExtension.m
//  MyApp
//
//  Created by dudongge on 2018/12/25.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import "UIColor+MyExtension.h"

@implementation UIColor (MyExtension)

/**
 16进制颜色转换为UIColor
 
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity {
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}


+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor {
    CGFloat r = 0,g = 0,b = 0,a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r),@(g),@(b)];
}

+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self getRGBDictionaryByColor:endColor];
    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]),@([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]),@([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
}

+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray *marginArray = [self transColorBeginColor:beginColor andEndColor:endColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
