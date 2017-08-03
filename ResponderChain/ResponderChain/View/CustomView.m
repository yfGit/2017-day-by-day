//
//  CustomView.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "CustomView.h"
#import "UIResponder+Router.h"

NSString *const en_CellOneB = @"CellOne-present";

@interface CustomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation CustomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
}
- (IBAction)b:(id)sender {
    [self routerEventWithName:en_CellOneB userInfo:nil];
}
@end
