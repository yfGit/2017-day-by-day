//
//  UIViewController+TouchPoint.m
//  Transition
//
//  Created by 许毓方 on 2017/4/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIViewController+TouchPoint.h"
#import <objc/runtime.h>

@implementation UIViewController (TouchPoint)

- (void (^)(CGPoint))touchBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTouchBlock:(void (^)(CGPoint))touchBlock
{
    return objc_setAssociatedObject(self, @selector(touchBlock), touchBlock, OBJC_ASSOCIATION_COPY);
}


@end
