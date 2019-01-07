//
//  UIView+DDGExtension.h
//  DDGRefreshView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import <UIKit/UIKit.h>

#define DDGColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]


@interface UIView (DDGExtension)

@property (nonatomic, assign) CGFloat ddg_height;
@property (nonatomic, assign) CGFloat ddg_width;

@property (nonatomic, assign) CGFloat ddg_y;
@property (nonatomic, assign) CGFloat ddg_x;

@end
