//
//  TADotView.m
//  TAPageControl
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import "DDGDotView.h"

@implementation DDGDotView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (void)initialization {
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 2;
}


- (void)changeActivityState:(BOOL)active {
    if (active) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
