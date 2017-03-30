//
//  ProgressManager.h
//  Network_progress_pop
//
//  Created by Vincent on 2017/3/29.
//  Copyright © 2017年 Vincent. All rights reserved.
//  风火轮管理


/* 需求
 1. 同页面多个请求同时开始, 都要风火轮, 必须只显示一个风火轮, 时间取最长的
 2. 区别是否导航栏可以点.  是否显示在网络层处理, 这里用来做逻辑
 3. pop回去取消所有Task
 
 */

/* Note
 1. MBProgressHUD 要在主线程
 2. AFN block 是在主线程
 3. AFN block 不能weakSelf也不会内存泄漏, 内部处理了. 但是self还是会强引用, 导致pop后还是会执行block. 建议weakSelf, 或者根据要求配合 strongSelf
 */

#import <Foundation/Foundation.h>

@interface Progress : NSObject

/**
 是否全屏, 默认NO, 导航可以点击
 */
@property (nonatomic, assign) BOOL isFull;

- (instancetype)initWithVC:(NSString *)cls task:(NSURLSessionTask *)task isShow:(BOOL)isShow;

- (void)show;

- (void)dismiss;

@end



@interface ProgressManager : NSObject

/**
 是否全屏, 默认NO, 导航可以点击, 如果导航栏没有还是全屏不能点
 */
+ (void)setFullScreen:(BOOL)isFull;


/**
 增加请求
 */
+ (void)addProgress:(Progress *)progress;


/**
 移除请求
 */
+ (void)removeProgress:(Progress *)progress;


/**
 Pop 时 cancel掉所有当前控制器的请求
 */
+ (void)cancelTaskWithViewController:(NSString *)cls;



/*  问题
 1. 没有导航的设置 isFull == NO, 还是全屏
 
 */

@end
