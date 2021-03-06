//
//  HxbSignInView.h
//  hoomxb
//
//  Created by HXB-C on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HxbSignInView : UIView
//事件的传递

@property (nonatomic, assign) BOOL isDeletePassword;

///点击了登录按钮
- (void)signIN_ClickButtonFunc:(void (^)(NSString *pasword,NSString *mobile))clickSignInButtonBlock;
///点击了注册按钮
- (void) signUP_clickButtonFunc: (void(^)())clickSignUPButtonBlock;
///请求手机号是否存在
- (void) checkMobileRequestBlockFunc: (void(^)(NSString *mobile))checkMobileBlock;
///点击了忘记密码
- (void) clickforgetPasswordButtonFunc: (void(^)())forgetPasswordButtonBlock;
///点击了用户协议
- (void) clickUserAgreementBtnFunc: (void(^)())userAgreementBtnBlock;

@end
