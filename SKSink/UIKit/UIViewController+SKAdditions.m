//  Created by Alexander Skorulis on 13/01/2016.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

#import "UIViewController+SKAdditions.h"

@implementation UIViewController (SKAdditions)

- (void)sk_addChildViewController:(UIViewController *)childViewController inSubView:(UIView *)subView {
    NSAssert(subView!=nil,@"Attempt to add child view controller into nil subview");
    NSAssert(childViewController!=nil,@"Attempt to add nil child view controller");
    
    childViewController.view.frame = subView.bounds;
    childViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:childViewController];
    [subView addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

#pragma mark layout

- (UIView*)sk_topLayoutView {
    return (UIView*) self.topLayoutGuide;
}

- (UIView*)sk_bottomLayoutView {
    return (UIView*) self.bottomLayoutGuide;
}



@end
