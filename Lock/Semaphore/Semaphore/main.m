//
//  main.m
//  Semaphore
//
//  Created by 许毓方 on 2017/11/25.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#define SemaphoreNum (1)

#define mainQueue   dispatch_get_main_queue()
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import <Foundation/Foundation.h>


/*
 并发数
 
 NSoperation下可以直接设置并发数
 GCD线程同步
    1.dispatch_group
    2.dispatch_barrier
    3.dispatch_semaphore
 
 
 信号量就是一个资源计数器, 对信号量有两个操作来达到互斥, P, V操作
 或停车场, 4个车位, 同时来了四辆车也能停下. 如果来了五辆车, 那么有一辆需要等待
 dispatch_semaphore_create  剩余车位数
 dispatch_semaphore_wait    使用一个车位 -1 P  函数所处的线程被成功唤醒
 dispatch_semaphore_signal  空出一个车位 +1 V
    signal当返回值不为0时，表示其当前有（一个或多个）线程等待其处理的信号量，并且该函数唤醒了一个等待的线程（当线程有优先级时，唤醒优先级最高的线程；否则随机唤醒）
 
 锁
 信号量为0则阻塞线程, 大于0则不会阻塞, 改变信息量的值, 来控制是否阻塞线程, 从而达到线程同步
 
 
 dispatch_semaphore_t
 dispatch_semaphore_create(long value); // 并发数, 信号总量
 
 long
 dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);
 等待信号, 当信号总量>0或timeout超时时 执行以下语句. vlaue != 0 为超时
 
 long
 dispatch_semaphore_signal(dispatch_semaphore_t dsema);
 */



int main(int argc, const char * argv[]) {
    @autoreleasepool {
    
        void network(void);
        network();
        
    return 0;
}

void network()
{
    __block BOOL isSuccess = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), globalQueue, ^{
        NSLog(@"----");
        dispatch_semaphore_signal(semaphore); // +1
        dispatch_semaphore_signal(semaphore); // +1
    });
    
    /*模拟
     [Netwrok success:{
        isSuccess = YES;
        dispatch_semaphore_signal(semaphore); // +1
     } failure:{
        isSuccess = NO;
        dispatch_semaphore_signal(semaphore);
     }]
     */
    
    dispatch_async(globalQueue, ^{
        // 如果是串行线程 mainQueue 阻塞线程, 假如 dispatch_semaphore_signal 也在串行线程将 锁死
        // 串行线程 相当于 并发数 1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
        NSLog(@".....1");
        // ... do after network
    });
    dispatch_async(globalQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
        NSLog(@".....2");
        // ... do after network
    });
}


