 //
//  HXBFin_DetailsViewBase.m
//  hoomxb
//
//  Created by HXB on 2017/5/5.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFin_DetailsViewBase.h"
#import "HXBFinBase_FlowChartView.h"
#import "HXBFinDetail_TableView.h"

#import "HXBFinDetailViewModel_PlanDetail.h"//红利计划详情的ViewModel
#import "HXBFinDetailViewModel_LoanDetail.h"//散标详情的ViewMOdel

#import "HXBFinDetailModel_PlanDetail.h"//红利计划详情的Model
#import "HXBFinDatailModel_LoanDetail.h"//散标详情的Model

#import "HXBFinHomePageViewModel_PlanList.h"///红利计划列表页Viewmodel
#import "HXBFinHomePageViewModel_LoanList.h"///散标列表页的Viewmodel\

#import "HXBFinHomePageModel_PlanList.h"
#import "HXBFinHomePageModel_LoanList.h"

@interface HXBFin_DetailsViewBase()
@property (nonatomic,strong) HXBFin_DetailsViewBase_ViewModelVM *viewModelVM;
///预期年化的view
@property (nonatomic,strong) UIView *expectedYearRateView;
///曾信View
@property (nonnull,strong) UIView *trustView;
///剩余可投
@property (nonatomic,strong) UIView *surplusValueView;
///流程引导视图
@property (nonatomic,strong) HXBFinBase_FlowChartView *flowChartView;
///立即加入视图
@property (nonatomic,strong) UIView *addView;
///立即加入 倒计时
@property (nonatomic,strong) UILabel *countDownLabel;
///* 预期收益不代表实际收益投资需谨慎
@property (nonatomic,copy) NSString *promptStr;
/// 底部的tableView
@property (nonatomic,strong) HXBFinDetail_TableView *bottomTableView;


//用到的字段
///预期计划
@property (nonatomic,copy) NSString *totalInterestStr;
///红利计划为：预期年利率 散标为：年利率
@property (nonatomic,copy) NSString *totalInterestStr_const;
@property (nonatomic,copy) NSString *lockPeriodStr;
///红利计划：（起投 固定值1000） 散标：（标的期限）
@property (nonatomic,copy) NSString *startInvestmentStr;
@property (nonatomic,copy) NSString *startInvestmentStr_const;

///红利计划：剩余金额 散标列表是（剩余金额）
@property (nonatomic,copy) NSString *remainAmount;
@property (nonatomic,copy) NSString *remainAmount_const;
@property (nonatomic,copy) NSString *addButtonStr;
///底部的tableView被点击
@property (nonatomic,copy) void (^clickBottomTabelViewCellBlock)(NSIndexPath *index, HXBFinDetail_TableViewCellModel *model);
@property (nonatomic,copy) void (^clickAddButtonBlock)();
///加入的button
@property (nonatomic,strong) UIButton *addButton;
///倒计时
@property (nonatomic,copy) NSString *diffTime;
/// 是否倒计时
@property (nonatomic,assign) BOOL isContDown;

///倒计时管理
@property (nonatomic,strong) HXBBaseCountDownManager_lightweight *countDownManager;

@end

@implementation HXBFin_DetailsViewBase
@synthesize viewModelVM = _viewModelVM;
- (HXBBaseCountDownManager_lightweight *)countDownManager {
    if (!_countDownManager) {
        _countDownManager = [[HXBBaseCountDownManager_lightweight alloc]initWithCountDownEndTime:self.diffTime.floatValue /1000 andCountDownEndTimeType:HXBBaseCountDownManager_lightweight_CountDownEndTime_CompareType_Now andCountDownDuration:360000 andCountDownUnit:1];
    }
    return _countDownManager;
}
- (void)setIsContDown:(BOOL)isContDown {
    _isContDown = isContDown;
    if (isContDown) {
        kWeakSelf
        [self.countDownManager resumeTimer];
    [self.countDownManager countDownCallBackFunc:^(CGFloat countDownValue) {
        NSString *str = [[HXBBaseHandDate sharedHandleDate] stringFromDate:@(countDownValue) andDateFormat:@"mm分ss秒"];
        [weakSelf.addButton setTitle:str forState:UIControlStateNormal];
        if (countDownValue < 0) {
            [weakSelf.countDownManager stopTimer];
        }
    }];
    }
}
- (void)setDiffTime:(NSString *)diffTime {
    _diffTime = diffTime;
}
- (HXBFin_DetailsViewBase_ViewModelVM *) viewModelVM {
    if (!_viewModelVM) {
//        kWeakSelf
        _viewModelVM = [[HXBFin_DetailsViewBase_ViewModelVM alloc]init];
//        [_viewModelVM addButtonChengeTitleChenge:^(NSString * buttonStr) {
//            [weakSelf.addButton setTitle:buttonStr forState:UIControlStateNormal];
//        }];
    }
    return _viewModelVM;
}


