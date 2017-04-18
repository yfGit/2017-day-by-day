//
//  PresentController.m
//  Transition
//
//  Created by 许毓方 on 2017/4/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "PresentController.h"
#import "UIViewController+TouchPoint.h"
#import "InsideThePushTransition.h"

@interface PresentController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation PresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.delegate = self; // test pop by finger when use InsideThePush
    
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
    
}

- (void)edgePanAction:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    //计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self.view];
    
    if (self.touchBlock) {
        self.touchBlock(point);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - <UINavigationControllerDelegate>
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    return self.percentDrivenTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    return [InsideThePushTransition transitionWithModal:TransitionModeDismiss];
}


@end
