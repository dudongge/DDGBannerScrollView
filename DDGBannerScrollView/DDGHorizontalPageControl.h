//
//  DDGHorizontalPageControl.h
//  MyApp
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDGHorizontalPageControl : UIView

/**
 all pages 要加载的页数
 */
@property (nonatomic, assign) NSInteger  pages;

/**
 startPage 开始的索引
 */
@property (nonatomic, assign) NSInteger  startPage;

/**
 dotAlpha 使用渐变时的透明度
 */
@property (nonatomic, assign) CGFloat    dotAlpha;

/**
 dotMargin pageControl间距
 */
@property (nonatomic, assign) CGFloat    dotMargin;

/**
 dotNomalSize 未选中下的大小
 */
@property (nonatomic, assign) CGSize     dotNomalSize;

/**
 dotBigSize 当前下的大小
 */
@property (nonatomic, assign) CGSize     dotBigSize;

/**
 currentPageColor 当前索引的颜色
 */
@property (nonatomic, strong) UIColor    *currentPageColor;

/**
 normalPageColor 正常状态下索引的颜色
 */
@property (nonatomic, strong) UIColor    *normalPageColor;


/**
 更新当前页面

 @param page 当前页面的索引
 */
- (void)setCurrentPage:(NSInteger)page ;

///暂时没有用
- (void)updateCurrentPage:(NSInteger)page offset:(CGFloat)offset;

@end


