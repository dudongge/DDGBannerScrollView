//
//  DDGBannerScrollView.m
//  DDGBannerScrollView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import "DDGBannerScrollView.h"
#import "DDGCollectionViewCell.h"
#import "UIView+DDGExtension.h"
#import "DDGPageControl.h"
#import "DDGHorizontalPageControl.h"
#import "DDGAnimationPageControl.h"

#define kCycleScrollViewInitialPageControlDotSize CGSizeMake(10, 10)

NSString * const ID = @"DDGBannerScrollViewCell";

@interface DDGBannerScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIView *pageControl;
@property (nonatomic, weak) DDGHorizontalPageControl *horizontalPageControl;
@property (nonatomic, weak) DDGAnimationPageControl  *gAnimationPageControl;
@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图

@end

@implementation DDGBannerScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (void)initialization {
    _pageControlAliment = DDGBannerScrollViewPageContolAlimentCenter;
    _autoScrollTimeInterval = 2.0;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _showPageControl = YES;
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _pageControlStyle = DDGBannerScrollViewPageContolStyleClassic;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor lightGrayColor];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup pageControlStyle:(DDGBannerScrollViewPageContolStyle)pageControlStyle {
    DDGBannerScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup {
    DDGBannerScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = infiniteLoop;
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup {
    DDGBannerScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageURLsGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup {
    DDGBannerScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagePathsGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<DDGBannerScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage {
    DDGBannerScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    
    return cycleScrollView;
}

// 设置显示图片的collectionView
- (void)setupMainView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[DDGCollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - properties

- (void)setDelegate:(id<DDGBannerScrollViewDelegate>)delegate {
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)] && [self.delegate customCollectionViewCellClassForCycleScrollView:self]) {
        [self.mainView registerClass:[self.delegate customCollectionViewCellClassForCycleScrollView:self] forCellWithReuseIdentifier:ID];
    }else if ([self.delegate respondsToSelector:@selector(customCollectionViewCellNibForCycleScrollView:)] && [self.delegate customCollectionViewCellNibForCycleScrollView:self]) {
        [self.mainView registerNib:[self.delegate customCollectionViewCellNibForCycleScrollView:self] forCellWithReuseIdentifier:ID];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.mainView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageContol = (DDGPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageControl = (DDGPageControl *)_pageControl;
        pageControl.dotColor = currentPageDotColor;
    } else if ([self.pageControl isKindOfClass:[DDGHorizontalPageControl class]]) {
        DDGHorizontalPageControl *pageControl = (DDGHorizontalPageControl *)_pageControl;
        pageControl.currentPageColor = currentPageDotColor;
    }else if ([self.pageControl isKindOfClass:[DDGAnimationPageControl class]]) {
        
    } else {
        
    }
    
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    } else if ([self.pageControl isKindOfClass:[DDGHorizontalPageControl class]]){
        DDGHorizontalPageControl *pageControl = (DDGHorizontalPageControl *)_pageControl;
        pageControl.normalPageColor = pageDotColor;
    } else if ([self.pageControl isKindOfClass:[DDGAnimationPageControl class]]){

    } else {
        
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage {
    _pageDotImage = pageDotImage;
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot {
    if (!image || !self.pageControl) return;
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageControl = (DDGPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage        = image;
        }
    } else if ([self.pageControl isKindOfClass:[DDGAnimationPageControl class]]) {
        DDGAnimationPageControl *pageControl = (DDGAnimationPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentPageImage = image;
        } else {
            pageControl.normalPageImage  = image;
        }
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(DDGBannerScrollViewPageContolStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
    
    [self setupPageControl];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    [self invalidateTimer];
    
    _imagePathsGroup = imagePathsGroup;
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    if (imagePathsGroup.count > 1) { // 由于 !=1 包含count == 0等情况
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setTitlesGroup:(NSArray *)titlesGroup {
    _titlesGroup = titlesGroup;
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageURLStringsGroup = [temp copy];
    }
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

#pragma mark - actions

- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl {
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    if (self.imagePathsGroup.count == 0 || self.onlyDisplayText) return;
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) return;
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (self.pageControlStyle) {
        case DDGBannerScrollViewPageContolStyleAnimated: {
            DDGPageControl *pageControl = [[DDGPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case DDGBannerScrollViewPageContolStyleClassic: {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case DDGBannerScrollViewPageControlHorizontal: {
            if (self.pageControl) {
                [self.pageControl removeFromSuperview];
            }
            DDGHorizontalPageControl *pageControl = [[DDGHorizontalPageControl alloc] init];
            pageControl.pages = self.imagePathsGroup.count;
            pageControl.currentPageColor = self.currentPageDotColor;
            pageControl.normalPageColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case DDGBannerScrollViewPageImageRotation: {
            DDGAnimationPageControl *pageControl = [[DDGAnimationPageControl alloc] init];
            pageControl.pages = self.imagePathsGroup.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = DDGAnimationPageControlRotation;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case DDGBannerScrollViewPageImageJump: {
            DDGAnimationPageControl *pageControl = [[DDGAnimationPageControl alloc] init];
            pageControl.pages = self.imagePathsGroup.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = DDGAnimationPageControlJump;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = (UIPageControl *)pageControl;
        }
            break;
        case DDGBannerScrollViewPageImageAnimated: {
            DDGAnimationPageControl *pageControl = [[DDGAnimationPageControl alloc] init];
            pageControl.pages = self.imagePathsGroup.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = DDGAnimationPageControlNoamal;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = (UIPageControl *)pageControl;
        }
            break;
        case DDGBannerScrollViewPageContolStyleNone: {}
            break;
        default:
            break;
    }
    
    // 重设pagecontroldot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}


- (void)automaticScroll {
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex {
    if (_mainView.ddg_width == 0 || _mainView.ddg_height == 0) {
        return 0;
    }
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.99) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.99) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imagePathsGroup.count;
}

- (void)clearCache {
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache {
    //如果用用了SDWebImageManager，可以清理
    //[[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
}

#pragma mark - life circles

- (void)layoutSubviews {
    self.delegate = self.delegate;
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageControl = (DDGPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
    } else if ([self.pageControl isKindOfClass:[DDGAnimationPageControl class]]) {
        DDGAnimationPageControl *pageControl = (DDGAnimationPageControl *)_pageControl;
        //size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
        CGFloat dotWidth   = pageControl.dotBigSize.width;
        CGFloat dotHeight  = pageControl.dotBigSize.height;
        CGFloat dotMargin  = pageControl.dotMargin;
        size = CGSizeMake(self.imagePathsGroup.count * (dotWidth + dotMargin),dotHeight);
    } else {
        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (self.ddg_width - size.width) * 0.5;
    if (self.pageControlAliment == DDGBannerScrollViewPageContolAlimentRight) {
        x = self.mainView.ddg_width - size.width - 10;
    } else if(self.pageControlAliment == DDGBannerScrollViewPageContolAlimentLeft) {
        x = 20;
    }
    CGFloat y = self.mainView.ddg_height - size.height - 10;
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageControl = (DDGPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
    
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - public actions

- (void)adjustWhenControllerViewWillAppera {
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
        [self.delegate respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)] && [self.delegate customCollectionViewCellClassForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }else if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
              [self.delegate respondsToSelector:@selector(customCollectionViewCellNibForCycleScrollView:)] && [self.delegate customCollectionViewCellNibForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    if (!self.onlyDisplayText && [imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            //此接口为sd_setImageWithURL 留用
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if (!self.onlyDisplayText && [imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (_titlesGroup.count && itemIndex < _titlesGroup.count) {
        cell.title = _titlesGroup[itemIndex];
    }
    
    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextAlignment = self.titleLabelTextAlignment;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        cell.onlyDisplayText = self.onlyDisplayText;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat totalImagewidth = self.bounds.size.width * self.imagePathsGroup.count;
    CGFloat currentOffset = _mainView.contentOffset.x - self.bounds.size.width * 50 * self.imagePathsGroup.count;
    CGFloat realOffset;
    if (currentOffset > 0) {
        realOffset = (int)currentOffset % (int)totalImagewidth;
    } else {
        realOffset = (int)currentOffset % (int)totalImagewidth + totalImagewidth;
    }
    
    if (self.cycleScrollViewBlock) {
        self.cycleScrollViewBlock((int)realOffset);
    }
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.pageControl isKindOfClass:[DDGPageControl class]]) {
        DDGPageControl *pageControl = (DDGPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }  else if ([self.pageControl isKindOfClass:[DDGHorizontalPageControl class]]) {
        DDGHorizontalPageControl *pageControl = (DDGHorizontalPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
        [pageControl setCurrentPage:indexOnPageControl];
    } else {
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
        if ([self.pageControl isKindOfClass:[DDGAnimationPageControl class]]) {
            DDGAnimationPageControl *pageControl = (DDGAnimationPageControl *)_pageControl;
            [pageControl setCurrentPage:indexOnPageControl];
            NSLog(@"当前是第几页%d",indexOnPageControl);
        }
    } else if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(indexOnPageControl);
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == _totalItemsCount) return;
    
    [self scrollToIndex:(int)(_totalItemsCount * 0.5 + index)];
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}

@end
