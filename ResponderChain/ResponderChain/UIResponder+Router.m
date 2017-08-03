//
//  UIResponder+Router.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)


- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (NSInvocation *)createInvocationWithSelector:(SEL)aSelector
{
    NSMethodSignature *sig   = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    
    invocation.target   = self;
    invocation.selector = aSelector;
    
    return invocation;
}

@end
