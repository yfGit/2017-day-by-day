//
//  ViewController.m
//  ResponderChain
//
//  Created by 许毓方 on 2017/8/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ViewController.h"
#import "CellOne.h"
#import "CellTwo.h"
#import "UIResponder+Router.h"
#import "EventProxy.h"

#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height

// EventName
extern NSString *const en_CellOneA;
extern NSString *const en_CellOneB;
extern NSString *const en_CellTwoA;
extern NSString *const en_CellTwoB;


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *eventStrategy;

@property (nonatomic, strong) UITableView *tbView;

@property (nonatomic, strong) UIButton *dismissBtn;

@property (nonatomic, strong) EventProxy *eventProxy;

@end

static NSString *CellOneId = @"CellOneId";
static NSString *CellTwoId = @"CellTwoId";

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.dismissBtn];
    [self.view addSubview:self.tbView];
}

- (void)dismissVC {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Responder Method
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&userInfo atIndex:2]; // 不用规定key
    [invocation invoke];
    
    
    /*
     decorator patten
     为userInfo增加额外参数
     */
//    [super routerEventWithName:eventName userInfo:userInfo];
    
    
    
    // 拆分 创建 EventProxy 对象，专门处理 Responder Chain 上传递的事件
//    [self.eventProxy handleEvent:eventName userInfo:userInfo];
    
}

#pragma mark CellOne
// 无用的userInfo, 当前场景
- (void)pushAViewController:(NSDictionary *)userInfo
{
    ViewController *vc = [ViewController new];
    
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSLog(@"no navigationController");
    }
}

- (void)prsentAViewController:(NSDictionary *)userInfo
{
    ViewController *vc = [ViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark CellTwo
// 取userInfo
- (void)pushAViewControllerWithTitle:(NSDictionary *)userInfo
{
    ViewController *vc = [ViewController new];
    vc.title = userInfo[@"title"];
    
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSLog(@"no navigationController");
    }
}

- (void)prsentAViewControllerWithUserInfo:(NSDictionary *)userInfo
{
    ViewController *vc = [ViewController new];
    vc.title = userInfo[@"tiitle"];
    
    NSLog(@"\ntitle: %@ \nindexPath: %@",userInfo[@"tiitle"], userInfo[@"indexPath"]);
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 100 : 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CellOne *cell = [tableView dequeueReusableCellWithIdentifier:CellOneId forIndexPath:indexPath];
        return cell;
    }
    
    CellTwo *cell = [tableView dequeueReusableCellWithIdentifier:CellTwoId forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s - %@", __func__, indexPath);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter & Setter

- (NSDictionary *)eventStrategy
{
    if (!_eventStrategy) {
        _eventStrategy = @{
                           en_CellOneA : [self createInvocationWithSelector:@selector(pushAViewController:)],
                           en_CellOneB : [self createInvocationWithSelector:@selector(prsentAViewController:)],
                           en_CellTwoA : [self createInvocationWithSelector:@selector(pushAViewControllerWithTitle:)],
                           en_CellTwoB : [self createInvocationWithSelector:@selector(prsentAViewControllerWithUserInfo:)]
                           };
    }
    return _eventStrategy;
}

- (UIButton *)dismissBtn
{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.frame = CGRectMake(0, 64, kWidth, 60);
        _dismissBtn.backgroundColor = [UIColor cyanColor];
        [_dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _dismissBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_dismissBtn setTitle:@"DISMISS / POP" forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UITableView *)tbView
{
    if (!_tbView) {
        _tbView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbView.frame = CGRectMake(0, CGRectGetMaxY(self.dismissBtn.frame), kWidth, kHeight-CGRectGetMaxY(self.dismissBtn.frame));
        _tbView.delegate   = self;
        _tbView.dataSource = self;
        
        [_tbView registerNib:[UINib nibWithNibName:@"CellOne" bundle:nil] forCellReuseIdentifier:CellOneId];
        [_tbView registerNib:[UINib nibWithNibName:@"CellTwo" bundle:nil] forCellReuseIdentifier:CellTwoId];
    }
    return _tbView;
}


@end
