//
//  HXBMY_LoanTruansferTableView.m
//  hoomxb
//
//  Created by HXB on 2017/8/1.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMY_LoanTruansferTableView.h"
#import "HXBFin_TableViewCell_LoanTransfer.h"
#import "HXBBaseViewCell_MYListCellTableViewCell.h"
static NSString *const CELLID = @"CELLID";
@interface HXBMY_LoanTruansferTableView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) void(^clickPlanListCellBlock)(NSIndexPath *index,HXBMY_LoanTruansferViewModel *viewModel);
@property (nonatomic,strong) HXBNoDataView *nodataView;
@end
@implementation HXBMY_LoanTruansferTableView

- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = kHXBColor_BackGround;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[HXBBaseViewCell_MYListCellTableViewCell class] forCellReuseIdentifier:CELLID];
    self.nodataView.hidden = false;
    self.rowHeight = kScrAdaptationH(140);
    [HXBMiddlekey AdaptationiOS11WithTableView:self];
}
- (void)setLoanTruansferViewModelArray:(NSArray<HXBMY_LoanTruansferViewModel *> *)loanTruansferViewModelArray {
    _loanTruansferViewModelArray = loanTruansferViewModelArray;
    self.nodataView.hidden = loanTruansferViewModelArray.count;
    [self reloadData];
}
#pragma mark - datesource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.loanTruansferViewModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXBBaseViewCell_MYListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArray = @[
                            @"年利率",
                            @"待转出金额(元)",
                            @"剩余期限",
                            ];
    [cell setUPValueWithListCellManager:^HXBBaseViewCell_MYListCellTableViewCellManager *(HXBBaseViewCell_MYListCellTableViewCellManager *manager) {
        manager.title_LeftLabelStr = self.loanTruansferViewModelArray[indexPath.section].loanTitle;
        HXBMY_LoanTruansferViewModel *model = self.loanTruansferViewModelArray[indexPath.section];
        manager.bottomViewManager.leftStrArray = titleArray;
        manager.bottomViewManager.rightStrArray = @[
                                                    model.interest,
                                                    model.amountTransferStr,
                                                    model.remainMonthStr
                                                    ];
        return manager;
    }];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //拿到cell的model
    //点击后的block回调给了HomePageView
    if (self.clickPlanListCellBlock) {
        self.clickPlanListCellBlock(indexPath, self.loanTruansferViewModelArray[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScrAdaptationH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - getter(懒加载)
- (HXBNoDataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[HXBNoDataView alloc]initWithFrame:CGRectZero];
        [self addSubview:_nodataView];
        _nodataView.imageName = @"Fin_NotData";
        _nodataView.noDataMassage = @"暂无数据";
//        _nodataView.downPULLMassage = @"下拉进行刷新";
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kScrAdaptationH(100));
            make.height.width.equalTo(@(kScrAdaptationH(184)));
            make.centerX.equalTo(self);
        }];
    }
    return _nodataView;
}




@end
