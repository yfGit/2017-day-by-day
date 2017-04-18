//
//  InsideThePush.h
//  Transition
//
//  Created by 许毓方 on 2017/4/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFTransition.h"

@interface InsideThePushTransition : YFTransition <UIViewControllerAnimatedTransitioning>



/**
 初始化
 @param mode         转场模式
 */
+ (instancetype)transitionWithModal:(TransitionMode)mode;

@end
