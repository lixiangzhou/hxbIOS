//
//  HxbMyBankCardViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbMyBankCardViewController.h"
#import "HXBMyBankCell.h"
#import "NYBaseRequest.h"
#import "HXBBankCardModel.h"
@interface HxbMyBankCardViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

/**
 数据模型数组
 */
@property (nonatomic, strong) NSArray *modelArr;
@end

@implementation HxbMyBankCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡";
    [self.view addSubview:self.tableView];
}

- (void)loadBankCardData
{
    kWeakSelf
    NYBaseRequest *bankCardAPI = [[NYBaseRequest alloc] init];
    bankCardAPI.requestUrl = @"/account/user/card";
    bankCardAPI.requestMethod = NYRequestMethodGet;
    [bankCardAPI startWithSuccess:^(NYBaseRequest *request, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableView.mj_header endRefreshing];
        NSInteger status =  [responseObject[@"status"] integerValue];
        if (status != 0) {
            [HxbHUDProgress showTextWithMessage:responseObject[@"message"]];
            return;
        }
        weakSelf.modelArr = [NSArray yy_modelArrayWithClass:[HXBBankCardModel class] json:responseObject[@"data"]];
        [weakSelf.tableView reloadData];
    } failure:^(NYBaseRequest *request, NSError *error) {
        NSLog(@"%@",error);
        [HxbHUDProgress showTextWithMessage:@"银行卡请求失败"];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXBMyBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HXBMyBankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.bankCardModel = self.modelArr[indexPath.section];
    cell.backgroundColor = BACKGROUNDCOLOR;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - getter/setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        kWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadBankCardData];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

@end