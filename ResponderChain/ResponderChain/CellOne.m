//
//  TableCell.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "CellOne.h"
#import "UIResponder+Router.h"

NSString *const en_CellOneA = @"CellOne-push";


@implementation CellOne

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (IBAction)click:(UIButton *)sender {
    
    [self routerEventWithName:en_CellOneA userInfo:nil];
}
@end
