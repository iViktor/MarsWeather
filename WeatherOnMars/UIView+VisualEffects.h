//
//  UIView+VisualEffects.h
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VisualEffects)

- (void)addMotionEffect;
- (UIVisualEffectView *)insertBlurEffectViewForSize:(CGSize)size overSubView:(UIView *)subView;

@end
