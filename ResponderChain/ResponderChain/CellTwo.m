//
//  CellTwo.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "CellTwo.h"
#import "UIResponder+Router.h"



NSString *const en_CellTwoA = @"en_CellTwoA";
NSString *const en_CellTwoB = @"en_CellTwoB";



@implementation CellTwo

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)a:(id)sender {
    [self routerEventWithName:en_CellTwoA userInfo:@{
                                                     @"title" : @"cellB_PUSH"
                                                     }];
}

- (IBAction)b:(id)sender {
    [self routerEventWithName:en_CellTwoB userInfo:@{
                                                     @"title"     : @"cellB_PRESENT",
                                                     @"indexPath" : [NSIndexPath indexPathForRow:arc4random()%100 inSection:arc4random()%10]
                                                      }];
}

/* 如果当前类处理或装饰就调用方法, 事件继续传递调用 super
   不做任何处理不用调下面的方法
 */
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    // logic
    
    [super routerEventWithName:eventName userInfo:userInfo];
}

@end
