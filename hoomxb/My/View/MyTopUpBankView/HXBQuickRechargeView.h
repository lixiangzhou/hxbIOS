//
//  HXBQuickRechargeView.h
//  hoomxb
//
//  Created by HXB-C on 2017/7/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBQuickRechargeView : UIView

/**
 充值完成Block
 */
@property (nonatomic, copy) void(^rechargeBtnClickBlock)();

@end
