//
//  HXBMY_LoanTruansferViewModel.h
//  hoomxb
//
//  Created by HXB on 2017/8/1.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseViewModel.h"
#import "HXBMY_LoanTruansferModel.h"
@interface HXBMY_LoanTruansferViewModel : HXBBaseViewModel
@property (nonatomic,strong)HXBMY_LoanTruansferModel *my_truanfserModel;
/**
 @"剩余期限(月)"
 */
@property (nonatomic,copy) NSString * remainMonthStr;
/**
 @"年利率"
 */
@property (nonatomic,copy) NSString * interest;

/**
 待转金额
 */
@property (nonatomic,copy) NSString *amountTransferStr;

/**
 消费借款
 */
@property (nonatomic,copy) NSString *loanTitle;

 /**
 状态 (汉字)
 TRANSFERING：正在转让，
 TRANSFERED：转让完毕，
 CANCLE：已取消，
 CLOSED_CANCLE：结标取消，
 OVERDUE_CANCLE：逾期取消，
 PRESALE：转让预售
 */
@property (nonatomic, copy) NSString *status_UI;

/// 加入按钮的颜色
@property (nonatomic,strong) UIColor *addButtonBackgroundColor;
///加入按钮的字体颜色
@property (nonatomic,strong) UIColor *addButtonTitleColor;
///addbutton 边缘的颜色
@property (nonatomic,strong) UIColor *addButtonBorderColor;
//addButton可否被点击
@property (nonatomic,assign) BOOL isUserInteractionEnabled;
@end