- (void)setUPViewModelVM: (HXBFin_DetailsViewBase_ViewModelVM* (^)(HXBFin_DetailsViewBase_ViewModelVM *viewModelVM))detailsViewBase_ViewModelVMBlock {
    self.viewModelVM = detailsViewBase_ViewModelVMBlock(self.viewModelVM);
    ///倒计时
    self.diffTime = _viewModelVM.diffTime;
    //是否倒计时
    self.isContDown = _viewModelVM.isCountDown;
}


- (void)setViewModelVM:(HXBFin_DetailsViewBase_ViewModelVM *)viewModelVM {
    _viewModelVM = viewModelVM;
    self.totalInterestStr           = viewModelVM.totalInterestStr;
    self.startInvestmentStr         = viewModelVM.startInvestmentStr;
    self.remainAmount               = viewModelVM.remainAmount;

    self.totalInterestStr_const     = viewModelVM.totalInterestStr_const;
    self.remainAmount_const         = viewModelVM.remainAmount_const;
    self.startInvestmentStr_const   = viewModelVM.startInvestmentStr_const;
    self.promptStr                  = viewModelVM.promptStr;
    self.addButtonStr               = viewModelVM.addButtonStr;
    self.lockPeriodStr              = viewModelVM.lockPeriodStr;
    [self show];
}

- (void) setAddButtonStr:(NSString *)addButtonStr {
    _addButtonStr = addButtonStr;
    [self.addButton setTitle:addButtonStr forState:UIControlStateNormal];
}
- (void)setModelArray:(NSArray<HXBFinDetail_TableViewCellModel *> *)modelArray {
    _modelArray = modelArray;
    self.bottomTableView.tableViewCellModelArray = modelArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        [self show];
        [self setSubView];
    }
    return self;
}

- (void)setSubView {
    
}
- (void)show {
    //移除子控件，在进行UI布局
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self setupSubView];
}
- (void)setupSubView {
    
    [self setupExpectedYearRateView];///预期年化的view
    [self setupSurplusValueView]; ///剩余可投里面
    [self setupAddTrustView];//曾信view（内部对是否分为左右进行了判断）
    [self setupFlowChartView];///流程引导视图
    [self setupTableView];///展示计划详情等的 tableView
    [self setupAddView];///立即加入视图
    
    self.expectedYearRateView.backgroundColor = [UIColor whiteColor];
    self.surplusValueView.backgroundColor = [UIColor whiteColor];
    self.flowChartView.backgroundColor = [UIColor darkGrayColor];
    self.addView.backgroundColor = [UIColor grayColor];
}

//MARK: - 预期年化的view
- (void)setupExpectedYearRateView {
    self.expectedYearRateView = [[UIView alloc]init];
    self.expectedYearRateView.frame = CGRectMake(0, 0, self.width, 200);
    //期限
    UILabel *lockPeriodLabel = [[UILabel alloc]init];
    [self addSubview:self.expectedYearRateView];
    [self upDownLableWithView:self.expectedYearRateView andDistance:kScrAdaptationH(15) andFirstFont:kHXBFont_PINGFANGSC_REGULAR(40) andSecondFont: kHXBFont_PINGFANGSC_REGULAR(12) andFirstStr:[NSString stringWithFormat:@"%@%@",self.totalInterestStr,@"%"]  andSecondStr:[NSString stringWithFormat:@"%@",self.totalInterestStr_const]];
    
    [self.expectedYearRateView addSubview:lockPeriodLabel];
    [lockPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.expectedYearRateView);
        make.top.equalTo(self).offset(kScrAdaptationH(44)+ 64);
        make.height.width.equalTo(@(kScrAdaptationH(80)));
    }];
    lockPeriodLabel.text = self.viewModelVM.lockPeriodStr;
}

