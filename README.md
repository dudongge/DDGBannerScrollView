## 写在前面
```
几乎每个app都会用到图片轮播器，而且图片轮播器也越来越高大上，沉浸式等拉高了APP的档次
，没有一个高大上的图片轮播器，都不好意思上架。
像一些知名的app都采用了图片轮播的背景渐变色，举几个栗子：优酷的首页，喜马拉雅，蜻蜓fm，哔哩哔哩漫画等，
page索引也是玩的很高大上，系统的早已满足不了了需求。
鉴于此和项目的需要，在前人的基础上，整理了一个这个库，志在简单的几句代码，就能让应用看上去高大上。
github:[DDGBannerScrollView](https://github.com/dudongge/DDGBannerScrollView)
```
## DDGBannerScrollView 此库的功能

```
1、无限图片轮播功能
2、每个图片的相对偏移量，方便开发者自己封装东西
3、pageControl的几个动画，（旋转，跳跃等慢慢会增加）

DDGBannerScrollView 用到的知识
1、图片轮播器（UICollectionView + 定时器）
2、一种颜色向另一种颜色线性的渐变。
3、简单的旋转动画（frame动画 CABasicAnimation）
4、简单的贝塞尔曲线（半圆）与动画的组合（UIBezierPath + CAKeyframeAnimation）
```
## 来看看效果(虽然效果不太明显)
![image](https://raw.githubusercontent.com/dudongge/DDGbannerScrollView/master/gif/page0.gif)
### 动画的模块也可单独使用
#
![image](https://raw.githubusercontent.com/dudongge/DDGbannerScrollView/master/gif/page1.gif)!


## 模块分解
####  图片轮播器
```
图片轮播器（UICollectionView + 定时器），这个参考了知名的第三方库SDCycleScrollView，并在此基础上做了修改，文末附有链接
所以在性能和稳定性上有了保证，在此表示感谢。
```
####  两种颜色的线性渐变
![image](https://raw.githubusercontent.com/dudongge/DDGbannerScrollView/master/gif/changeColor.gif)!
```
我们都知道，一个像素点有三原色加上透明度组成，也就是所说的RGBA（红，绿，蓝，透明度），改变其中的任意一个值，给我们呈现的颜色就不一样。
比如，一个点的R1为10，另一个颜色的R2为30，那么R1->R2的线性变化的差值就是20 ,如果滑块的偏移量为100，那么渐变系数为0.2，那么R2 = 10 + 100 * 0.2，
当我们在拉滑块的过程中，R在颜色变化中就是线性的，同理剩余颜色也是渐变的。如上图中的中间View，就是在两个颜色之间过度。
这个关于颜色的扩展，我已经封装到库中，大家可以直接使用。
关键函数为下面，具体实现可参考代码
/**
得到一个颜色的原始值 RGBA

@param originColor 传入颜色
@return 颜色值数组
*/
+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor;

/**
得到两个值的色差

@param beginColor 起始颜色
@param endColor 终止颜色
@return 色差数组
*/
+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor;

/**
传入两个颜色和系数

@param beginColor 开始颜色
@param coe 系数（0->1）
@param endColor 终止颜色
@return 过度颜色
*/
+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor;
```
####  简单的旋转动画和贝塞尔半圆动画
```
简单的旋转动画和贝塞尔半圆动画（比较基础和简单，直接上代码）
/**
添加旋转动画

@param imageView 旋转的目标图片
@param duration 旋转持续时间
@param clockwise 旋转的方向（正向还是逆向）
*/
- (void)startrRotationImageView:(UIImageView *)imageView duration:(CGFloat)duration clockwise:(BOOL)clockwise {
    CABasicAnimation* rotationAnimation;
    //动画的方式，绕着z轴
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //旋转的弧度
    rotationAnimation.toValue = [NSNumber numberWithFloat: clockwise ? M_PI * 2.0 : -M_PI * 2.0 ];
    //动画持续的时间
    rotationAnimation.duration = duration;
    //动画角度值是否累加（默认为NO）
    rotationAnimation.cumulative = NO;
    //重复次数
    rotationAnimation.repeatCount = 1;
    //动画添加到layer上
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
沿着UIBezierPath运动

@param imageView 目标b图片
@param duration 动画持续时间
@param controlPoint 控制点
@param clockwise 旋转方向（正向还是逆向）
*/
- (void)startrRotationImageView:(UIImageView *)imageView duration:(CGFloat)duration controlPoint:(CGPoint)controlPoint clockwise:(BOOL)clockwise {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation.keyPath = @"position";
    //设置动画时间
    animation.duration = duration;
    // 告诉在动画结束的时候不要移除
    animation.removedOnCompletion = YES;
    // 始终保持最新的效果
    //animation.fillMode = kCAFillModeForwards;
    //贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:controlPoint radius:((_dotMargin + _dotNomalSize.width ) /2.0) startAngle: clockwise ? M_PI : 0 endAngle: clockwise ? 0 : M_PI clockwise: clockwise];
    // 设置贝塞尔曲线路径
    animation.path = circlePath.CGPath;
    // 将动画对象添加到视图的layer上
    [imageView.layer addAnimation:animation forKey:@"position"];
}

```
## 如何使用
```
1，下载本demo，直接将DDGBannerScrollView文件夹下的文件拖入即可，详细使用见demo和源码
2，pod 'DDGBannerScrollView'
```
### 简单代码
```
//头部banner图片
@property (nonatomic, strong) DDGBannerScrollView *bannerScrollView;
//头部banner背景图片
@property (nonatomic, strong) UIView *bgHeaderView;
- (UIView *)bgHeaderView {
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIView alloc]init];
        _bgHeaderView.frame = CGRectMake(0,0, screen_width , screen_width * 0.37 + 120);
    }
    return _bgHeaderView;
}

- (DDGBannerScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        CGRect frame = CGRectMake(30, 88, self.view.frame.size.width - 60, screen_width * 0.37);
        _bannerScrollView = [DDGBannerScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"cache_cancel_all"]];
        _bannerScrollView.imageURLStringsGroup = @[@"3",@"1",@"2",@"1",@"3"];
    }
    return _bannerScrollView;
}

[self.bgHeaderView addSubview:self.bannerScrollView];
self.bannerScrollView.pageControlAliment = DDGBannerScrollViewPageContolAlimentRight;
self.bannerScrollView.pageControlStyle = DDGBannerScrollViewPageControlHorizontal;
self.bannerScrollView.pageDotColor = UIColor.greenColor;
self.bannerScrollView.currentPageDotColor = UIColor.redColor;

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
```




## 写在最后
奉上github地址:[DDGBannerScrollView](https://github.com/dudongge/DDGBannerScrollView)

掘金地址：[DDGBannerScrollView](https://github.com/dudongge/DDGBannerScrollView)

简书地址：[DDGBannerScrollView](https://www.jianshu.com/p/f490297f445d)

最后，再次感谢下[SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)的作者，也感谢大家的关心和支持，如果对你有帮助，希望你不吝✨star一下。
