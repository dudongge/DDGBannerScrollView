//
//  DDGHorizontalPageControl.m
//  MyApp
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import "DDGHorizontalPageControl.h"

@interface DDGHorizontalPageControl()
@property (nonatomic, strong) NSMutableArray<UIView *> *pageDots;
@end

@implementation DDGHorizontalPageControl

- (instancetype)init {
   self = [ super init];
    if (self) {
       [self _initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews {
    _dotNomalSize = CGSizeMake(6, 6);
    _dotBigSize = CGSizeMake(18, 6);
    _dotMargin = 6;
    _startPage = 0;
    _dotAlpha = 0.5;
}

- (void)setCurrentPage:(NSInteger)page {
    CGFloat dotNomalWidth  = self.dotNomalSize.width;
    CGFloat dotNomalHeight = self.dotNomalSize.height;
    CGFloat dotBigWidth    = self.dotBigSize.width;
    CGFloat dotBigHeight   = self.dotBigSize.height;
    [UIView animateWithDuration:1.0 animations:^{
        for (int i = 0; i < self.pages; i ++) {
            if (page == i) {
                self.pageDots[i].frame = CGRectMake(i * (dotNomalWidth + self.dotMargin), 0, dotBigWidth, dotBigHeight);
                self.pageDots[i].backgroundColor = self.currentPageColor;
            } else {
                if (i < page) {
                    self.pageDots[i].frame = CGRectMake(i * (dotNomalWidth + self.dotMargin), 0, dotNomalWidth, dotNomalHeight);
                } else {
                    self.pageDots[i].frame = CGRectMake((dotBigWidth - dotNomalWidth) + i * (dotNomalWidth + self.dotMargin), 0, dotNomalWidth, dotNomalHeight);
                }
                self.pageDots[i].backgroundColor = self.normalPageColor;
            }
        }
    }];
}

- (void)updateCurrentPage:(NSInteger)page offset:(CGFloat)offset {
    
}

- (void)setDotNomalSize:(CGSize)dotNomalSize {
    _dotNomalSize = dotNomalSize;
    [self updateColor];
}

- (void)setDotBigSize:(CGSize)dotBigSize {
    _dotBigSize = dotBigSize;
    [self updateColor];
}

- (void)setDotMargin:(CGFloat)dotMargin {
    _dotMargin = dotMargin;
    [self updateColor];
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    if (!_pageDots) {
        [self pageDots];
    } else {
        [self updateColor];
    }
}

- (void)setNormalPageColor:(UIColor *)normalPageColor {
    _normalPageColor = normalPageColor;
    if (!_pageDots) {
        [self pageDots];
    } else {
        [self updateColor];
    }
}

- (void)setPages:(NSInteger)pages {
    _pages = pages;
    if (0 == pages) return;
    if (_pageDots && 0 == _pageDots.count) {
        _pageDots = nil;
        [self pageDots];
    }
    else [self pageDots];
    [self updateColor];
}

- (void)setStartPagee:(NSInteger)startPage {
    _startPage = startPage;
    [self updateCurrentPage:startPage offset:0];
}

- (void)setDotAlpha:(CGFloat)dotAlpha {
    _dotAlpha = dotAlpha;
}

- (void)updateColor {
    CGFloat dotNomalWidth  = self.dotNomalSize.width;
    CGFloat dotNomalHeight = self.dotNomalSize.height;
    CGFloat dotBigWidth    = self.dotBigSize.width;
    CGFloat dotBigHeight   = self.dotBigSize.height;
     [self pageDots];
    for (int i = 0; i < self.pages; i ++) {
        if (_startPage == i) {
            self.pageDots[i].frame = CGRectMake(i * (dotNomalWidth + self.dotMargin), 0, dotBigWidth, dotBigHeight);
            self.pageDots[i].layer.cornerRadius = self.pageDots[i].frame.size.height / 2.0;
            self.pageDots[i].alpha = _dotAlpha ? _dotAlpha : 0.5 ;
            self.pageDots[i].backgroundColor = (self.currentPageColor ? self.currentPageColor : UIColor.whiteColor);
        } else {
            if (i < _startPage) {
                self.pageDots[i].frame = CGRectMake(i * (dotNomalWidth + self.dotMargin), 0, dotNomalWidth, dotNomalHeight);
            } else {
                self.pageDots[i].frame = CGRectMake((dotBigWidth - dotNomalWidth ) + i * (self.dotMargin + dotNomalWidth), 0, dotNomalWidth, dotNomalHeight);
            }
            self.pageDots[i].alpha = _dotAlpha ? _dotAlpha : 0.5 ;
            self.pageDots[i].layer.cornerRadius = self.pageDots[i].frame.size.height / 2.0;
            self.pageDots[i].backgroundColor = (self.normalPageColor ? self.normalPageColor : UIColor.grayColor);
        }
    }
}

- (NSMutableArray *)pageDots {
    CGFloat dotNomalWidth  = self.dotNomalSize.width;
    CGFloat dotNomalHeight = self.dotNomalSize.height;
    CGFloat dotBigWidth    = self.dotBigSize.width;
    CGFloat dotBigHeight   = self.dotBigSize.height;
    if (!_pageDots) {
        _pageDots = [NSMutableArray array];
        for (int i = 0; i < self.pages; i ++) {
            UIView *dotView = [[UIView alloc]init];
            if (0 == i) {
                dotView.frame = CGRectMake(0, 0, dotBigWidth, dotBigHeight);
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0;
                dotView.alpha = _dotAlpha ? _dotAlpha : 0.5 ;
                dotView.backgroundColor = (self.currentPageColor ? self.currentPageColor : UIColor.whiteColor);
            } else {
                dotView.frame = CGRectMake((dotBigWidth - dotNomalWidth ) + i * (self.dotMargin + dotNomalWidth), 0, dotNomalWidth, dotNomalHeight);
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0;
                dotView.alpha = _dotAlpha ? _dotAlpha : 0.5 ;
                dotView.backgroundColor = (self.normalPageColor ? self.normalPageColor : UIColor.blackColor);
            }
            [self addSubview:dotView];
            [_pageDots addObject:dotView];
        }
    }
    return _pageDots;
}

- (void)dealloc {
    NSLog(@"dealloc--DDGHorizontalPageControl");
}

@end
