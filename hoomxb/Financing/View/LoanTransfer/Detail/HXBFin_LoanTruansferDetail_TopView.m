//
//  HXBFin_LoanTruansferDetail_TopView.m
//  hoomxb
//
//  Created by HXB on 2017/7/7.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFin_LoanTruansferDetail_TopView.h"
#import "HXBFinDetail_TableView.h"
@interface HXBFin_LoanTruansferDetail_TopView ()
/**
顶部的后面的遮罩
 */
@property (nonatomic,strong) UIView *topMaskView;
/**
 下个还款日 05-31 
 品字形 上右
 */
@property (nonatomic,strong) UILabel *nextOneLabel;
/**
 年利率 label
 品字形 上
 */
@property (nonatomic,strong) HXBBaseView_TwoLable_View *interestLabel;
/**
 剩余期限
 品字形 左
 */
@property (nonatomic,strong) HXBBaseView_TwoLable_View *remainTimeLabel;
/**
 待转让金额
 品字形 右
 */
@property (nonatomic,strong) HXBBaseView_TwoLable_View *truansferAmountLabel;
@property (nonatomic,strong) HXBFin_LoanTruansferDetail_TopViewManager *manager;
@end
@implementation HXBFin_LoanTruansferDetail_TopView
- (void)setUPValueWithManager: (HXBFin_LoanTruansferDetail_TopViewManager *(^)(HXBFin_LoanTruansferDetail_TopViewManager *manager))setUPValueManagerBlock {
    self.manager = setUPValueManagerBlock(self.manager);
}
- (void)setManager:(HXBFin_LoanTruansferDetail_TopViewManager *)manager {
    kWeakSelf
    self.nextOneLabel.text = manager.nextOneLabel;
    [self.interestLabel setUP_TwoViewVMFunc:^HXBBaseView_TwoLable_View_ViewModel *(HXBBaseView_TwoLable_View_ViewModel *viewModelVM) {
        return weakSelf.manager.interestLabelManager;
    }];
    [self.remainTimeLabel setUP_TwoViewVMFunc:^HXBBaseView_TwoLable_View_ViewModel *(HXBBaseView_TwoLable_View_ViewModel *viewModelVM) {
        return weakSelf.manager.remainTimeLabelManager;
    }];
    [self.truansferAmountLabel setUP_TwoViewVMFunc:^HXBBaseView_TwoLable_View_ViewModel *(HXBBaseView_TwoLable_View_ViewModel *viewModelVM) {
        return weakSelf.manager.truansferAmountLabelManager;
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUP];
        _manager = [[HXBFin_LoanTruansferDetail_TopViewManager alloc]init];
    }
    return self;
}

- (void)setUP {
    [self creatViews];
    [self setUPFrame];
}

- (void)creatViews {
    self.topMaskView = [[UIView alloc]init];
    self.nextOneLabel = [[UILabel alloc]init];
    self.interestLabel = [[HXBBaseView_TwoLable_View alloc]initWithFrame:CGRectZero];
    self.remainTimeLabel = [[HXBBaseView_TwoLable_View alloc]initWithFrame:CGRectZero];
    self.truansferAmountLabel = [[HXBBaseView_TwoLable_View alloc]initWithFrame:CGRectZero];

    [self addSubview:self.topMaskView];
    [self addSubview:self.nextOneLabel];
    [self addSubview:self.interestLabel];
    [self addSubview:self.remainTimeLabel];
    [self addSubview:self.truansferAmountLabel];
}

- (void)setUPFrame {
    [self.topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH(80)));
    }];
    [self.nextOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationH(20));
        make.right.equalTo(self).offset(kScrAdaptationH(20));
        make.height.equalTo(@(kScrAdaptationH(20)));
    }];
    [self.nextOneLabel sizeToFit];
    
    [self.interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kScrAdaptationH(40)));
        make.centerX.equalTo(self);
        make.height.equalTo(@(kScrAdaptationH(50)));
    }];
    
    [self.remainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMaskView.mas_bottom);
        make.left.equalTo(self);
        make.width.equalTo(self).multipliedBy(1/2.0);
    }];
    
    [self.truansferAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMaskView.mas_bottom);
        make.left.equalTo(self.remainTimeLabel.mas_right);
        make.width.equalTo(self.remainTimeLabel);
    }];
}
@end
@implementation HXBFin_LoanTruansferDetail_TopViewManager
@end