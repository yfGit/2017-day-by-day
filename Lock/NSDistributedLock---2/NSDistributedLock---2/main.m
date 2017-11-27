//
//  main.m
//  NSDistributedLock---2
//
//  Created by 许毓方 on 2017/11/27.
//  Copyright © 2017年 许毓方. All rights reserved.
//

#import <Foundation/Foundation.h>
// http://www.tanhao.me/pieces/643.html/

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *path = @"/Users/vincent/Documents/PAW Document";
        NSDistributedLock *lock = [NSDistributedLock lockWithPath:path];
        
        while (![lock tryLock]) {
            NSLog(@"lock...");
        }
        NSLog(@"ok");
        [lock unlock];
    }
    return 0;
}
