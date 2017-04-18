//
//  DotTransition.m
//  Transition
//
//  Created by 许毓方 on 2017/4/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "DotZoomTransition.h"

@interface DotZoomTransition ()

@property (nonatomic, assign) CGPoint startPoint;

/**
 startPoint 为圆心的 外切圆
 */
@property (nonatomic, strong) UIView *excircleView;

@property (nonatomic, assign) CGFloat scale;

@end


@implementation DotZoomTransition


+ (instancetype)transitionWithModal:(TransitionMode)mode
                         startPoint:(CGPoint)startPoint
{
    DotZoomTransition *transition = [[self alloc] init];
    
    transition.duration    = 0.5f;
    transition.scale       = 0.001f;
    
    transition.mode        = mode;
    transition.startPoint  = startPoint;
    
    return transition;
}


#pragma mark - <UIViewControllerAnimatedTransitioning>

/**
 动画时间
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}


/**
 动画实现
 note: view动画中心点
       view层次
 
                      containView                     anim
 present,push:   add 外切圆 add toView             toView   外切圆
 dismiss:        insert 外切圆  insert toView      fromView 外切圆
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    /*
    if (CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        <#配置PUSH返回键时的动画中心点#>
    }
     */
    
    if (self.mode == TransitionModePresent) {
        
        self.excircleView = [UIView new];
        [containerView addSubview:self.excircleView];
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        CGPoint center = toView.center;
        toView.center  = self.startPoint;  // 改变center
        toView.alpha   = 0;
        [containerView addSubview:toView];
        
        self.excircleView.frame = [self frameForSize:toView.bounds.size startPoint:self.startPoint];
        self.excircleView.backgroundColor = toView.backgroundColor;
        self.excircleView.center = self.startPoint;
        self.excircleView.layer.cornerRadius = self.excircleView.frame.size.height / 2; // 外切圆
        
        // 初始化
        toView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
        self.excircleView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
        
        // 动画
        [UIView animateWithDuration:self.duration animations:^{
            
            self.excircleView.transform = CGAffineTransformIdentity;
            toView.transform = CGAffineTransformIdentity;
            toView.center    = center;
            toView.alpha     = 1;
        } completion:^(BOOL finished) {
            
            [self.excircleView removeFromSuperview];
            self.excircleView = nil;
            [transitionContext completeTransition:YES];
        }];
        
    }else {
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        self.excircleView = [UIView new];
        self.excircleView.frame = [self frameForSize:fromView.bounds.size startPoint:self.startPoint];
        self.excircleView.layer.cornerRadius = self.excircleView.bounds.size.height / 2;
        self.excircleView.center = self.startPoint;
        self.excircleView.backgroundColor = fromView.backgroundColor;
        [containerView insertSubview:self.excircleView atIndex:0];
        
        UIView *toView  = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView insertSubview:toView atIndex:0];

        // 动画
        [UIView animateWithDuration:self.duration animations:^{
            
            self.excircleView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
            fromView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
            fromView.center = self.startPoint;
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
           
            [self.excircleView removeFromSuperview];
            self.excircleView = nil;
            [transitionContext completeTransition:YES];
        }];
    }
}

// 点为圆心外切正方形
- (CGRect)frameForSize:(CGSize)originalSize startPoint:(CGPoint)startPoint
{
    CGFloat lengthX = fmax(startPoint.x, originalSize.width - startPoint.x);
    CGFloat lengthY = fmax(startPoint.y, originalSize.height - startPoint.y);
    CGFloat offset  = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
    
    return CGRectMake(0, 0, offset, offset);
}


@end
