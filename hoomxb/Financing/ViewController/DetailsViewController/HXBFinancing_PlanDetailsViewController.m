//
//  HXBFinancing_PlanViewController.m
//  hoomxb
//
//  Created by HXB on 2017/5/4.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFinancing_PlanDetailsViewController.h"

#import "HXBFin_PlanDetailView.h"///红利计划详情页的主视图
#import "HXBFinanctingRequest.h"//请求类
#import "HXBFinDetailViewModel_PlanDetail.h"//红利计划详情页Viewmodel
#import "HXBFinDetailModel_PlanDetail.h"//红利计划详情model

#import "HXBFinDetail_TableView.h"//详情页tableView的model
#import "HXBFinHomePageViewModel_PlanList.h"//红利计划的Viewmodel
#import "HXBFinHomePageModel_PlanList.h"//红利计划的Model

#import "HXBFinAddRecordVC_Plan.h"//红利计划的加入记录
#import "HXBFin_Detail_DetailsVC_Plan.h"//红利计划详情中的详情

#import "HXBFinPlanContract_contraceWebViewVC.h"//协议
#import "HXBFinBuy_plan_ViewController.h"//计划加入
#import "HXBFin_Plan_BuyViewController.h"//加入 界面

#import "HXBFinAddTruastWebViewVC.h"

@interface HXBFinancing_PlanDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
//假的navigationBar
@property (nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) HXBFin_PlanDetailView *planDetailsView;
///底部点的cellModel
@property (nonatomic,strong) NSArray <HXBFinDetail_TableViewCellModel *>*tableViewModelArray;
///tableView的tatile
@property (nonatomic,strong) NSArray <NSString *>* tableViewTitleArray;
///详情底部的tableView的图片数组
@property (nonatomic,strong) NSArray <NSString *>* tableViewImageArray;
///详情页的ViewMode
@property (nonatomic,strong) HXBFinDetailViewModel_PlanDetail *planDetailViewModel;
///addButtonStr
@property (nonatomic,weak) HXBFin_PlanDetailView_ViewModelVM *planDetailVM;
@property (nonatomic,copy) NSString *availablePoint;//可用余额；
@property (nonatomic,assign) BOOL isIdPassed;
@property (nonatomic,assign) BOOL isVerify;
@end

@implementation HXBFinancing_PlanDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavigationBar = false;
    [self setup];
    [self downLoadData];
    [self registerClickCell];
    [self registerClickAddButton];
    [self registerAddTrust];//增信
    
    [[KeyChainManage sharedInstance] downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        _availablePoint = viewModel.availablePoint;
        _isIdPassed = viewModel.userInfoModel.userInfo.isIdPassed.integerValue;
    } andFailure:^(NSError *error) {
        
    }];
    [self.view addSubview:_planDetailsView.addButton];
    [_planDetailsView.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.width.offset(kScrAdaptationW(375));
        make.height.offset(kScrAdaptationH(60));
    }];
    _planDetailsView.addButton.hidden = NO;
}


- (void)setPlanAddButton:(NSString *)planAddButton {
    _planAddButton = planAddButton;
}

- (void)setPlanListViewModel:(HXBFinHomePageViewModel_PlanList *)planListViewModel {
    _planListViewModel = planListViewModel;
    self.planID = planListViewModel.planListModel.ID;
}

