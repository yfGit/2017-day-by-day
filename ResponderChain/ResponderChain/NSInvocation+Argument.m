//
//  NSInvocation+Argument.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "NSInvocation+Argument.h"
#import <objc/runtime.h>

#import "CellUserInfo.h"

@implementation NSInvocation (Argument)





/**
 参数怎么赋值
 1. 参数count不好
 2. 参数type也不好
 3. 直接不赋值, 外部直接用userInfo? 
 4. 还有其它什么好方式?
 
 */
- (void)setupArguments:(NSDictionary *)arguments
{
    if (arguments.allKeys.count == 0) {
        return;
    }
    
    NSAssert(self.target && self.selector, @"no target or seletcor");
    
    Method method;
    method = class_getInstanceMethod([self.target class], self.selector);
    if (!method) {
        method = class_getClassMethod([self.target class], self.selector);
    }
    
    if (!method) {
        return;
    }
    
    unsigned int count = method_getNumberOfArguments(method)-2;

    if (arguments.allKeys.count == count) {
        NSArray *keys = arguments.allKeys;
        [arguments enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self setArgument:&obj atIndex:[keys indexOfObject:key]+2];
        }];
    }
    
    
}

@end
