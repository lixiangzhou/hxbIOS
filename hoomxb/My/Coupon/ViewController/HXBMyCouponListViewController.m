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
#import "AppDelegate.h"

@interface HXBMyCouponListViewController (){
    int _page;
    NSString* _filter;
}

@property (nonatomic, strong) HXBMyCouponListView *myView;
@property (nonatomic, strong) NSDictionary *parameterDict;
//@property (nonatomic,strong) NSArray <HXBMyCouponListModel*>* myCouponListModelArray;//数据数组

@end

@implementation HXBMyCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setParameter];
    
    [self.view addSubview:self.myView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData_myCouponListInfo];
}

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
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
            [tabViewController setSelectedIndex:1];
        };
        _myView.homeRefreshHeaderBlock = ^(){
            [weakSelf loadData_myCouponListInfo];
        };
    }
    return _myView;
}

//主要是给数据源赋值然后刷新UI
//- (void)setMyCouponListModelArray:(NSArray<HXBMyCouponListModel *> *)myCouponListModelArray{
//    _myCouponListModelArray = myCouponListModelArray;
//    self.myView.myCouponListModelArray = myCouponListModelArray;
//    [self.contDwonManager countDownWithModelArray:finPlanListVMArray andModelDateKey:nil  andModelCountDownKey:nil];
//}

#pragma mark - 加载数据
- (void)loadData_myCouponListInfo{
    kWeakSelf
    [HXBRequestAccountInfo downLoadMyAccountListInfoNoHUDWithParameterDict:self.parameterDict withSeccessBlock:^(NSArray<HXBMyCouponListModel *> *modelArray) {
//        weakSelf.myCouponListModelArray = modelArray;
        weakSelf.myView.myCouponListModelArray = modelArray;
        weakSelf.myView.isStopRefresh_Home = YES;
    } andFailure:^(NSError *error) {
        weakSelf.myView.isStopRefresh_Home = YES;
    }];
}

- (NSDictionary *)parameterDict{
    if (!_parameterDict) {
        _parameterDict = @{@"page":[NSString stringWithFormat:@"%d",_page],@"filter":_filter};
    }
    return _parameterDict;
}

@end