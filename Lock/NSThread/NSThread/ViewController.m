//
//  ViewController.m
//  NSThread
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import "ViewController.h"
#import "XImage.h"


/*
 GCD
 
 dispatch_apply():重复执行某个任务，但是注意这个方法没有办法异步执行（为了不阻塞线程可以使用dispatch_async()包装一下再执行）。
 dispatch_once() :单次执行一个任务，此方法中的任务只会执行一次，重复调用也没办法重复执行（单例模式中常用此方法）。
 dispatch_time() :延迟一定的时间后执行。
 dispatch_barrier_async():使用此方法创建的任务首先会查看队列中有没有别的任务要执行，如果有，则会等待已有任务执行完毕再执行；同时在此方法后添加的任务必须等待此方法中任务执行后才能执行。（利用这个方法可以控制执行顺序，例如前面先加载最后一张图片的需求就可以先使用这个方法将最后一张图片加载的操作添加到队列，然后调用dispatch_async()添加其他图片加载任务）
 dispatch_group_async():实现对任务分组管理，如果一组任务全部完成可以通过dispatch_group_notify()方法获得完成通知（需要定义dispatch_group_t作为分组标识）。
 */

#define IMAGE_COUNT 9

@interface ViewController ()
{
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
    NSMutableArray *_threads;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self layout];
    [self enterLeave];
}

#pragma mark - GCD

- (void)group
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, q, ^{
        NSLog(@"1");
    });
    
    dispatch_group_async(group, q, ^{
//        sleep(3);
        NSLog(@"2");
    });
    
    dispatch_group_async(group, q, ^{
        NSLog(@"3");
    });
    
    dispatch_group_notify(group, q, ^{
        NSLog(@"0");
    });
   
    /*
     wait 同步, 会阻塞当前线程
     同group(DISPATCH_TIME_FOREVER时 两者执行顺序随机)
     timeout 直接执行 dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC)
     */
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"final");
}

- (void)enterLeave
{
    // 区别
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self networkWithGroup:group];
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self networkWithGroup:group];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务完成");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"wait");
    });
}

- (void)networkWithGroup:(dispatch_group_t)group
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        sleep(3);
        dispatch_group_leave(group);
        NSLog(@"....");
    }];
    
    [task resume];
}

- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("my concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
    dispatch_barrier_sync(queue, ^{ // async    sync(阻塞当前线程)
        NSLog(@"0");
    });
    
    NSLog(@"other");
    dispatch_async(queue, ^{
        NSLog(@"4");
    });
    dispatch_async(queue, ^{
        NSLog(@"5");
    });
    dispatch_async(queue, ^{
        NSLog(@"6");
    });
}

- (void)layout
{
    // 视图
    _imageViews = [NSMutableArray array];
    CGFloat width  = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat height = width;
    for (NSUInteger i = 0; i < IMAGE_COUNT; i++) {
        CGRect frame = CGRectMake(i%3*width, 40 + i/3*height, width, height);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        [self.view addSubview:imgView];
        [_imageViews addObject:imgView];
    }
    
    //加载按钮
    UIButton *buttonStart=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame=CGRectMake(0, 0, 100, 25);
    buttonStart.center = CGPointMake(width, 500);
    [buttonStart setTitle:@"加载图片" forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(loadImageWithMultiThread_OperationSeq) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];
    
    //停止按钮
    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame=CGRectMake(0, 0, 100, 25);
    buttonStop.center = CGPointMake(2*width, 500);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];
    
    // 清空
    UIButton *cleanStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cleanStop.frame=CGRectMake(0, 0, 100, 25);
    cleanStop.center = CGPointMake(1.5*width, 550);
    [cleanStop setTitle:@"清空" forState:UIControlStateNormal];
    [cleanStop addTarget:self action:@selector(cleanImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cleanStop];
    
    // 图片
    _imageNames = [NSMutableArray array];
    for (NSUInteger i = 0; i < IMAGE_COUNT; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%lu.jpg",i]];
    }
}

#pragma mark - Private Method

- (void)loadImageWithMultiThread_OperationSeq
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSOperation *lastOperation = nil;
    for (NSUInteger i = 0; i < IMAGE_COUNT; i++) {
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:@(i)];
        }];
        // 依赖 上一张图片加载操作
        if (lastOperation) {
            [operation addDependency:lastOperation];
        }
        lastOperation = operation;
        [queue addOperation:operation];
    }
}



/// NSOperation
- (void)loadImageWithMultiThread_Operation
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;
    
    for (NSUInteger i = 0; i < IMAGE_COUNT; i++) {
//        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage:) object:@(i)];
//        NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
//        [opQueue addOperation:op];
        
        [queue addOperationWithBlock:^{
            [self loadImage:@(i)];
        }];
    }
}
 
/// NSThread
- (void)loadImageWithMultiThread
{
    _threads = [NSMutableArray array];

    for (NSUInteger i = 0; i < IMAGE_COUNT; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:@(i)];
        thread.name = [NSString stringWithFormat:@"My Thread-%lu", i];
        [_threads addObject:thread];

        // 后台
//        [self performSelectorInBackground:@selector(loadImage:) withObject:@(i)];
    }

    for (NSThread *t in _threads) {
        [t start];
    }
}

- (void)stopLoadImage
{
    // 线程还没有完成, 就设置为取消状态, 并不能终止线程
    for (NSThread *t in _threads) {
        if (!t.isFinished) {
            [t cancel];
        }
    }
}

- (void)cleanImage
{
    for (UIImageView *imgView in _imageViews) {
        imgView.image = nil;
    }
}

- (void)loadImage:(NSNumber *)index
{
    NSData *data = [self requestData:index.unsignedIntegerValue];
    
    NSThread *currentThread = [NSThread currentThread];
    
    if (currentThread.isCancelled) {
        NSLog(@"%@ be canceld!", currentThread);
        [NSThread exit];
    }
    
    XImage *image = [XImage new];
    image.imageData = data;
    image.index = index.unsignedIntegerValue;
    // waitUntilDone:是否线程任务完成执行
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateImage:image];
//    }];
}

- (NSData *)requestData:(NSUInteger)index
{
    NSLog(@"下载中");
    // 模拟网络延迟
    sleep(arc4random()%3);
    
    NSLog(@"下载完成");
    
    NSURL *url = [NSURL URLWithString:_imageNames[index]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

- (void)updateImage:(XImage *)image
{
    UIImageView *imgView = _imageViews[image.index];
    imgView.image = [UIImage imageWithData:image.imageData];
    NSLog(@"更新");
    
}


@end
