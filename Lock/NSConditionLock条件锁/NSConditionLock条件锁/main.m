//
//  main.m
//  NSConditionLock条件锁
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import <Foundation/Foundation.h>
// http://www.tanhao.me/pieces/643.html/

/*
 当我们在使用多线程的时候，有时一把只会lock和unlock的锁未必就能完全满足我们的使用。
 因为普通的锁只能关心锁与不锁，而不在乎用什么钥匙才能开锁，
 而我们在处理资源共享的时候，多数情况是只有满足一定条件的情况下才能打开这把锁
 */

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSConditionLock *lock = [[NSConditionLock alloc] init];
        
        dispatch_async(global, ^{
            
            for (int i = 0; i < 3; i++) {
                [lock lock];
                NSLog(@"thread %d", i);
                [lock unlockWithCondition:i];
            }
        });
        
        dispatch_async(global, ^{
            [lock lockWhenCondition:2];
            NSLog(@">> thread 2");
            [lock unlock];
        });
        
        /*
         在线程1中的加锁使用了lock, 不需要条件直接锁住,
         但是 unlock 使用了一个整形的条件, 它可以开启其它线程中正在等待这把钥匙的临界地
         而线程2则需要一把被标识为2的钥匙 所以当线程1循环到最后一次的时候, 才最终打开了线程2中的阻塞
         NSConditionLock也跟其它的锁一样，是需要lock与unlock对应的，只是lock,lockWhenCondition:与unlock，unlockWithCondition:是可以随意组合的，当然这是与你的需求相关的。
         */
        
    }
    return 0;
}
