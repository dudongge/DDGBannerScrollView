//
//  DDGBannerScrollView.h
//  DDGBannerScrollView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    DDGBannerScrollViewPageContolAlimentRight,
    DDGBannerScrollViewPageContolAlimentCenter,
    DDGBannerScrollViewPageContolAlimentLeft
} DDGBannerScrollViewPageContolAliment;

typedef enum {
    DDGBannerScrollViewPageContolStyleClassic,        // 系统自带经典样式
    DDGBannerScrollViewPageContolStyleAnimated,       // 动画效果--直接显示
    DDGBannerScrollViewPageControlHorizontal,         // 水平动态滑块
    DDGBannerScrollViewPageImageRotation,             // 旋转前进
    DDGBannerScrollViewPageImageJump,                 // 以半圆跳跃前进
    DDGBannerScrollViewPageImageAnimated,             // 动画滑动前进
    DDGBannerScrollViewPageContolStyleNone            // 不显示pagecontrol
} DDGBannerScrollViewPageContolStyle;

@class DDGBannerScrollView;

@protocol DDGBannerScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleScrollView:(DDGBannerScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(DDGBannerScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;






// 不需要自定义轮播cell的请忽略以下两个的代理方法

// ========== 轮播自定义cell ==========

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForCycleScrollView:(DDGBannerScrollView *)view;

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCollectionViewCellNibForCycleScrollView:(DDGBannerScrollView *)view;

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(DDGBannerScrollView *)view;

@end

@interface DDGBannerScrollView : UIView


/** 初始轮播图（推荐使用） */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<DDGBannerScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLStringsGroup;


/** 本地图片轮播初始化方式 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup;

/** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup;


//////////////////////  数据源API //////////////////////

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;





//////////////////////  滚动控制API //////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<DDGBannerScrollViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

//////////////////////  自定义样式API  //////////////////////

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) DDGBannerScrollViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) DDGBannerScrollViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

/** 滑动的时候返回当前滑动的距离 */
@property (nonatomic, copy) void(^cycleScrollViewBlock)(NSInteger offset);

/** 滚动手势禁用（文字轮播较实用） */
- (void)disableScrollGesture;


//////////////////////  清除缓存API  //////////////////////

/** 清除图片缓存（此次升级后统一使用DDGWebImage管理图片加载和缓存）  */
+ (void)clearImagesCache;

/** 清除图片缓存（兼容旧版本方法） */
- (void)clearCache;

@end
