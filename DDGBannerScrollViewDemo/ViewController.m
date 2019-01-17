//
//  ViewController.m
//  DDGBannerScrollViewDemo
//
//  Created by dudongge on 2019/1/7.
//  Copyright © 2019 dudongge. All rights reserved.
//

#import "ViewController.h"
#import "DDGBannerScrollView.h"
#import "UIColor+MyExtension.h"
#import "DDGHorizontalPageControl.h"
#import "DDGAnimationPageControl.h"

//屏幕宽度
#define screen_width [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<DDGBannerScrollViewDelegate>

@property (nonatomic, strong) DDGBannerScrollView *bannerScrollView;
@property (nonatomic, strong) DDGBannerScrollView *midBannerScrollView;
@property (nonatomic, strong) DDGBannerScrollView *jumpBannerScrollView;
@property (nonatomic, strong) UIView *bgHeaderView;
@property (nonatomic, strong) UIView *midHeaderView;
@property (nonatomic, strong) UIView *jumpHeaderView;
@property (nonatomic, strong) UIView *bgRotationView;
@property (nonatomic, strong) NSMutableArray *changeColors;
@property (nonatomic, strong) NSMutableArray *midChangeColors;
@property (nonatomic, strong) NSMutableArray *jumpChangeColors;
@property (nonatomic, strong) DDGHorizontalPageControl *horizontalPageControl;
@property (nonatomic, strong) DDGAnimationPageControl *animationPageControl;
@property (nonatomic, strong) DDGAnimationPageControl *myAnimationJumpControl;
@property (nonatomic, strong) DDGAnimationPageControl *myAnimationRotationControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView addSubview:self.bannerScrollView];
    self.bannerScrollView.pageControlAliment = DDGBannerScrollViewPageContolAlimentRight;
    self.bannerScrollView.pageControlStyle = DDGBannerScrollViewPageControlHorizontal;
    self.bannerScrollView.pageDotColor = UIColor.greenColor;
    self.bannerScrollView.currentPageDotColor = UIColor.redColor;
    
    [self.view addSubview:self.midHeaderView];
    [self.midHeaderView addSubview: self.midBannerScrollView];
    self.midBannerScrollView.pageControlAliment = DDGBannerScrollViewPageContolAlimentRight;
    self.midBannerScrollView.pageControlStyle = DDGBannerScrollViewPageImageAnimated;
    self.midBannerScrollView.pageDotImage = [UIImage imageNamed:@"page_normal"];
    self.midBannerScrollView.currentPageDotImage = [UIImage imageNamed:@"page_current"];
    
    
    [self.view addSubview:self.jumpHeaderView];
    [self.jumpHeaderView addSubview: self.jumpBannerScrollView];
    self.jumpBannerScrollView.pageControlAliment = DDGBannerScrollViewPageContolAlimentRight;
    self.jumpBannerScrollView.pageControlStyle = DDGBannerScrollViewPageImageJump;
    self.jumpBannerScrollView.pageDotImage = [UIImage imageNamed:@"page_normal"];
    self.jumpBannerScrollView.currentPageDotImage = [UIImage imageNamed:@"page_current"];
    
   // [self.view addSubview: self.bgRotationView];
    //[self.bgRotationView addSubview: self.horizontalPageControl];
    //[self.bgRotationView addSubview: self.animationPageControl];
    
    //[self.bgRotationView addSubview: self.myAnimationJumpControl];
    //    [self.bgRotationView addSubview: self.myAnimationRotationControl];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self) return;
       
    });
    
    
    __weak typeof(self) weakSelf = self;;
    self.bannerScrollView.cycleScrollViewBlock = ^(NSInteger offset) {
        [weakSelf handelBannerBgColorWithOffset:offset];
    };
    
    self.midBannerScrollView.cycleScrollViewBlock = ^(NSInteger offset) {
        [weakSelf handelMidBannerBgColorWithOffset:offset];
    };
    
    self.jumpBannerScrollView.cycleScrollViewBlock = ^(NSInteger offset) {
        [weakSelf handelJunpBannerBgColorWithOffset:offset];
    };
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)cycleScrollView:(DDGBannerScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [self.horizontalPageControl setCurrentPage:index];
    //[self.animationPageControl setCurrentPage:index];
    //[self.myAnimationJumpControl setCurrentPage:index];
    //[self.myAnimationRotationControl setCurrentPage:index];
}

