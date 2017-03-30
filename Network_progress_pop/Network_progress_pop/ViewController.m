//
//  ViewController.m
//  Network_progress_pop
//
//  Created by Vincent on 2017/3/29.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ViewController.h"
#import "ProgressManager.h"



@interface ViewController ()

@property (nonatomic, strong) ViewController *vc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Progress *progress = [[Progress alloc] initWithVC:NSStringFromClass([self class]) task:nil isShow:YES];
    [ProgressManager setFullScreen:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [ProgressManager addProgress:progress]; 
    });
    
}
- (IBAction)item:(id)sender {
    
}



@end
