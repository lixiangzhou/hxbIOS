//
//  HXBMY_PlanDetailView.m
//  hoomxb
//
//  Created by HXB on 2017/5/19.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMY_PlanDetailView.h"
#import "HXBMYViewModel_PlanDetailViewModel.h"

#import "HXBMY_PlanDtetail_Topcell.h"//顶部的cell
#import "HXBMY_PlanDetail_InfoCell.h"//中部的信息的Cell
#import "HXBMY_PlanDetail_TypeCell.h"//底部的左右 都有lable的cell
#import "HXBMY_PlanInvestmentRecordCell.h"//投资记录
#import "HXBBaseView_TwoLable_View.h"///两个label的组件
#import "HXBBaseView_MoreTopBottomView.h"///多个topBottomView
#import "HXBFinDetail_TableView.h"///tableView
///红利详情 顶部的cell
static NSString *kTOPCELLID = @"kTOPCELLID";
///中部的信息的Cell
static NSString *kINFOCELLID = @"kINFOCELLID";
///底部的左右 都有lable的cell
static NSString *kTYPECELLID = @"kTYPECELLID";
///投资记录的cell
static NSString *kINVESTMENTRECORD = @"kINVESTMENTRECORD";


///收益方式
static NSString *kTYPECELLID_INCOMETYPE = @"收益处理方式";
///合同
static NSString *kTYPTCELLID_CONTRACT = @"合同";
///投资记录
static NSString *kINVESTMENTRECORDCELL_INVESTMENTRECORD = @"投资记录";


@interface HXBMY_PlanDetailView ()
<
UITableViewDelegate,
UITableViewDataSource
>
/**
 顶部的VIew
 */
@property (nonatomic,strong) HXBColourGradientView          *topView;
/**
 状态的 view
 */
@property (nonatomic,strong) UIView                         *topStatusView;
@property (nonatomic,strong) UIImageView                    *topStatusImageView;
/**
 状态的Label
 */
@property (nonatomic,strong) UILabel                        *topStatusLabel;
/**
 topViewMassge
 */
@property (nonatomic,strong) HXBBaseView_TwoLable_View      *topViewMassge;
/**
  标信息的view
 */
@property (nonatomic,strong) HXBBaseView_MoreTopBottomView  *infoView;
/**
 type view
 */
@property (nonatomic,strong) HXBBaseView_MoreTopBottomView      *typeView;
///**
// 合同view
// */
//@property (nonatomic,strong) HXBBaseView_MoreTopBottomView      *contractView;
///**
// 投资记录
// */
//@property (nonatomic,strong) HXBBaseView_MoreTopBottomView      *loanRecordView;
/**
 管理者
 */
@property (nonatomic,strong) HXBMY_PlanDetailView_Manager *manager;
/**
 追加按钮 只有等待计息 显示
 */
@property (nonatomic,strong) UIButton *addButton;

/**
 点击了追加按钮
 */
@property (nonatomic,copy) void(^clickAddButton)(UIButton *button);
/**
 投资记录
 红利计划服务协议
 */
@property (nonatomic,strong) HXBFinDetail_TableView *tableView;
/**
 红利计划服务协议 投资记录的点击事件
 */
@property (nonatomic,strong) void(^clickBottomTableViewCell) (NSInteger index);

