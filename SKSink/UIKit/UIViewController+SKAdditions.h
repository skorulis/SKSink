//  Created by Alexander Skorulis on 13/01/2016.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (SKAdditions)

- (void)sk_addChildViewController:(UIViewController *)childViewController inSubView:(UIView *)subView;
- (UIView*)sk_topLayoutView;
- (UIView*)sk_bottomLayoutView;

@end