//MARK: - 剩余可投view
- (void)setupSurplusValueView {
    self.surplusValueView = [[UIView alloc]init];
    [self addSubview:self.surplusValueView];
    
    __weak typeof (self) weakSelf = self;
    [self.surplusValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expectedYearRateView.mas_bottom).offset(1);
        make.right.left.equalTo(weakSelf);
        make.height.equalTo(@(kScrAdaptationH(38)));
    }];
    
    //是否分为左右两个（起投，剩余金额）
    if (self.isFlowChart) {
        [self setupSurplusValueViewWithTowView];
    }else{
        [self upDownLableWithView:self.surplusValueView andDistance:10 andFirstFont:kHXBFont_PINGFANGSC_REGULAR(15) andSecondFont:kHXBFont_PINGFANGSC_REGULAR(12) andFirstStr:self.remainAmount andSecondStr:self.remainAmount_const];
    }
}

//剩余投资（起投，剩余金额 （散标标的期限，剩余金额）
- (void)setupSurplusValueViewWithTowView {
    __weak typeof (self) weakSelf = self;
    UIView *leftView = [[UIView alloc]init];
    [self.surplusValueView addSubview:leftView];
    UIView *rightView = [[UIView alloc]init];
    [self.surplusValueView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_centerX);
        make.height.left.top.equalTo(weakSelf.surplusValueView);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_centerX);
        make.height.right.top.equalTo(weakSelf.surplusValueView);
    }];
    
    [self upDownLableWithView:leftView andDistance:kScrAdaptationH(5) andFirstFont:kHXBFont_PINGFANGSC_REGULAR(15) andSecondFont:kHXBFont_PINGFANGSC_REGULAR(12)  andFirstStr:self.startInvestmentStr andSecondStr:self.startInvestmentStr_const];
    [self upDownLableWithView:rightView andDistance:10 andFirstFont:kHXBFont_PINGFANGSC_REGULAR(15) andSecondFont:kHXBFont_PINGFANGSC_REGULAR(12)   andFirstStr:self.remainAmount andSecondStr:self.remainAmount_const];
}
//MARK: - 增信
- (void)setupAddTrustView {
    kWeakSelf
    self.trustView = [[UIView alloc]init];
    [self addSubview: self.trustView];
    [self.trustView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.surplusValueView.mas_bottom).offset(1);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@80);
    }];
}

//MARK: - 引导视图
- (void)setupFlowChartView {
    kWeakSelf
    if (!self.isPlan) return;
        
    //如果是 则用增信view 不是则用剩余可投view作为约束参考
    UIView *view = self.isFlowChart ? self.trustView : self.surplusValueView;
    self.flowChartView = [[HXBFinBase_FlowChartView alloc]init];
    [self addSubview:self.flowChartView];
    [self.flowChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@100);
    }];
}
//MARK: - 立即加入按钮的添加
- (void)setupAddView {
    kWeakSelf
    self.addView = [[UIView alloc]init];
    [self addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    self.addButton = [[UIButton alloc]init];
    [self.addView addSubview:_addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(weakSelf.addView);
        make.left.top.equalTo(weakSelf.addView).offset(20);
        make.bottom.right.equalTo(weakSelf.addView).offset(-20);
    }];
    [self.addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton.backgroundColor = [UIColor blackColor];
    [self.addButton setTitle:self.addButtonStr forState:UIControlStateNormal];
    self.addButton.userInteractionEnabled = self.viewModelVM.isUserInteractionEnabled;
    
    self.countDownLabel = [[UILabel alloc]init];
    [self addSubview: self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addButton.mas_top);
        make.centerX.equalTo(self.addButton);
        make.height.equalTo(@(kScrAdaptationH(30)));
    }];
    
    //倒计时时间
}