@end
@implementation HXBMY_PlanDetailView
- (instancetype)initWithFrame:(CGRect)frame andInfoHaveCake:(NSInteger)cake {
    self = [super initWithFrame:frame];
    if (self) {
        _manager = [[HXBMY_PlanDetailView_Manager alloc]init];
        self.cake = cake;
    }
    return self;
}
- (void)setUPValueWithViewManagerBlock: (HXBMY_PlanDetailView_Manager *(^)(HXBMY_PlanDetailView_Manager *manager))viewManagerBlock{
    self.manager = viewManagerBlock(_manager);
    self.topStatusLabel.text = _manager.topViewStatusStr;
    [self.addButton setHidden: _manager.isHiddenAddButton];
    self.topStatusImageView.svgImageString = _manager.typeImageName;
    kWeakSelf
    [self.topViewMassge setUP_TwoViewVMFunc:^HXBBaseView_TwoLable_View_ViewModel *(HXBBaseView_TwoLable_View_ViewModel *viewModelVM) {
        return weakSelf.manager.topViewMassgeManager;
    }];
    [self.infoView setUPViewManagerWithBlock:^HXBBaseView_MoreTopBottomViewManager *(HXBBaseView_MoreTopBottomViewManager *viewManager) {
        return  weakSelf.manager.infoViewManager;
    }];
    [self.typeView setUPViewManagerWithBlock:^HXBBaseView_MoreTopBottomViewManager *(HXBBaseView_MoreTopBottomViewManager *viewManager) {
        return weakSelf.manager.typeViewManager;
    }];
    self.tableView.strArray = _manager.strArray;
    self.tableView.contentSize = CGSizeMake(kScreenWidth, _manager.strArray.count * kScrAdaptationH(45));
}

- (void)setPlanDetailViewModel:(HXBMYViewModel_PlanDetailViewModel *)planDetailViewModel {
    _planDetailViewModel = planDetailViewModel;
//    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _manager = [[HXBMY_PlanDetailView_Manager alloc]init];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self setUPViews];
}
- (void)setUPViews {
    [self setUPViews_Create];
    [self setUPValue];
    [self setUPViews_Frame];
}
- (void)setUPViews_Create {
    self.topView        = [[HXBColourGradientView alloc]init];
    self.topStatusLabel = [[UILabel alloc]init];
    self.topStatusView  = [[UIView alloc]init];
    self.topStatusImageView = [[UIImageView alloc]init];
    self.topStatusLabel.textColor = [UIColor whiteColor];
    self.addButton      = [[UIButton alloc]init];
    self.addButton.hidden = true;
    self.topViewMassge  = [[HXBBaseView_TwoLable_View alloc]initWithFrame:CGRectZero];
    self.tableView = [[HXBFinDetail_TableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    UIEdgeInsets infoView_insets = UIEdgeInsetsMake(kScrAdaptationH750(30), kScrAdaptationH750(30), kScrAdaptationH750(30), kScrAdaptationH750(30));
    NSLog(@"______%ld", self.cake);
    self.infoView       = [[HXBBaseView_MoreTopBottomView alloc]initWithFrame:CGRectNull andTopBottomViewNumber:self.cake andViewClass:[UILabel class] andViewHeight:kScrAdaptationH750(30) andTopBottomSpace:kScrAdaptationH750(40) andLeftRightLeftProportion:0 Space:infoView_insets];
     self.typeView       = [[HXBBaseView_MoreTopBottomView alloc]initWithFrame:CGRectNull andTopBottomViewNumber:1 andViewClass:[UILabel class] andViewHeight:kScrAdaptationH750(30) andTopBottomSpace:0 andLeftRightLeftProportion:0 Space:infoView_insets];
    
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.topViewMassge];
    [self.topView addSubview: self.topStatusView];
    [self.topStatusView addSubview:self.topStatusLabel];
    [self.topView addSubview: self.topStatusImageView];
    [self addSubview:self.infoView];
    [self addSubview:self.typeView];
    [self addSubview:self.addButton];
    [self addSubview:self.tableView];
    
    [self.addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setTitle:@"追加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)clickBottomTableViewCellBloakFunc:(void(^)(NSInteger index))clickBottomTableViewCell {
    self.clickBottomTableViewCell = clickBottomTableViewCell;
}

- (void)clickAddButton: (UIButton *)button {
    if (self.clickAddButton) {
        self.clickAddButton(button);
    }
}
- (void)clickAddButtonWithBlock:(void(^)(UIButton *button))clickAddButtonBlock {
    self.clickAddButton = clickAddButtonBlock;
}
- (void)setUPViews_Frame {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH750(375)));
    }];
    [self.topViewMassge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_centerX);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.height.equalTo(@(kScrAdaptationH750(143)));
        make.width.equalTo(self);
    }];
    [self.topStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(kScrAdaptationH750(30));
        make.right.equalTo(self.topView).offset(40);
        make.height.equalTo(@(kScrAdaptationH750(54)));
        make.right.equalTo(self.topStatusLabel).offset(kScrAdaptationW750(100));
        make.left.equalTo(self.topStatusLabel).offset(kScrAdaptationW750(-73));
    }];
    [self.topStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topStatusView);
        make.right.equalTo(self.topStatusView).offset(kScrAdaptationH750(-100));
        make.left.equalTo(self.topStatusView).offset(kScrAdaptationW750(73));
    }];
    [self.topStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topStatusLabel);
        make.right.equalTo(self.topStatusLabel.mas_left).offset(kScrAdaptationW750(-13));
        make.height.width.equalTo(@(kScrAdaptationW750(22)));
    }];
    [self.topStatusLabel sizeToFit];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kScrAdaptationH750(20));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH750(75 * self.cake)));
    }];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(kScrAdaptationH750(20));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH750(90)));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeView.mas_bottom).offset(kScrAdaptationH(10));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH750(180)));
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH(50)));
        make.width.equalTo(@(kScrAdaptationW(100)));
        make.centerX.equalTo(self);
    }];
}

