//
//  YFTransition.h
//  Transition
//
//  Created by 许毓方 on 2017/4/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 转场模式
 */

typedef NS_ENUM(NSUInteger, TransitionMode) {
    TransitionModePresent,
    TransitionModeDismiss
};


@interface YFTransition : NSObject

/**
 动画持续时间, default 0.5
 */
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) TransitionMode mode;


@end
