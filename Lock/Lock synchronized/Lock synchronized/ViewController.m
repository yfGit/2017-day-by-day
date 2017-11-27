//
//  ViewController.m
//  Lock synchronized
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import "ViewController.h"
#import "Obj.h"
#include <pthread.h>

// http://www.tanhao.me/pieces/616.html/

@interface ViewController ()

@property (nonatomic, strong) NSLock *lock;

/**
 nonatomic属性读取的是内存数据(寄存器计算好的结果), atomic直接读取寄存器的数据
 atomic 不会出现一个线程正在修改, 而另一个线程读取了修改之前(存储在内存中)的数据, 永远保证同时只有一个线程在访问一个属性.
 */
@property (atomic, strong) NSMutableArray *nums;

@property (atomic, assign) NSInteger i;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lock = [[NSLock alloc] init];
    self.nums = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"].mutableCopy;
    
    [self testLock];
    
    
//    [self nslock];
    
//    [self pthread_mutex_t];
    
}

- (void)testLock
{
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (UILabel *l in self.labelArray) {

        dispatch_async(global, ^{
            [self syn:l];
        });
    }
}

- (void)normal:(UILabel *)l
{
    NSString *text;
    
    /*
     1) 可能出现重复
     2) 可能出现越界
     3) 可能成功且不重复
     */
    if (self.nums.count > 0) {
        text = self.nums.lastObject;
        [self.nums removeLastObject];
//        text = [NSString stringWithFormat:@"%ld", self.i++];
    }
    
    if (!text) {
        text = @"text";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        l.text = text;
    });
}

- (void)lock:(UILabel *)l
{
    NSString *text;
    
    [self.lock lock];
    
    if (self.nums.count > 0) {
        text = self.nums.lastObject;
        [self.nums removeLastObject];
//        text = [NSString stringWithFormat:@"%ld", self.i++];
    }
    
    [self.lock unlock];
    
    if (!text) {
        text = @"text";
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        l.text = text;
    });
}




/**
 @synchronized 当标识相同时，才为满足互斥，
 @synchronized(obj)改为@synchronized(other), 线程2就不会被阻塞
 
    不需要创建锁对象, 但作为一种预防措施, @synchronized()块会隐式的添加一个异常处理例程来保护代码,
 该处理例程会在异常抛出的时候自动的释放互斥锁. 所以如果不想让隐式的异常处理例程带来额外的开销, 可以考虑使用锁对象
 */
- (void)syn:(UILabel *)l
{
    NSString *text;
    
    @synchronized(self) {
        if (self.nums.count > 0) {
            text = self.nums.lastObject;
            [self.nums removeLastObject];
        }
    }
    
    if (!text) {
        text = @"text";
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        l.text = text;
    });
}


#pragma mark - Lock
- (void)nslock
{
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    Obj *obj = [Obj new];
    
    dispatch_async(global, ^{
        // 执行顺序1
        [self.lock lock];
        [obj method0];
        sleep(1);
        [self.lock unlock];
    });
    
    dispatch_async(global, ^{
        sleep(1); // 确保执行顺序2
        
        [self.lock lock];
        [obj method1];
        sleep(3);
        [self.lock unlock];
    });
    
    dispatch_async(global, ^{
        sleep(2); // 确保执行顺序3
        
        [self.lock lock];
        [obj method2];
        [self.lock unlock];
    });
    
    /*
     17:12:04  -[Obj method0]
     17:12:05  -[Obj method1]
     17:12:08  -[Obj method2]
     */
}

- (void)sync
{
    Obj *obj = [[Obj alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(obj){
            [obj method1];
            sleep(3);
        }
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized(obj){
            [obj method2];
        }
    });
}

- (void)pthread_mutex_t
{
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    Obj *obj = [Obj new];
    
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL); // #include <pthread.h>
    
    dispatch_async(global, ^{
        
        pthread_mutex_lock(&mutex);
        [obj method0];
        sleep(2);
        pthread_mutex_unlock(&mutex);
    });

    dispatch_async(global, ^{
        sleep(1);
        
        pthread_mutex_lock(&mutex);
        [obj method1];
        pthread_mutex_unlock(&mutex);
    });
}

- (void)semaphore
{
    Obj *obj = [[Obj alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [obj method1];
        sleep(3);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [obj method2];
        dispatch_semaphore_signal(semaphore);
    });
}


@end
