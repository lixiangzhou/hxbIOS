//
//  HXBAlertVC.h
//  hoomxb
//
//  Created by HXB-C on 2017/6/27.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBAlertVC : UIViewController

/**
 messagetitle
 */
@property (nonatomic, copy) NSString *messageTitle;

/**
 子标题
 */
@property (nonatomic, copy) NSString *subTitle;

/**
 message
 */
@property (nonatomic, copy) NSString *messageLabelText;

/**
 是否是验证码
 */
@property (nonatomic, assign) BOOL isCode;
//是否有语音验证码
@property (nonatomic, assign) BOOL isSpeechVerificationCode;
// 类型
@property (nonatomic, assign) BOOL speechType; // 1是充值、充值购买、注册 0是其他的页面
/**
 是否是电话
 */
@property (nonatomic, assign) BOOL isMobile;

/**
 是否清空
 */
@property (nonatomic, assign) BOOL isCleanPassword;
/**
 确认按钮
 */
@property (nonatomic, copy) void(^sureBtnClick)(NSString *pwd);

///**
// 忘记密码按钮
// */
@property (nonatomic, copy) void(^forgetBtnClick)();
//getSpeechVerificationCodeBlock获取语音验证码
@property (nonatomic, copy) void (^getSpeechVerificationCodeBlock)();
/**
 getVerificationCodeBlock
 */
@property (nonatomic, copy) void(^getVerificationCodeBlock)();

@end
