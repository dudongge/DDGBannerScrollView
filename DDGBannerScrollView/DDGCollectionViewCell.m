//
//  DDGCollectionViewCell.m
//  DDGCycleScrollView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import "DDGCollectionViewCell.h"
#import "UIView+DDGExtension.h"

@implementation DDGCollectionViewCell
{
    __weak UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor {
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont {
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment {
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.ddg_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.ddg_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}

@end
