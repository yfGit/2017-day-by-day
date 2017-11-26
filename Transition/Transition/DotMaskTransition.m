//
//  DotMaskTransition.m
//  Transition
//
//  Created by 许毓方 on 2017/4/16.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "DotMaskTransition.h"


@interface DotMaskTransition ()<CAAnimationDelegate>

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, copy) void (^animCompelted)();

@end



@implementation DotMaskTransition

+ (instancetype)transitionWithModal:(TransitionMode)mode startPoint:(CGPoint)startPoint
{
    DotMaskTransition *transition = [[DotMaskTransition alloc] init];
    transition.duration = 0.5;
    transition.mode = mode;
    transition.startPoint = startPoint;
    
    return transition;
}



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    
    /*
     if (CGPointEqualToPoint(self.startPoint, CGPointZero)) {
     <#配置PUSH返回键时的动画中心点#>
     }
     */
    
    if (self.mode == TransitionModePresent) {
        
        UIView *toView  = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView addSubview:toView];
        
        CGRect rect = CGRectMake(self.startPoint.x, self.startPoint.y, 2, 2);
        
        CGFloat radius = [self frameForSize:toView.bounds.size startPoint:self.startPoint].size.height / 2;
        
        UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        UIBezierPath *endPath   = [UIBezierPath bezierPathWithArcCenter:containerView.center
                                                                 radius:radius
                                                             startAngle:0
                                                               endAngle:M_PI * 2
                                                              clockwise:YES];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = endPath.CGPath;
        toView.layer.mask = maskLayer;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.duration  = self.duration;
        anim.fromValue = (__bridge id)(startPath.CGPath);
        anim.toValue   = (__bridge id)(endPath.CGPath);
        
        anim.delegate = self;
        
        [maskLayer addAnimation:anim forKey:nil];
        
        self.animCompelted = ^(){ // 延迟, 圆弧太大?
            [maskLayer removeAllAnimations];
            [maskLayer removeFromSuperlayer];
            [transitionContext completeTransition:YES];
        };
        
    }else {
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [containerView insertSubview:toVC.view atIndex:0]; // dismiss 也要加.= =
        
        // 2,2 最终的动画大小
        CGRect rect = CGRectMake(self.startPoint.x, self.startPoint.y, 2, 2);
        
        CGFloat radius = [self frameForSize:fromView.bounds.size startPoint:self.startPoint].size.height / 2;
        
        UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:fromView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        UIBezierPath *endPath   = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = endPath.CGPath;
        fromView.layer.mask = maskLayer;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.fromValue = (__bridge id)startPath.CGPath;
        anim.toValue   = (__bridge id)endPath.CGPath;
        anim.duration  = self.duration;
        anim.delegate  = self;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [maskLayer addAnimation:anim forKey:nil];
        
        self.animCompelted = ^(){ // 需求来定先完成还是先移除
            [transitionContext completeTransition:YES];
            [maskLayer removeAllAnimations];
            [maskLayer removeFromSuperlayer];
        };
        
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (self.animCompelted) {
            self.animCompelted();
        };
    }
}


- (CGRect)frameForSize:(CGSize)originalSize startPoint:(CGPoint)startPoint
{
    CGFloat lengthX = fmax(startPoint.x, originalSize.width - startPoint.x);
    CGFloat lengthY = fmax(startPoint.y, originalSize.height - startPoint.y);
    CGFloat offset  = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
    
    return CGRectMake(0, 0, offset, offset);
}


/*
 UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
 CGRect rect = CGRectMake(containerView.center.x, containerView.center.y, 2, 2);
 CGPoint tempCenter = [fromView convertPoint:self.startPoint toView:toView];
 rect = CGRectMake(tempCenter.x, tempCenter.y, 2, 2);
 */



@end
