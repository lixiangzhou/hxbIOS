//
//  HXBFinanctingViewModel_PlanList.h
//  hoomxb
//
//  Created by HXB on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXBFinHomePageModel_PlanList;
///红利计划的首页ViewModel
@interface HXBFinHomePageViewModel_PlanList : NSObject
///红利计划的model
@property (nonatomic,strong) HXBFinHomePageModel_PlanList *planListModel;
///红利计划列表页的年计划利率
@property (nonatomic,copy) NSAttributedString *expectedYearRateAttributedStr;
///红利计划待出售状态
@property (nonatomic,copy) NSString *unifyStatus;
///是否隐藏倒计时
@property (nonatomic,assign) BOOL isHidden;
///是否需要倒计时
@property (nonatomic,assign) BOOL isCountDown;
///倒计时的String
@property (nonatomic,copy) NSString *countDownLastStr;
///储存倒计时时间的string
@property (nonatomic,copy) NSString *countDownString;
/// 等待加入的时候，剩余时间大于一小时
@property (nonatomic,copy) NSString *remainTimeString;
/// 加入按钮的颜色
@property (nonatomic,strong) UIColor *addButtonBackgroundColor;
///加入按钮的字体颜色
@property (nonatomic,strong) UIColor *addButtonTitleColor;
///addbutton 边缘的颜色
@property (nonatomic,strong) UIColor *addButtonBorderColor;

@end
