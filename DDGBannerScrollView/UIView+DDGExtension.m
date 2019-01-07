//
//  UIView+DDGExtension.m
//  DDGRefreshView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import "UIView+DDGExtension.h"

@implementation UIView (DDGExtension)

- (CGFloat)ddg_height {
    return self.frame.size.height;
}

- (void)setDdg_height:(CGFloat)ddg_height {
    CGRect temp = self.frame;
    temp.size.height = ddg_height;
    self.frame = temp;
}

- (CGFloat)ddg_width {
    return self.frame.size.width;
}

- (void)setDdg_width:(CGFloat)ddg_width {
    CGRect temp = self.frame;
    temp.size.width = ddg_width;
    self.frame = temp;
}

- (CGFloat)ddg_y {
    return self.frame.origin.y;
}

- (void)setDdg_y:(CGFloat)ddg_y {
    CGRect temp = self.frame;
    temp.origin.y = ddg_y;
    self.frame = temp;
}

- (CGFloat)ddg_x {
    return self.frame.origin.x;
}

- (void)setDdg_x:(CGFloat)ddg_x {
    CGRect temp = self.frame;
    temp.origin.x = ddg_x;
    self.frame = temp;
}

@end
