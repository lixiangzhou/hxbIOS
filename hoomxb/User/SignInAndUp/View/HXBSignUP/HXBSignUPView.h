//
//  HXBSignUPView.h
//  hoomxb
//
//  Created by HXB on 2017/6/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBSignUPAndLoginRequest_EnumManager.h"
///关于 注册的view
@interface HXBSignUPView : UIView
- (void)signUPClickNextButtonFunc: (void(^)(NSString *mobile))clickNextButtonBlock;
///请求 手机好校验
- (void)checkMobileWithBlockFunc: (void(^)(NSString *mobile))checkMobileBlock;
///手机号校验 信息展示label的text
@property (nonatomic, copy) NSString *checkMobileStr;

@property (nonatomic, assign) BOOL isHiddenLoginBtn;

///点击了已有账号，去登陆按钮
- (void) clickHaveAccountButtonFunc: (void(^)())clickHaveAccountButtonBlock;
@property (nonatomic,assign) HXBSignUPAndLoginRequest_sendSmscodeType type;
@end