- (void)setUPValue{
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.typeView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.topStatusView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    self.topStatusView.layer.borderWidth = kXYBorderWidth;
    self.topStatusView.layer.masksToBounds = true;
#pragma mark - 肖扬
    self.topStatusView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.07 ];
    self.topStatusLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
//    self.topStatusLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.07];
    self.topStatusLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.topStatusView.layer.cornerRadius = kScrAdaptationH750(54)/2.0;
    [self.tableView clickBottomTableViewCellBloakFunc:^(NSIndexPath *index, HXBFinDetail_TableViewCellModel *model) {
        if (self.clickBottomTableViewCell) {
            self.clickBottomTableViewCell(index.row);
        }
    }];
}
@end

@implementation HXBMY_PlanDetailView_Manager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topViewMassgeManager   = [[HXBBaseView_TwoLable_View_ViewModel alloc]init];
        self.topViewMassgeManager.leftLabelAlignment = NSTextAlignmentCenter;
        self.topViewMassgeManager.rightLabelAlignment = NSTextAlignmentCenter;
        self.topViewMassgeManager.leftFont = kHXBFont_PINGFANGSC_REGULAR_750(110);
        self.topViewMassgeManager.rightFont = kHXBFont_PINGFANGSC_REGULAR_750(24);
        self.topViewMassgeManager.leftViewColor = [UIColor whiteColor];
        self.topViewMassgeManager.rightViewColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        self.typeViewManager        = [[HXBBaseView_MoreTopBottomViewManager alloc]init];;
        self.typeViewManager.leftLabelAlignment = NSTextAlignmentLeft;
        self.typeViewManager.rightLabelAlignment = NSTextAlignmentRight;
        self.typeViewManager.leftFont = kHXBFont_PINGFANGSC_REGULAR_750(30);
        self.typeViewManager.rightFont = kHXBFont_PINGFANGSC_REGULAR_750(30);
        self.typeViewManager.leftTextColor = kHXBColor_Grey_Font0_2;
        self.typeViewManager.rightTextColor = kHXBColor_HeightGrey_Font0_4;
        
        self.infoViewManager        = [[HXBBaseView_MoreTopBottomViewManager alloc] init];
        self.infoViewManager.leftLabelAlignment = NSTextAlignmentLeft;
        self.infoViewManager.rightLabelAlignment = NSTextAlignmentRight;
        self.infoViewManager.leftFont = kHXBFont_PINGFANGSC_REGULAR_750(30);
        self.infoViewManager.rightFont = kHXBFont_PINGFANGSC_REGULAR_750(30);
        self.infoViewManager.leftTextColor = kHXBColor_Grey_Font0_2;
        self.infoViewManager.rightTextColor = RGB(153, 153, 153);
    }
    return self;
}
@end