///MARK: 设置值
- (void)setPlanDetailViewModel:(HXBFinDetailViewModel_PlanDetail *)planDetailViewModel {
    kWeakSelf
    _planDetailViewModel = planDetailViewModel;
    [_planDetailsView setUPViewModelVM:^HXBFin_PlanDetailView_ViewModelVM *(HXBFin_PlanDetailView_ViewModelVM *viewModelVM) {
        weakSelf.planDetailVM = viewModelVM;
        viewModelVM.totalInterestStr           = weakSelf.planDetailViewModel.planDetailModel.expectedRate;
        viewModelVM.startInvestmentStr         = weakSelf.planDetailViewModel.minRegisterAmount;
        viewModelVM.remainAmount               = weakSelf.planDetailViewModel.remainAmount;
        
        viewModelVM.totalInterestStr_const     = @"年利率";
        
        viewModelVM.remainAmount_const         = weakSelf.planDetailViewModel.remainAmount_constStr;
        
        viewModelVM.startInvestmentStr_const   = @"起投";
        viewModelVM.promptStr                  = @"* 预期收益不代表实际收益，投资需谨慎";
        
       
        viewModelVM.lockPeriodStr              = weakSelf.planDetailViewModel.lockPeriodStr;
        viewModelVM.isUserInteractionEnabled   = weakSelf.planDetailViewModel.isAddButtonInteraction;
        viewModelVM.title                      = @"加入计划";
        viewModelVM.diffTime                   = weakSelf.planDetailViewModel.countDownStr;
        //倒计时
        viewModelVM.isCountDown                = weakSelf.planDetailViewModel.isContDown;
        //加入按钮
        viewModelVM.addButtonBackgroundColor   = weakSelf.planDetailViewModel.addButtonBackgroundColor;
        viewModelVM.addButtonTitleColor        = weakSelf.planDetailViewModel.addButtonTitleColor;
        viewModelVM.addButtonStr               = weakSelf.planDetailViewModel.addButtonStr;
        if (weakSelf.planDetailViewModel.planDetailModel.unifyStatus.integerValue) {
        }
        ///如果是小于5的情况，那么就是等待加入， 那么如果小于1小时，那么久显示这个参数
        viewModelVM.remainTimeString           = weakSelf.planDetailViewModel.remainTimeString;
        //流程的数据
        viewModelVM.unifyStatus                = weakSelf.planDetailViewModel.planDetailModel.unifyStatus.integerValue;
        viewModelVM.addTime                    = weakSelf.planDetailViewModel.beginSellingTime_flow;
        viewModelVM.beginProfitTime            = weakSelf.planDetailViewModel.financeEndTime_flow;
        viewModelVM.leaveTime                  = weakSelf.planDetailViewModel.endLockingTime_flow;
        return viewModelVM;
    }];
}

- (void) setupTableViewArray {
    self.tableViewImageArray = @[
                                 @"1",
                                 @"1",
                                 @"1",
                                 ];
    self.tableViewTitleArray = @[
                                 @"计划详情",
                                 @"加入记录",
                                 @"红利计划服务协议"
                                 ];
}
- (NSArray<HXBFinDetail_TableViewCellModel *> *)tableViewModelArray {
    if (!_tableViewModelArray) {
        [self setupTableViewArray];
        NSMutableArray *tableViewModelArrayM = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.tableViewImageArray.count; i++) {
            NSString *imageName = self.tableViewImageArray[i];
            NSString *title = self.tableViewTitleArray[i];
            HXBFinDetail_TableViewCellModel *model = [[HXBFinDetail_TableViewCellModel alloc]initWithImageName:imageName andOptionIitle:title];
            [tableViewModelArrayM addObject:model];
        }
        _tableViewModelArray = tableViewModelArrayM.copy;
    }
    return _tableViewModelArray;
}

//MARK: ------ setup -------
- (void)setup {
    kWeakSelf
    [self.hxbBaseVCScrollView hxb_GifHeaderWithIdleImages:nil andPullingImages:nil andFreshingImages:nil andRefreshDurations:nil andRefreshBlock:^{
        [weakSelf downLoadData];
    } andSetUpGifHeaderBlock:^(MJRefreshGifHeader *gifHeader) {
        
    }];
    [self setUPTopImageView];

    self.isTransparentNavigationBar = true;
    self.hxbBaseVCScrollView.backgroundColor = kHXBColor_BackGround;
    self.hxbBaseVCScrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 60);
//    self.hxbBaseVCScrollView.delegate = self;
//    self.hxbBaseVCScrollView.dataSource = self;
    self.planDetailsView = [[HXBFin_PlanDetailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 60)];
    [self.hxbBaseVCScrollView addSubview:self.planDetailsView];
    
    baseNAV.getNetworkAgainBlock = ^{
        [weakSelf downLoadData];
    };
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


- (void)setUPTopImageView {
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.topImageView.image = [UIImage imageNamed:@"NavigationBar"];
    [self.view addSubview:self.topImageView];
}

