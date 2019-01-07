//
//  TAAbstractDotView.h
//  TAPageControl
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDGAbstractDotView : UIView

/**
 *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
 *
 *  @param active BOOL to tell if view is active or not
 */
- (void)changeActivityState:(BOOL)active;

@end

