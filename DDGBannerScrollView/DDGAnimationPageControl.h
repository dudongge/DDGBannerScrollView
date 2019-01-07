//
//  DDGAnimationPageControl.h
//  MyApp
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    DDGAnimationPageControlNoamal,                          //正常状态下动画
    DDGAnimationPageControlRotation,                        //旋转动画
    DDGAnimationPageControlJump,                            //跳跃旋转动画
} DDGAnimationPageControlType;

@interface DDGAnimationPageControl : UIView

/**
 all pages 要加载的页数
 */
@property (nonatomic, assign) NSInteger                   pages;

/**
 startPage 开始的索引
 */
@property (nonatomic, assign) NSInteger                   startPage;

/**
 dotAlpha 使用渐变时的透明度
 */
@property (nonatomic, assign) CGFloat                     dotAlpha;

/**
 dotMargin pageControl间距
 */
@property (nonatomic, assign) CGFloat                     dotMargin;

/**
 dotNomalSize 未选中下的大小
 */
@property (nonatomic, assign) CGSize                      dotNomalSize;

/**
 dotBigSize （选中）当前下的大小
 */
@property (nonatomic, assign) CGSize                      dotBigSize;

/**
 currentPageImage 选中时的图片
 */
@property (nonatomic, strong) UIImage                     *currentPageImage;

/**
 normalPageImage 正常时的图片
 */
@property (nonatomic, strong) UIImage                     *normalPageImage;

/**
 animationType 动画类型
 */
@property (nonatomic, assign) DDGAnimationPageControlType  animationType;


/**
 更新当前页面
 
 @param page 当前页面的索引
 */
- (void)setCurrentPage:(NSInteger)page ;


/**
 初始化方法

 @param frame frame大小
 @param pages 总共的页数
 @param currentPageImage 当前的（选中）显示的图片
 @param normalPageImage 正常（未选中）显示的图片
 @return DDGAnimationPageControl 的实例
 */
+ (instancetype)initWithinitWithFrame:(CGRect)frame pageCount:(NSInteger)pages currentPageImage:(UIImage *)currentPageImage normalPageImage:(UIImage *)normalPageImage;


/**
 初始化方法

 @param frame frame大小
 @param pages 总共的页数
 @param startPage 从第几个开始（开始的索引）
 @param currentPageImage 当前的（选中）显示的图片
 @param normalPageImage 正常（未选中）显示的图片
 @return DDGAnimationPageControl 的实例
 */
+ (instancetype)initWithinitWithFrame:(CGRect)frame pageCount:(NSInteger)pages startPage:(NSInteger)startPage currentPageImage:(UIImage *)currentPageImage normalPageImage:(UIImage *)normalPageImage;


/**
 初始化方法
 
 @param frame frame大小
 @param dotBigSize 当前的（选中）显示的图片的大小
 @param dotNomalSize 正常（未选中）显示的图片的大小
 @param dotMargin 图片间距
 @param pages 总共的页数
 @param startPage 从第几个开始（开始的索引）
 @param currentPageImage 当前的（选中）显示的图片
 @param normalPageImage 正常（未选中）显示的图片
 @return DDGAnimationPageControl 的实例
 */
+ (instancetype)initWithinitWithFrame:(CGRect)frame dotBigSize:(CGSize)dotBigSize dotNomalSize:(CGSize)dotNomalSize dotMargin:(CGFloat)dotMargin pageCount:(NSInteger)pages startPage:(NSInteger)startPage currentPageImage:(UIImage *)currentPageImage normalPageImage:(UIImage *)normalPageImage;

@end

