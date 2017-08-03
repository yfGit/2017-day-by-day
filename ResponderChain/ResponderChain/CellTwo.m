//
//  CellTwo.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "CellTwo.h"
#import "UIResponder+Router.h"
#import "CellUserInfo.h"


NSString *const en_CellTwoA = @"en_CellTwoA";
NSString *const en_CellTwoB = @"en_CellTwoB";

NSString *const aTitle      = @"aTitle";
NSString *const aIndexPath  = @"aIndexPath";


@implementation CellTwo

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)a:(id)sender {
    [self routerEventWithName:en_CellTwoA userInfo:@{
                                                     aTitle : @"cellB_PUSH"
                                                     }];
}

- (IBAction)b:(id)sender {
    [self routerEventWithName:en_CellTwoB userInfo:@{
                                                     aTitle     : @"cellB_PRESENT",
                                                     aIndexPath : [NSIndexPath indexPathForRow:arc4random()%100 inSection:arc4random()%10]
                                                      }];
}


@end
