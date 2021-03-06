//
//  HXBFin_LoanTruansferDetail_TopView.h
//  hoomxb
//
//  Created by HXB on 2017/7/7.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXBBaseView_TwoLable_View_ViewModel;

@interface HXBFin_LoanTruansferDetail_TopView : HXBColourGradientView
/**
 下个还款日 05-31
 品字形 上右
 */
@property (nonatomic,copy) NSString *nextOneText;
/**
 年利率 label
 品字形 上
 */
@property (nonatomic,copy) NSString *interestLabelLeftStr;
/**
 剩余期限
 品字形 左
 */
@property (nonatomic,copy) NSString *remainTimeLabelLeftStr;
/**
 待转让金额
 品字形 右
 */
@property (nonatomic,copy) NSString *truansferAmountLabelLeftStr;



//- (void)setUPValueWithManager: (HXBFin_LoanTruansferDetail_TopViewManager *(^)(HXBFin_LoanTruansferDetail_TopViewManager *manager))setUPValueManagerBlock;

@end

//@interface HXBFin_LoanTruansferDetail_TopViewManager : NSObject
//
///**
// 下个还款日 05-31
// 品字形 上右
// */
//@property (nonatomic,copy) NSString *nextOneLabel;
///**
// 年利率 label
// 品字形 上
// */
//@property (nonatomic,strong) HXBBaseView_TwoLable_View_ViewModel *interestLabelManager;
///**
// 剩余期限
// 品字形 左
// */
//@property (nonatomic,strong) HXBBaseView_TwoLable_View_ViewModel *remainTimeLabelManager;
///**
// 待转让金额
// 品字形 右
// */
//@property (nonatomic,strong) HXBBaseView_TwoLable_View_ViewModel *truansferAmountLabelManager;
//@end
