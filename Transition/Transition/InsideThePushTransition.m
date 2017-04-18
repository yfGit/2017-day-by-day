


//
//  InsideThePush.m
//  Transition
//
//  Created by 许毓方 on 2017/4/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "InsideThePushTransition.h"

@interface InsideThePushTransition ()

@property (nonatomic, assign) CGFloat scale;

@end

@implementation InsideThePushTransition

+ (instancetype)transitionWithModal:(TransitionMode)mode
{
    InsideThePushTransition *transition = [[InsideThePushTransition alloc] init];
    transition.duration = 0.5;
    transition.mode = mode;
    transition.scale = 0.95;
    
    return transition;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    
    if (self.mode == TransitionModePresent) {
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView addSubview:toView];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        toView.layer.transform = CATransform3DMakeTranslation(width, 0, 0);
        
        [UIView animateWithDuration:self.duration animations:^{
            
            fromView.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 1);
            toView.layer.transform   = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
            fromView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:YES];
        }];
    }else {
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = toVC.view;
        [containerView insertSubview:toView atIndex:0];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        toView.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 0);
    
        [UIView animateWithDuration:self.duration animations:^{
            
            fromView.layer.transform = CATransform3DMakeTranslation(width, 0, 0);
            toView.layer.transform   = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
            fromView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