//根据偏移量计算设置banner背景颜色
- (void)handelBannerBgColorWithOffset:(NSInteger )offset {
    if (1 == self.changeColors.count) return;
    NSInteger offsetCurrent = offset % (int)self.bannerScrollView.bounds.size.width ;
    float rate = offsetCurrent / self.bannerScrollView.bounds.size.width ;
    NSInteger currentPage = offset / (int)self.bannerScrollView.bounds.size.width;
    UIColor *startPageColor;
    UIColor *endPageColor;
    if (currentPage == self.changeColors.count - 1) {
        startPageColor = self.changeColors[currentPage];
        endPageColor = self.changeColors[0];
    } else {
        if (currentPage  == self.changeColors.count) {
            return;
        }
        startPageColor = self.changeColors[currentPage];
        endPageColor = self.changeColors[currentPage + 1];
    }
    UIColor *currentToLastColor = [UIColor getColorWithColor:startPageColor andCoe:rate andEndColor:endPageColor];
    self.bgHeaderView.backgroundColor = currentToLastColor;
}

//根据偏移量计算设置banner背景颜色
- (void)handelMidBannerBgColorWithOffset:(NSInteger )offset {
    if (1 == self.midChangeColors.count) return;
    NSInteger offsetCurrent = offset % (int)self.midBannerScrollView.bounds.size.width ;
    float rate = offsetCurrent / self.midBannerScrollView.bounds.size.width ;
    NSInteger currentPage = offset / (int)self.midBannerScrollView.bounds.size.width;
    UIColor *midStartPageColor;
    UIColor *midEndPageColor;
    if (currentPage == self.midChangeColors.count - 1) {
        midStartPageColor = self.midChangeColors[currentPage];
        midEndPageColor = self.midChangeColors[0];
    } else {
        if (currentPage  == self.midChangeColors.count) {
            return;
        }
        midStartPageColor = self.midChangeColors[currentPage];
        midEndPageColor = self.midChangeColors[currentPage + 1];
    }
    UIColor *midCurrentToLastColor = [UIColor getColorWithColor:midStartPageColor andCoe:rate andEndColor:midEndPageColor];
    self.midHeaderView.backgroundColor = midCurrentToLastColor;
}

//根据偏移量计算设置banner背景颜色
- (void)handelJunpBannerBgColorWithOffset:(NSInteger )offset {
    if (1 == self.jumpChangeColors.count) return;
    NSInteger offsetCurrent = offset % (int)self.jumpBannerScrollView.bounds.size.width ;
    float rate = offsetCurrent / self.jumpBannerScrollView.bounds.size.width ;
    NSInteger currentPage = offset / (int)self.jumpBannerScrollView.bounds.size.width;
    UIColor *midStartPageColor;
    UIColor *midEndPageColor;
    if (currentPage == self.jumpChangeColors.count - 1) {
        midStartPageColor = self.jumpChangeColors[currentPage];
        midEndPageColor = self.jumpChangeColors[0];
    } else {
        if (currentPage  == self.jumpChangeColors.count) {
            return;
        }
        midStartPageColor = self.jumpChangeColors[currentPage];
        midEndPageColor = self.jumpChangeColors[currentPage + 1];
    }
    UIColor *midCurrentToLastColor = [UIColor getColorWithColor:midStartPageColor andCoe:rate andEndColor:midEndPageColor];
    self.jumpHeaderView.backgroundColor = midCurrentToLastColor;
}

