//
//  HXBFinanctingRequest.m
//  hoomxb
//
//  Created by HXB on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFinanctingRequest.h"
#import "HXBFinHomePageViewModel_PlanList.h"//红利计划的的ViewModel
#import "HXBFinHomePageViewModel_LoanList.h"//散标列表的ViewModel
#import "LoanListAPI.h"//散标列表api
#import "HXBFinancing_planListAPI.h"//红利计划列表api
#import "HXBFinHomePageModel_PlanList.h"//红利计划列表页的Model
#import "HXBFinHomePageModel_LoanList.h"//散标列表的model

@interface HXBFinanctingRequest ()
//红利计划列表的页数
@property (nonatomic,assign) BOOL isUPRefresh_Plan;
@property (nonatomic,assign) NSInteger planListPage;

@property (nonatomic,assign) BOOL isUPRefresh_Loan;
@property (nonatomic,assign) NSInteger loanListPage;

//红利计划列表的数据数组
@property (nonatomic,strong) NSMutableArray <HXBFinHomePageViewModel_PlanList *>*planListViewModelArray;
@property (nonatomic,strong) NSMutableArray <HXBFinHomePageViewModel_LoanList *>*loanListViewModelArray;
@end

@implementation HXBFinanctingRequest
- (instancetype)init {
    if (self = [super init]){
        self.planListViewModelArray = [[NSMutableArray alloc]init];
        self.loanListViewModelArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - setter
- (void)setIsUPRefresh_Plan:(BOOL)isUPRefresh_Plan {
    _isUPRefresh_Plan = isUPRefresh_Plan;
    if (_isUPRefresh_Plan) {
        self.planListPage = 1;
        [self.planListViewModelArray removeAllObjects];
    }
}
- (void)setIsUPRefresh_Loan:(BOOL)isUPRefresh_Loan {
    _isUPRefresh_Loan = isUPRefresh_Loan;
    if (_isUPRefresh_Loan) {
        self.loanListPage = 1;
        [self.loanListViewModelArray removeAllObjects];
    }
}


#pragma mark - homePage reaquest
//MARK: 红利计划列表api
- (void)planBuyListWithIsUpData: (BOOL)isUPData andSuccessBlock: (void(^)(NSArray<HXBFinHomePageViewModel_PlanList *>* viewModelArray))successDateBlock andFailureBlock: (void(^)(NSError *error))failureBlock {
    //是否为上拉刷新
    self.isUPRefresh_Plan = isUPData;
    
    HXBFinancing_planListAPI *planBuyListAPI = [[HXBFinancing_planListAPI alloc]init];
    planBuyListAPI.requestArgument = @{
                                       @"version" : @"1.0",
                                       @"userId" : @"1",
                                       @"start" : @(1),
                                       @"num" : @"20",
                                       @"pageNumber" : @(self.planListPage),
                                       @"pageSize" : @(20)//每页的个数
                                       };

    [planBuyListAPI startWithSuccess:^(NYBaseRequest *request, id responseObject) {
        NSArray <NSDictionary *>* dataList = responseObject[@"data"][@"dataList"];
        if (!dataList.count) {
            NSLog(@"✘红利计划请求没有数据");
            return;
        }
        
        [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            HXBFinHomePageModel_PlanList *financtingPlanListModel = [[HXBFinHomePageModel_PlanList alloc]init];
            //创建viewModel
            HXBFinHomePageViewModel_PlanList *financtingPlanListViewModel = [[HXBFinHomePageViewModel_PlanList alloc]init];
            //字典转模型
            [financtingPlanListModel yy_modelSetWithDictionary:obj];
            //给viewModel赋值MODEL
            financtingPlanListViewModel.planListModel = financtingPlanListModel;
            [self.planListViewModelArray addObject:financtingPlanListViewModel];
        }];
        //回调
        self.planListPage ++;
        if (successDateBlock) successDateBlock(self.planListViewModelArray);
        
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (error && failureBlock) {
            NSLog(@"%@ === ✘红利计划请求没有数据 ===",error);
            failureBlock(error);
        }
    }];
}

//MARK: 散标列表api
- (void)loanBuyListWithIsUpData: (BOOL)isUPData andSuccessBlock: (void(^)(NSArray<HXBFinHomePageViewModel_LoanList *>* viewModelArray))successDateBlock andFailureBlock: (void(^)(NSError *error))failureBlock{
    self.isUPRefresh_Loan = isUPData;
    LoanListAPI *loanListAPI = [[LoanListAPI alloc]init];
    loanListAPI.requestArgument = @{
                                       @"version" : @"1.0",
                                       @"userId" : @"1",
                                       @"start" : @(1),
                                       @"num" : @"20",
                                       @"pageNumber" : @(self.loanListPage),
                                       @"pageSize" : @(20)//每页的个数
                                       };
    [loanListAPI startWithSuccess:^(NYBaseRequest *request, id responseObject) {
        //数据
        NSArray <NSDictionary *>* dataList = responseObject[@"data"][@"dataList"];
        
        if (!responseObject || !dataList.count) {
            NSLog(@"✘散标购买请求没有数据");
            return;
        }
        
        [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HXBFinHomePageModel_LoanList *financtingLoanListModel = [[HXBFinHomePageModel_LoanList alloc]init];
            //创建viewModel
            HXBFinHomePageViewModel_LoanList *financtingLoanListViewModel = [[HXBFinHomePageViewModel_LoanList alloc]init];
            //字典转模型
            [financtingLoanListModel yy_modelSetWithDictionary:obj];
            //给viewModel赋值MODEL
            financtingLoanListViewModel.loanListModel = financtingLoanListModel;
            [self.loanListViewModelArray addObject:financtingLoanListViewModel];
        }];
        //回调
        self.loanListPage ++;
        if (successDateBlock) successDateBlock(self.loanListViewModelArray);
        
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (error && failureBlock) {
             NSLog(@"✘散标购买请求没有数据");
            failureBlock(error);
        }
    }];
}
@end
