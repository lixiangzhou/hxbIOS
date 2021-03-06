//
//  HXBAlertManager.m
//  hoomxb
//
//  Created by HXB on 2017/6/30.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBAlertManager.h"
#import "HXBVersionUpdateModel.h"
#import "HXBBaseAlertViewController.h"
#import "HxbSecurityCertificationViewController.h"
#import "HXBSetGesturePasswordRequest.h"
#import "HXBRiskAssessmentViewController.h"
#import "HXBMiddlekey.h"
#import "HXBOpenDepositAccountViewController.h"
#import "HXBDepositoryAlertViewController.h"
#import "HXBXYAlertViewController.h"
#import "HXBAlertVC.h"

@interface HXBAlertManager ()

@property (nonatomic, strong) UIAlertController * alertController;

@end

@implementation HXBAlertManager
+ (void)alertNeedLoginAgainWithMeaage:(NSString *)message {
    HXBXYAlertViewController *alertVC = [[HXBXYAlertViewController alloc] initWithTitle:@"登录异常" Massage:message force:2 andLeftButtonMassage:@"知道了" andRightButtonMassage:@"重新登录"];
    [alertVC setClickXYRightButtonBlock:^{
        ///到登录界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
        ///显示Home
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBBotification_ShowHomeVC object:nil];
    }];
    [alertVC setClickXYLeftButtonBlock:^{
        ///显示Home
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBBotification_ShowHomeVC object:nil];
    }];
    
    // 获取最顶层控制器
    UITabBarController *tbVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *VC = nil;
    if ([tbVC isKindOfClass:NSClassFromString(@"HXBBaseTabBarController")]) {
        UINavigationController *NAV = tbVC.selectedViewController;
        VC = NAV.viewControllers.lastObject;
    }else{
        VC = tbVC;
    }
    
    [VC.navigationController presentViewController:alertVC animated:YES completion:nil];
}

/**
 判断购买 判断
 */
