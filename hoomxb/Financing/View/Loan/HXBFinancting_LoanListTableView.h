//
//  HXBFinancting_LoanListTableView.h
//  hoomxb
//
//  Created by HXB on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBFinancting_LoanListTableView : HXBBaseTableView
///点击散标列表后回调，跳转详情页
@property (nonatomic,copy) void (^clickLoanListCellBlock)(NSIndexPath *index, id model);
@end