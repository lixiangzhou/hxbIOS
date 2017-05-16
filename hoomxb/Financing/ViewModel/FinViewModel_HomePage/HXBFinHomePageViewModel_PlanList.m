//
//  HXBFinanctingViewModel_PlanList.m
//  hoomxb
//
//  Created by HXB on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFinHomePageViewModel_PlanList.h"
#import "HXBFinHomePageModel_PlanList.h"

/**
 * 关于代售状态的枚举
 */
typedef enum : NSUInteger {
    ///等待预售开始超过30分
    HXBFinHomePageViewModel_PlanList_BOOKFAR,
    ///等待预售开始小于30分钟
    HXBFinHomePageViewModel_PlanList_BOOKNEAR,
    ///预定
    HXBFinHomePageViewModel_PlanList_BOOK,
    ///预定满额
    HXBFinHomePageViewModel_PlanList_BOOKFULL,
    ///等待开放购买大于30分钟
    HXBFinHomePageViewModel_PlanList_WAIT_OPEN,
    ///等待开放购买小于30分钟
    HXBFinHomePageViewModel_PlanList_WAIT_RESERVE,
    ///开放加入
    HXBFinHomePageViewModel_PlanList_OPENING,
    ///加入满额
    HXBFinHomePageViewModel_PlanList_OPEN_FULL,
    ///收益中
    HXBFinHomePageViewModel_PlanList_PERIOD_LOCKING,
    ///开放期
    HXBFinHomePageViewModel_PlanList_PERIOD_OPEN,
    ///已退出
    HXBFinHomePageViewModel_PlanList_PERIOD_CLOSED,
} HXBFinHomePageViewModel_PlanList_Status;


@implementation HXBFinHomePageViewModel_PlanList



- (void)setPlanListModel:(HXBFinHomePageModel_PlanList *)planListModel {
    _planListModel = planListModel;
//    self.countDownLastStr = planListModel.displayTime;
    NSDate *date = [[NSDate alloc]init];
    NSString *dateStr = @([date timeIntervalSince1970] + 30).description;
    self.countDownLastStr = dateStr;
}



#pragma mark - getter
//红利计划状态
- (NSString *)unifyStatus {
    if (!_unifyStatus) {
        [self setupUnifyStatus];
    }
    return _unifyStatus;
}

// 红利计划列表页的cell里面的年利率
- (NSAttributedString *)expectedYearRateAttributedStr {
    if (!_expectedYearRateAttributedStr) {
       [self setupExpectedYearRateAttributedStr];
    }
    return _expectedYearRateAttributedStr;
}

//红利计划状态
- (void)setupUnifyStatus {
    switch (self.planListModel.unifyStatus.integerValue) {
        case HXBFinHomePageViewModel_PlanList_BOOKFAR://等待预售开始超过30分
        case HXBFinHomePageViewModel_PlanList_BOOKNEAR://等待预售开始小于30分钟
        case HXBFinHomePageViewModel_PlanList_BOOK://预定
        case HXBFinHomePageViewModel_PlanList_BOOKFULL://预定满额
        case HXBFinHomePageViewModel_PlanList_WAIT_OPEN://等待开放购买大于30分钟
        case HXBFinHomePageViewModel_PlanList_WAIT_RESERVE://等待开放购买小于30分钟
            self.unifyStatus = @"等待加入";
            break;
        case HXBFinHomePageViewModel_PlanList_OPENING://开放加入
        case HXBFinHomePageViewModel_PlanList_OPEN_FULL://加入满额
            self.unifyStatus = @"加入";
            break;
        case HXBFinHomePageViewModel_PlanList_PERIOD_LOCKING://收益中
        case HXBFinHomePageViewModel_PlanList_PERIOD_OPEN://开放期
            self.unifyStatus = @"收益中";
            break;
        case HXBFinHomePageViewModel_PlanList_PERIOD_CLOSED://已退出
            self.unifyStatus = @"等待计息";
            break;
    }
}
//红利计划列表的年利率计算
- (void)setupExpectedYearRateAttributedStr {
    
    NSInteger length = self.planListModel.expectedYearRate.length;
    
    NSString *expectedYearRateStr = [NSString stringWithFormat:@"%@%@",self.planListModel.expectedYearRate,@"%"];
    
    self.expectedYearRateAttributedStr = [NSMutableAttributedString setupAttributeStringWithString:expectedYearRateStr WithRange:NSMakeRange(0, length) andAttributeColor:[UIColor redColor] andAttributeFont:[UIFont systemFontOfSize:25]];
}






///监听是否倒计时了
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
@end