- (void)clickAddButton: (UIButton *)button {
    NSLog(@" - 立即加入 - ");
    //a)	先判断是否>=1000，再判断是否为1000的整数倍（追加时只需判断是否为1000的整数倍），错误，toast提示“起投金额1000元”或“投资金额应为1000的整数倍”

    if (self.clickAddButtonBlock) {
        self.clickAddButtonBlock();
    }
}


//生成一上一下lable
- (void)upDownLableWithView: (UIView *)view andDistance: (CGFloat)distance andFirstFont: (UIFont *)font andSecondFont: (UIFont *)secondFont andFirstStr: (NSString *)firstStr andSecondStr: (NSString *)secondStr{
    
    //预期年化的数字部分
    UILabel *firstLable = [[UILabel alloc]init];
    firstLable.font = font;
    [view addSubview:firstLable];
    [firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view.mas_centerY).offset(-(distance / 2));
        make.height.equalTo(@30);
    }];
    
    //预期年化
    UILabel *secondLable = [[UILabel alloc]init];
    [view addSubview:secondLable];
    [secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLable.mas_bottom).offset((distance / 2));
        make.centerX.equalTo(firstLable.mas_centerX);
    }];
    firstLable.text = firstStr;
    secondLable.text = secondStr;
    secondLable.textColor = [UIColor grayColor];
}


//MARK: - 展示计划详情等的 tableView
- (void)setupTableView {
    kWeakSelf
    self.bottomTableView = [[HXBFinDetail_TableView alloc]init];
    self.bottomTableView.tableViewCellModelArray = self.modelArray;
    self.bottomTableView.bounces = false;
    [self addSubview:self.bottomTableView];
    UIView *view = self.isPlan? self.flowChartView : self.trustView;
    [self.bottomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(1);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@120);
    }];
    //cell的点击事件
    [self.bottomTableView clickBottomTableViewCellBloakFunc:self.clickBottomTabelViewCellBlock];
    self.bottomTableView.rowHeight = 40;
    UILabel *lable = [[UILabel alloc]init];
    [self addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomTableView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
    lable.text = self.promptStr;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor grayColor];
}
//MARK: 事件的传递
- (void)clickBottomTableViewCellBloakFunc:(void (^)(NSIndexPath *, HXBFinDetail_TableViewCellModel *))clickBottomTabelViewCellBlock {
    self.clickBottomTabelViewCellBlock = clickBottomTabelViewCellBlock;
}
/// 点击了立即加入的button
- (void) clickAddButtonFunc: (void(^)())clickAddButtonBlock {
    self.clickAddButtonBlock = clickAddButtonBlock;
}
@end

@interface HXBFin_DetailsViewBase_ViewModelVM ()
@property (nonatomic,copy) void(^addButtonChengeTitleBlock)(NSString *buttonTitle);
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *countDownTemp;
@end
@implementation HXBFin_DetailsViewBase_ViewModelVM
- (void)setAddButtonStr:(NSString *)addButtonStr {
    _addButtonStr = addButtonStr;
    if (self.addButtonChengeTitleBlock) {
        self.addButtonChengeTitleBlock(addButtonStr);
    }
}
- (void)addButtonChengeTitleChenge:(void (^)(NSString *))addButtonChengeTitleBlock {
    self.addButtonChengeTitleBlock = addButtonChengeTitleBlock;
}
//懒加载
- (NSTimer *) timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTimeFunc) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
    return _timer;
}
/**
 加入时间
 */
- (void) addTimeFunc {
    self.countDownStr = @(self.countDownStr.integerValue - 1000).description;
}
- (void)setCountDownStr:(NSString *)countDownStr {
    _countDownStr = countDownStr;
    if (self.countDownStr.integerValue < 60 * 60 * 1000) {
        [self timer];
    }
    _countDownStr = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:countDownStr andDateFormat:@"d天h时"];
    _countDownStr = [NSString stringWithFormat:@"剩余投标时间：%@",_countDownStr];
}

@end
