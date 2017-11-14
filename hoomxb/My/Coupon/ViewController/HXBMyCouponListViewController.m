//
//  HXBMyCouponListViewController.m
//  hoomxb
//
//  Created by hxb on 2017/10/30.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMyCouponListViewController.h"
#import "HXBMyCouponListView.h"
#import "HXBRequestAccountInfo.h"
#import "HXBMyCouponListModel.h"
#import "HXBRootVCManager.h"

@interface HXBMyCouponListViewController (){
    int _page;
    NSString* _filter;
}

@property (nonatomic, strong) HXBMyCouponListView *myView;
@property (nonatomic, strong) NSDictionary *parameterDict;
//@property (nonatomic,strong) NSArray <HXBMyCouponListModel*>* myCouponListModelArray;//数据数组

@end

@implementation HXBMyCouponListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setParameter];
    self.view.backgroundColor = RGBA(244, 243, 248, 1);
    [self.view addSubview:self.myView];
//    self.myView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData_myCouponListInfo];
}

#pragma mark - 加载数据
- (void)loadData_myCouponListInfo{
    kWeakSelf
    [HXBRequestAccountInfo downLoadMyAccountListInfoHUDWithParameterDict:self.parameterDict withSeccessBlock:^(NSArray<HXBMyCouponListModel *> *modelArray) {
        weakSelf.myView.myCouponListModelArray = modelArray;
        weakSelf.myView.isStopRefresh_Home = YES;
    } andFailure:^(NSError *error) {
        weakSelf.myView.isStopRefresh_Home = YES;
//        [weakSelf.view addSubview:weakSelf.noNetworkStatusView];
//        [weakSelf.noNetworkStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.top.width.height.equalTo(self.view);
//        }];
//        weakSelf.noNetworkStatusView.hidden = NO;
    }];
}

- (void)getNetworkAgain{
    [self loadData_myCouponListInfo];
}

#pragma mark - Setter / Getter / Lazy

- (void)setParameter{
    _page = 1;
    _filter = @"available";//未使用
}

-(HXBMyCouponListView *)myView{
    if (!_myView) {
        _myView = [[HXBMyCouponListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
        kWeakSelf
        _myView.userInteractionEnabled = YES;
        /**
         点击cell中按钮的回调的Block
         */
        _myView.actionButtonClickBlock = ^(){
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            //红利计划列表页
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_PlanAndLoan_Fragment object:@{@"selectedIndex" : @0}];
            [[HXBRootVCManager manager].mainTabbarVC setSelectedIndex:1];
        };
        _myView.homeRefreshHeaderBlock = ^(){
            [weakSelf loadData_myCouponListInfo];
        };
    }
    return _myView;
}

- (NSDictionary *)parameterDict{
    if (!_parameterDict) {
        _parameterDict = @{@"page":[NSString stringWithFormat:@"%d",_page],@"filter":_filter};
    }
    return _parameterDict;
}

@end
