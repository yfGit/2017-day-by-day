//
//  EventProxy.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "EventProxy.h"

@implementation EventProxy

- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    NSLog(@"handle");
}

@end
