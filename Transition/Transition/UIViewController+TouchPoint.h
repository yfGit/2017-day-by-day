//
//  UIViewController+TouchPoint.h
//  Transition
//
//  Created by 许毓方 on 2017/4/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//  传上个页面的点

#import <UIKit/UIKit.h>

@interface UIViewController (TouchPoint)

@property (nonatomic, copy) void (^touchBlock)(CGPoint point);

@end
