
//
//  ProgressManager.m
//  Network_progress_pop
//
//  Created by Vincent on 2017/3/29.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ProgressManager.h"

#import "MBProgressHUD.h"
#import "UIViewController+Load.h"

@interface Progress ()

@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, copy) NSString *cls;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation Progress

- (instancetype)initWithVC:(NSString *)cls task:(NSURLSessionTask *)task isShow:(BOOL)isShow
{
    NSAssert(cls,    @"cls must not be nil");
//    NSAssert(task,   @"task must not be nil");
    
    if (self = [super init]) {
        _task   = task;
        _cls    = cls;
        _isShow = isShow;
    }
    return self;
}

/** Note
    keywindow 可以加view, 但是有可能为 nil, 执行 makeKeyAndVisible 的时候，他会调用第一个VC的viewDidLoad 方法，在那里面调用 keyWindow就无法取到UIWindow， 因为makeKeyAndVisible没有执行完
    delegate.window 有值, 但是添加的view 可能被控制器的view 覆盖而显示不了
 !!! 如果没有导航栏的控制器 isFull == NO 还是会全屏, 这样会造成两个页面跳转, 一个有导航还有个没有, 都有请求风火轮, 会发现位置不一样
 
    hud.offset, 全按照没有导航栏时vc.view的高度
 */
- (void)show
{
    UIViewController *vc = [UIViewController currentViewController];
//    UIView *hudView = self.isFull ? vc.view.window :
//          vc.navigationController ? vc.navigationController.view : vc.view;
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:hudView animated:YES];
//    
//    float screenHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    hud.offset = CGPointMake(0, (screenHeight - hud.frame.size.height) / 2.0);
//    NSLog(@"%@",NSStringFromCGPoint(hud.offset));
    
    
    UIView *hudView = self.isFull ? vc.view.window : vc.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:hudView animated:YES];
    [hud showAnimated:YES];
}

- (void)dismiss
{
    UIView *hudView = self.isFull ? [UIApplication sharedApplication].delegate.window : [UIViewController currentViewController].view;
    [MBProgressHUD hideHUDForView:hudView animated:YES];
}
@end


@interface ProgressManager ()

@property (nonatomic, strong) NSMutableArray *progressList;

@property (nonatomic, strong) Progress *currentProgress;

@property (nonatomic, assign) BOOL isFull;

@end

@implementation ProgressManager

static ProgressManager *manager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.isFull = NO;
    });
    return manager;
}


/**
    所有请求显示 isShow的
 */
+ (void)addProgress:(Progress *)progress
{
    ProgressManager *manager = [ProgressManager sharedManager];
    
    // isShow == NO, 只要放入数组就可以了
    [manager.progressList addObject:progress];
    if (!progress.isShow) return;
    
    
    // isShow == YES
    progress.isFull = manager.isFull;
    manager.isFull  = NO;
    
    // 显示
    manager.currentProgress = progress;
}


/**
    当前控制器其中一个请求完成了
    同时请求带show的, 其中一个完成了
 */
+ (void)removeProgress:(Progress *)progress
{
    ProgressManager *manager = [ProgressManager sharedManager];
    
    // progress 地址不一样. 找到不变的task
    for (Progress *p in manager.progressList) {
        if (p.task == progress.task) {
            [manager.progressList removeObject:progress];
            break;
        }
    }
    
    // isShow == NO, 只要删除就可以了, Task 已经cancel
    if (!progress.isShow) return;

    // 找到 isShow == YES && 同一个控制器
    Progress *currentProgress = nil;
    for (Progress *p in manager.progressList) {
        if ([p.cls isEqualToString:progress.cls] && p.isShow == progress.isShow) {
            currentProgress = p;
            return;
        }
    }
    manager.currentProgress = currentProgress;
}


/**
    不要影响上个页面的请求风火轮
 */
- (void)setCurrentProgress:(Progress *)currentProgress
{
    [_currentProgress dismiss];
    
    _currentProgress = currentProgress;
    [_currentProgress show];
}


/**
    Pop 时 cancel掉所有当前控制器的请求
 */
+ (void)cancelTaskWithViewController:(NSString *)cls
{
    ProgressManager *manager = [ProgressManager sharedManager];
    for (Progress *p in manager.progressList) {
        
        if ([p.cls isEqualToString:cls]) {
            [p dismiss];
            [p.task cancel];
            [manager.progressList removeObject:p];
        }
    }
}


- (NSMutableArray *)progressList
{
    if (!_progressList) {
        _progressList = [[NSMutableArray alloc] init];
    }
    return _progressList;
}

+ (void)setFullScreen:(BOOL)isFull
{
    ProgressManager *manager = [ProgressManager sharedManager];
    manager.isFull = isFull;
}

@end
