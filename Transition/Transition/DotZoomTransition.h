//
//  DotTransition.h
//  Transition
//
//  Created by 许毓方 on 2017/4/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YFTransition.h"


@interface DotZoomTransition : YFTransition <UIViewControllerAnimatedTransitioning>

/**
 初始化
 @param mode         转场模式
 @param startPoint   起始点
 */
+ (instancetype)transitionWithModal:(TransitionMode)mode
                         startPoint:(CGPoint)startPoint;


@end
