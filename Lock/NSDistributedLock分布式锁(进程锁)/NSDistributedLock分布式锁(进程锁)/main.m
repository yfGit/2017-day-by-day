//
//  main.m
//  NSDistributedLock分布式锁(进程锁)
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *path = @"/Users/vincent/Documents/PAW Document";
        NSDistributedLock *lock = [NSDistributedLock lockWithPath:path];
        
        [lock breakLock];
        [lock tryLock];
            NSLog(@"begin");
            sleep(5);
            NSLog(@"end");
        [lock unlock];
        
    }
    return 0;
}