- (DDGBannerScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        CGRect frame = CGRectMake(30, 88, self.view.frame.size.width - 60, screen_width * 0.37);
        _bannerScrollView = [DDGBannerScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"cache_cancel_all"]];
        _bannerScrollView.imageURLStringsGroup = @[@"3",@"1",@"2",@"1",@"3"];
    }
    return _bannerScrollView;
}

- (DDGBannerScrollView *)midBannerScrollView {
    if (!_midBannerScrollView) {
        
        CGRect frame = CGRectMake(30, 88, screen_width - 60, screen_width * 0.37);
        _midBannerScrollView = [DDGBannerScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"cache_cancel_all"]];
        _midBannerScrollView.imageURLStringsGroup = @[@"2",@"3",@"1",@"3",@"1"];
    }
    return _midBannerScrollView;
}
- (DDGBannerScrollView *)jumpBannerScrollView {
    if (!_jumpBannerScrollView) {
        
        CGRect frame = CGRectMake(30, 88, screen_width - 60, screen_width * 0.37);
        _jumpBannerScrollView = [DDGBannerScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"cache_cancel_all"]];
        _jumpBannerScrollView.imageURLStringsGroup = @[@"1",@"2",@"3",@"2",@"1"];
    }
    return _jumpBannerScrollView;
}

- (UIView *)bgHeaderView {
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIView alloc]init];
        _bgHeaderView.frame = CGRectMake(0,0, screen_width , screen_width * 0.37 + 120);
    }
    return _bgHeaderView;
}

- (UIView *)midHeaderView {
    if (!_midHeaderView) {
        _midHeaderView = [[UIView alloc]init];
        _midHeaderView.frame = CGRectMake(0,screen_width * 0.37 + 130, screen_width, screen_width * 0.37 + 120);
    }
    return _midHeaderView;
}

- (UIView *)jumpHeaderView {
    if (!_jumpHeaderView) {
        _jumpHeaderView = [[UIView alloc]init];
        _jumpHeaderView.frame = CGRectMake(0,(screen_width * 0.37 + 130) * 2, screen_width, screen_width * 0.37 + 120);
    }
    return _jumpHeaderView;
}

- (NSMutableArray *)changeColors {
    if (!_changeColors) {
        UIColor *oneColor   = [UIColor colorWithHexString:@"#FDC0BC" alpha:1.0];
        UIColor *twoColor   = [UIColor colorWithHexString:@"#CBC1FF" alpha:1.0];
        UIColor *threeColor = [UIColor colorWithHexString:@"#C8CFA2" alpha:1.0];
        UIColor *fourColor  = [UIColor colorWithHexString:@"#CBC1FF" alpha:1.0];
        UIColor *fiveColor  = [UIColor colorWithHexString:@"#C8CFA2" alpha:1.0];
        _changeColors = [[NSMutableArray alloc]initWithArray:@[oneColor,twoColor,threeColor,fourColor,fiveColor]];
    }
    return _changeColors;
}

- (NSMutableArray *)midChangeColors {
    if (!_midChangeColors) {
        UIColor *oneColor   = [UIColor colorWithHexString:@"#FD12BC" alpha:1.0];
        UIColor *twoColor   = [UIColor colorWithHexString:@"#1BC1FF" alpha:1.0];
        UIColor *threeColor = [UIColor colorWithHexString:@"#C82FA2" alpha:1.0];
        UIColor *fourColor  = [UIColor colorWithHexString:@"#4BC1FF" alpha:1.0];
        UIColor *fiveColor  = [UIColor colorWithHexString:@"#58C4A2" alpha:1.0];
        _midChangeColors = [[NSMutableArray alloc]initWithArray:@[oneColor,twoColor,threeColor,fourColor,fiveColor]];
    }
    return _midChangeColors;
}
- (NSMutableArray *)jumpChangeColors {
    if (!_jumpChangeColors) {
        UIColor *oneColor   = [UIColor colorWithHexString:@"#1D184C" alpha:1.0];
        UIColor *twoColor   = [UIColor colorWithHexString:@"#35C1FF" alpha:1.0];
        UIColor *threeColor = [UIColor colorWithHexString:@"#242F32" alpha:1.0];
        UIColor *fourColor  = [UIColor colorWithHexString:@"#4BC31F" alpha:1.0];
        UIColor *fiveColor  = [UIColor colorWithHexString:@"#383BA2" alpha:1.0];
        _jumpChangeColors = [[NSMutableArray alloc]initWithArray:@[oneColor,twoColor,threeColor,fourColor,fiveColor]];
    }
    return _jumpChangeColors;
}

