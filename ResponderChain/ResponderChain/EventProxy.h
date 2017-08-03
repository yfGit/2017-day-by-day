//
//  EventProxy.h
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventProxy : NSObject

- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
