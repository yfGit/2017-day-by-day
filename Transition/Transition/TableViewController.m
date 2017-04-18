

//
//  TableViewController.m
//  Transition
//
//  Created by 许毓方 on 2017/4/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TableViewController.h"

#import "UIViewController+TouchPoint.h"

#import "PresentController.h"
#import "DotZoomTransition.h"
#import "DotMaskTransition.h"
#import "InsideThePushTransition.h"

@interface TableViewController ()<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign) CGPoint point;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    PresentController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PresentController"];
    
    vc.touchBlock = ^(CGPoint point) { // PUSH 返回键不触发
        self.point = point;
    };
    
    
    if (indexPath.section == 0) {
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -  <UINavigationControllerDelegate>

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    if (operation == UINavigationControllerOperationPush) {
        if (self.selectedIndexPath.row == 0) {
            return [DotZoomTransition transitionWithModal:TransitionModePresent startPoint:cell.center];
        }
        else if (self.selectedIndexPath.row == 1) {
            return [DotMaskTransition transitionWithModal:TransitionModePresent startPoint:cell.center];
        }
        else if (self.selectedIndexPath.row == 2) {
            return [InsideThePushTransition transitionWithModal:TransitionModePresent];
        }
        else {
            return nil;
        }
    }else {
        if (self.selectedIndexPath.row == 0) {
            return [DotZoomTransition transitionWithModal:TransitionModeDismiss startPoint:self.point];
        }
        else if (self.selectedIndexPath.row == 1) {
            return [DotMaskTransition transitionWithModal:TransitionModeDismiss startPoint:self.point];
        }
        else if (self.selectedIndexPath.row == 2) {
            return [InsideThePushTransition transitionWithModal:TransitionModeDismiss];
        }
        else {
            return nil;
        }
    }
    return nil;
}


#pragma mark -  <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    if (self.selectedIndexPath.row == 0) {
        return [DotZoomTransition transitionWithModal:TransitionModePresent startPoint:cell.center];
    }
    else if (self.selectedIndexPath.row == 1) {
        return [DotMaskTransition transitionWithModal:TransitionModePresent startPoint:cell.center];
    }
    else if (self.selectedIndexPath.row == 2) {
        return [InsideThePushTransition transitionWithModal:TransitionModePresent];
    }
    else {
        return nil;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.selectedIndexPath.row == 0) {
        return [DotZoomTransition transitionWithModal:TransitionModeDismiss startPoint:self.point];
    }
    else if (self.selectedIndexPath.row == 1) {
        return [DotMaskTransition transitionWithModal:TransitionModeDismiss startPoint:self.point];
    }
    else if (self.selectedIndexPath.row == 2) {
        return [InsideThePushTransition transitionWithModal:TransitionModeDismiss];
    }
    else {
        return nil;
    }
    return nil;
}


@end