///MARK: 事件注册
- (void)registerClickCell {
    __weak typeof (self)weakSelf = self;
    [self.planDetailsView clickBottomTableViewCellBloakFunc:^(NSIndexPath *index, HXBFinDetail_TableViewCellModel *model) {
        //跳转相应的页面
        NSLog(@"%@",model.optionTitle);
        ///点击了计划详情
        if ([model.optionTitle isEqualToString:weakSelf.tableViewTitleArray[0]]) {
            HXBFin_Detail_DetailsVC_Plan *detail_DetailPlanVC = [[HXBFin_Detail_DetailsVC_Plan alloc]init];
            detail_DetailPlanVC.planDetailModel = weakSelf.planDetailViewModel;
            [weakSelf.navigationController pushViewController:detail_DetailPlanVC animated:true];
        }
    
        ///  加入记录
        if ([model.optionTitle isEqualToString:weakSelf.tableViewTitleArray[1]]) {
            HXBFinAddRecordVC_Plan *planAddRecordVC = [[HXBFinAddRecordVC_Plan alloc]init];
            planAddRecordVC.planListViewModel = weakSelf.planListViewModel;
            planAddRecordVC.planID = weakSelf.planID;
            [weakSelf.navigationController pushViewController:planAddRecordVC animated:true];
        }
        ///红利计划服务
        if ([model.optionTitle isEqualToString:weakSelf.tableViewTitleArray[2]]) {
            //跳转一个webView
            HXBFinPlanContract_contraceWebViewVC * contractWebViewVC = [[HXBFinPlanContract_contraceWebViewVC alloc]init];
            contractWebViewVC.URL = weakSelf.planDetailViewModel.contractURL;
            [weakSelf.navigationController pushViewController:contractWebViewVC animated:true];
        }
    }];
}

///注册 addButton点击事件
- (void)registerClickAddButton {
    kWeakSelf
    [self.planDetailsView clickAddButtonFunc:^{
        //如果不是登录 那么就登录
        if(![KeyChainManage sharedInstance].isLogin) {
            //            [HXBAlertManager alertManager_loginAgainAlertWithView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
            return;
        }
        [HXBAlertManager checkOutRiskAssessmentWithSuperVC:weakSelf andWithPushBlock:^{
            [weakSelf enterPlanBuyViewController];
        }];
    }];
}

///曾欣事件
- (void)registerAddTrust {
    kWeakSelf
    [self.planDetailsView clickAddTrustWithBlock:^{
        HXBFinAddTruastWebViewVC *vc = [[HXBFinAddTruastWebViewVC alloc] init];
        vc.URL = kHXB_Negotiate_AddTrustURL;
        [weakSelf.navigationController pushViewController:vc animated:true];
    }];
}

///注册刷新事件
- (void)registerLoadData {
    kWeakSelf
    [self.planDetailsView downLoadDataWithBlock:^{
        [weakSelf downLoadData];
    }];
}

/**
 跳转加入界面
 */
- (void)enterPlanBuyViewController
{
    kWeakSelf
    //跳转加入界面
    HXBFin_Plan_BuyViewController *planJoinVC = [[HXBFin_Plan_BuyViewController alloc]init];
    planJoinVC.title = @"加入计划";
    planJoinVC.planViewModel = weakSelf.planDetailViewModel;
    [planJoinVC clickLookMYInfoButtonWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowMYVC_PlanList object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:false];
    }];
    
    [planJoinVC setCallBackBlock:^{
        [weakSelf.navigationController popoverPresentationController];
    }];
    
    planJoinVC.availablePoint = _availablePoint;
    [weakSelf.navigationController pushViewController:planJoinVC animated:true];
}

//MARK: 网络数据请求
- (void)downLoadData {
//    __weak typeof (self)weakSelf = self;
    [[HXBFinanctingRequest sharedFinanctingRequest] planDetaileWithPlanID:self.planID andSuccessBlock:^(HXBFinDetailViewModel_PlanDetail *viewModel) {
        self.planDetailViewModel = viewModel;
        self.planDetailsView.modelArray = self.tableViewModelArray;
        [self.hxbBaseVCScrollView endRefresh];
    } andFailureBlock:^(NSError *error) {
        [self.hxbBaseVCScrollView endRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
