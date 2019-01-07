//
//  TAAbstractDotView.m
//  TAPageControl
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import "DDGAbstractDotView.h"


@implementation DDGAbstractDotView


- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}


- (void)changeActivityState:(BOOL)active {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

@end