- (DDGHorizontalPageControl *)horizontalPageControl {
    if (!_horizontalPageControl) {
        _horizontalPageControl = [[DDGHorizontalPageControl alloc]init];
        _horizontalPageControl.frame = CGRectMake(10, 10, 360, 50);
        _horizontalPageControl.backgroundColor = UIColor.lightGrayColor;
        _horizontalPageControl.currentPageColor = [UIColor whiteColor];
        _horizontalPageControl.normalPageColor = [UIColor grayColor];
        _horizontalPageControl.dotBigSize = CGSizeMake(60, 20);
        _horizontalPageControl.dotNomalSize = CGSizeMake(20, 20);
        _horizontalPageControl.dotMargin = 20;
        _horizontalPageControl.pages = 5;
    }
    return _horizontalPageControl;
}

- (DDGAnimationPageControl *)animationPageControl {
    if (!_animationPageControl) {
        _animationPageControl = [DDGAnimationPageControl initWithinitWithFrame:CGRectMake(10, 80, 360, 50)
                                                                    dotBigSize:CGSizeMake(30, 30)
                                                                  dotNomalSize:CGSizeMake(20, 20)
                                                                     dotMargin:20
                                                                     pageCount:5
                                                                     startPage:1
                                                              currentPageImage:[UIImage imageNamed:@"page_current"]
                                                               normalPageImage:[UIImage imageNamed:@"page_normal"]];
    }
    return _animationPageControl;
}

- (DDGAnimationPageControl *)myAnimationRotationControl {
    if (!_myAnimationRotationControl) {
        _myAnimationRotationControl = [DDGAnimationPageControl initWithinitWithFrame:CGRectMake(10, 10, 360, 50)
                                                                          dotBigSize:CGSizeMake(30, 30)
                                                                        dotNomalSize:CGSizeMake(20, 20)
                                                                           dotMargin:20
                                                                           pageCount:5
                                                                           startPage:1
                                                                    currentPageImage:[UIImage imageNamed:@"page_current"]
                                                                     normalPageImage:[UIImage imageNamed:@"page_normal"]];
        _myAnimationRotationControl.animationType = DDGAnimationPageControlRotation;
    }
    return _myAnimationRotationControl;
}

- (DDGAnimationPageControl *)myAnimationJumpControl {
    if (!_myAnimationJumpControl) {
        _myAnimationJumpControl = [DDGAnimationPageControl initWithinitWithFrame:CGRectMake(10, 80, 360, 50)
                                                                      dotBigSize:CGSizeMake(30, 30)
                                                                    dotNomalSize:CGSizeMake(20, 20)
                                                                       dotMargin:20
                                                                       pageCount:5
                                                                       startPage:1
                                                                currentPageImage:[UIImage imageNamed:@"page_current"]
                                                                 normalPageImage:[UIImage imageNamed:@"page_normal"]];
        
        _myAnimationJumpControl.animationType = DDGAnimationPageControlJump;
    }
    return _myAnimationJumpControl;
}

- (UIView *)bgRotationView {
    if (!_bgRotationView) {
        _bgRotationView = [[UIView alloc]init];
        _bgRotationView.frame = CGRectMake(10, 550, 360, 120);
        _bgRotationView.backgroundColor = UIColor.lightGrayColor;
    }
    return _bgRotationView;
}

@end



