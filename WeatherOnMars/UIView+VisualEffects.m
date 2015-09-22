//
//  UIView+VisualEffects.m
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import "UIView+VisualEffects.h"

@implementation UIView (VisualEffects)

- (void)addMotionEffect {
    UIInterpolatingMotionEffect *horizontalMotionEffect;
    horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                             type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-45);
    horizontalMotionEffect.maximumRelativeValue = @(45);
    [self addMotionEffect:horizontalMotionEffect];

    UIInterpolatingMotionEffect *verticalMotionEffect;
    verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                           type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-45);
    verticalMotionEffect.maximumRelativeValue = @(45);
    [self addMotionEffect:verticalMotionEffect];
}

- (UIVisualEffectView *)insertBlurEffectViewForSize:(CGSize)size overSubView:(UIView *)subView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    CGFloat rotationSavvyLength = MAX(size.width, size.height);
    [bluredEffectView setFrame:CGRectMake(0, 0, rotationSavvyLength, rotationSavvyLength)];
    [self insertSubview:bluredEffectView aboveSubview:subView];
    return bluredEffectView;
}

@end