+ (void)checkOutRiskAssessmentWithSuperVC:(UIViewController *)vc andWithPushBlock:(void(^)())pushBlock
{
    [KeyChain downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
//        //判断是否安全认证
//        if([viewModel.userInfoModel.userInfo.isAllPassed isEqualToString:@"0"]) {
//            ///没有实名
//            HxbSecurityCertificationViewController *securityCertificationVC = [[HxbSecurityCertificationViewController alloc]init];
//            securityCertificationVC.popToClass = NSStringFromClass([weakSelf class]);
//            [vc.navigationController pushViewController:securityCertificationVC animated:true];
//            return;
//        }
        
        if (viewModel.userInfoModel.userInfo.isUnbundling) {
            [self callupWithphoneNumber:kServiceMobile andWithTitle:@"温馨提示" Message:[NSString stringWithFormat:@"您的身份信息不完善，请联系客服 %@", kServiceMobile]];
            return;
        }

        //开通存管银行账户
        if (!viewModel.userInfoModel.userInfo.isCreateEscrowAcc) {
            HXBDepositoryAlertViewController *alertVC = [[HXBDepositoryAlertViewController alloc] init];
            alertVC.immediateOpenBlock = ^{
                HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
//                openDepositAccountVC.userModel = viewModel;
                openDepositAccountVC.title = @"开通存管账户";
                openDepositAccountVC.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
                [vc.navigationController pushViewController:openDepositAccountVC animated:YES];
            };
            [vc.navigationController presentViewController:alertVC animated:NO completion:nil];
//            HXBBaseAlertViewController *alertVC = [[HXBBaseAlertViewController alloc]initWithMassage:@"您尚未开通存管账户请开通后在进行投资" andLeftButtonMassage:@"立即开通" andRightButtonMassage:@"取消"];
//            [alertVC setClickLeftButtonBlock:^{
//                HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
//                openDepositAccountVC.title = @"开通存管账户";
//                openDepositAccountVC.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
//                [vc.navigationController pushViewController:openDepositAccountVC animated:YES];
//            }];
//            [vc.navigationController presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        ///完善信息
        if (![viewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"])
        {
            HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
            openDepositAccountVC.title = @"完善信息";
            openDepositAccountVC.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
//            HXBBaseAlertViewController *alertVC = [[HXBBaseAlertViewController alloc]initWithMassage:@"您尚未完善信息请完善信息后在进行投资" andLeftButtonMassage:@"立即完善" andRightButtonMassage:@"取消"];
//            [alertVC setClickLeftButtonBlock:^{
//                HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
//                openDepositAccountVC.title = @"完善信息";
//                openDepositAccountVC.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
            [vc.navigationController pushViewController:openDepositAccountVC animated:YES];
//            }];
//            [vc.navigationController presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        ///风险评测
        if ([viewModel.userInfoModel.userInfo.riskType isEqualToString:@"立即评测"]) {
            HXBBaseAlertViewController *alertVC = [[HXBBaseAlertViewController alloc]initWithMassage:@"您尚未进行风险评估，请评估后再进行投资" andLeftButtonMassage:@"立即评估" andRightButtonMassage:@"我是保守型"];
            [alertVC setClickLeftButtonBlock:^{
                HXBRiskAssessmentViewController *riskAssessmentVC = [[HXBRiskAssessmentViewController alloc] init];
                [vc.navigationController pushViewController:riskAssessmentVC animated:YES];
                __weak typeof(riskAssessmentVC) weakRiskAssessmentVC = riskAssessmentVC;
                [riskAssessmentVC popWithBlock:^(NSString *type) {
                    [weakRiskAssessmentVC.navigationController popToViewController:vc animated:true];
                }];
            }];
            [alertVC setClickRightButtonBlock:^{
                HXBSetGesturePasswordRequest *riskModifyScore = [[HXBSetGesturePasswordRequest alloc] init];
                [riskModifyScore riskModifyScoreRequestWithScore:@"0" andSuccessBlock:^(id responseObject) {
                } andFailureBlock:^(NSError *error) {
                }];
//                NSString *string = [NSString stringWithFormat:@"您是保守型用户"];
//                [HxbHUDProgress showMessageCenter:string inView:vc.view];
            }];
            [vc.navigationController presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        
        ///条件全部满足
        if (pushBlock) {
            pushBlock();
        }
    } andFailure:^(NSError *error) {
        
    }];
}
/**
 初始化警告视图
 
 @param title title
 @param message message
 @return 创建的对象
 */
+ (instancetype)alertViewWithTitle:(NSString *)title andMessage:(NSString *)message
{
    HXBAlertManager *alertManager =  [[self alloc] init];
    alertManager.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    return alertManager;
}
/**
 添加一个按钮
 
 @param btnName 按钮的名字
 @param handler 处理的事件
 */

- (void)addButtonWithBtnName:(NSString *)btnName andWitHandler:(void(^)())handler
{
    UIAlertAction *actionBtn = [UIAlertAction actionWithTitle:btnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [self.alertController addAction:actionBtn];
}
/**
 显示
 
 @param vc 显示在哪个VC
 */
- (void)showWithVC:(UIViewController *)vc
{
    [vc presentViewController:self.alertController animated:YES completion:nil];
}
/**
 拨打电话封装
 
 @param phoneNumber 电话号
 */
+ (void)callupWithphoneNumber:(NSString *)phoneNumber andWithTitle:(NSString *)title Message:(NSString *)message {

    HXBXYAlertViewController *alertVC = [[HXBXYAlertViewController alloc] initWithTitle:title Massage:message force:2 andLeftButtonMassage:@"取消" andRightButtonMassage:@"拨打"];
    alertVC.isCenterShow = YES;
    [alertVC setClickXYRightButtonBlock:^{
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0" options:NSNumericSearch];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                /// 大于等于10.0系统使用此openURL方法
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
//        });
    }];
//    [alertVC setClickXYLeftButtonBlock:^{
//    }];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//    HXBAlertVC *alertVC = nil;
//    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
//        alertVC = (HXBAlertVC *)[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
//    }else{
//        alertVC = [[HXBAlertVC alloc] init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
//    }
//    
//    alertVC.isCode = YES;
//    alertVC.isMobile = YES;
//    alertVC.messageTitle = @"温馨提示";
//    alertVC.messageLabelText = message;
////    alertVC.messageLabelText = [NSString stringWithFormat:@"您的身份信息不完善，请联系客服 %@", kServiceMobile];
////    __weak typeof(alertVC) weakAlertVC = alertVC;
//    alertVC.sureBtnClick = ^(NSString *pwd){
//        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
//        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
//        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
//            /// 大于等于10.0系统使用此openURL方法
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//        }
//    };

    
//    HXBBaseAlertViewController *alertVC = [[HXBBaseAlertViewController alloc]initWithMassage:[NSString stringWithFormat:@"%@%@",message,phoneNumber] andLeftButtonMassage:@"取消" andRightButtonMassage:@"拨打"];
//    [alertVC setClickRightButtonBlock:^{
//        NSString *newPhone = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",newPhone];
//        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
//        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
//            /// 大于等于10.0系统使用此openURL方法
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//        }
//    }];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    
}

+ (void)checkversionUpdateWith:(HXBVersionUpdateModel *)versionUpdateModel {
    if ([versionUpdateModel.force isEqualToString:@"1"]) {
        HXBXYAlertViewController *alertVC = [[HXBXYAlertViewController alloc] initWithTitle:@"红小宝发现新版本" Massage:versionUpdateModel.updateinfo force:[versionUpdateModel.force intValue] andLeftButtonMassage:@"暂不更新" andRightButtonMassage:@"立即更新"];

        [alertVC setClickXYRightButtonBlock:^{
            NSURL *url = [NSURL URLWithString:versionUpdateModel.url];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [self promptPriorityWithAlertVC:alertVC];
        
    } else if ([versionUpdateModel.force isEqualToString:@"2"] ) {
        HXBXYAlertViewController *alertVC = [[HXBXYAlertViewController alloc] initWithTitle:@"红小宝发现新版本" Massage:versionUpdateModel.updateinfo force:[versionUpdateModel.force intValue] andLeftButtonMassage:@"暂不更新" andRightButtonMassage:@"立即更新"];

        [alertVC setClickXYRightButtonBlock:^{
            NSURL *url = [NSURL URLWithString:versionUpdateModel.url];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertVC setClickXYLeftButtonBlock:^{
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [self promptPriorityWithAlertVC:alertVC];
    } else {
    }
}

//提示框的优先级
+ (void)promptPriorityWithAlertVC:(UIViewController *)alertVC {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
