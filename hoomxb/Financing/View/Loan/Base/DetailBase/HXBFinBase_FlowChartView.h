//
//  HXBFinBase_FlowChartView.h
//  hoomxb
//
//  Created by HXB on 2017/5/5.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ///没有加入
    HXBFinBase_FlowChartView_Plan_Stage_Null,
    ///加入中
    HXBFinBase_FlowChartView_Plan_Stage_Add,
    ///开始收益
    HXBFinBase_FlowChartView_Plan_Stage_Begin,
    ///到期退出
    HXBFinBase_FlowChartView_Plan_Stage_Leave,
} HXBFinBase_FlowChartView_Plan_Stage;

static NSString *kHXB_FinPlan_Add = @"加入";
static NSString *kHXB_FinPlan_Begin = @"开始收益";
static NSString *kHXB_FinPlan_Leave = @"到期退出";
@class HXBFinBase_FlowChartView_Manager;
@interface HXBFinBase_FlowChartView : UIView
/**
 第几个阶段
 加入中，开始收益，到期退出
 */
@property (nonatomic,assign) NSInteger stage;
///设置值
- (void)setUPFlowChartViewManagerWithManager: (HXBFinBase_FlowChartView_Manager *(^)(HXBFinBase_FlowChartView_Manager *manager))flowChartViewManagerBlock;

@end

@interface HXBFinBase_FlowChartView_Manager : NSObject
/**
 第几个阶段
 加入中，开始收益，到期退出
 */
@property (nonatomic,assign) NSInteger stage;
/**
 加入时间
 */
@property (nonatomic,copy) NSString * addTime;
/**
 开始收益时间
 */
@property (nonatomic,copy) NSString * beginTime;
/**
 到期退出时间
 */
@property (nonatomic,copy) NSString * leaveTime;
@end
