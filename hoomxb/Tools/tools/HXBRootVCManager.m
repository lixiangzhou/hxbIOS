//
//  HXBRootVCManager.m
//  hoomxb
//
//  Created by lxz on 2017/11/14.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBRootVCManager.h"

#import "AXHNewFeatureController.h"
#import "HXBVersionUpdateRequest.h"
#import "HxbAdvertiseViewController.h"
#import "HXBVersionUpdateModel.h"
#import "HXBGesturePasswordViewController.h"

#define AXHVersionKey @"version"

@interface HXBRootVCManager ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation HXBRootVCManager

+ (instancetype)manager {
    static HXBRootVCManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HXBRootVCManager new];
    });
    return manager;
}

/// 创建根控制器
- (void)createRootVCAndMakeKeyWindow {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].delegate.window = self.window;
    
    [self checkVersionUpdate];
    
    // 广告
    kWeakSelf
    HxbAdvertiseViewController *advertiseViewControllre = [[HxbAdvertiseViewController alloc]init];
    self.window.rootViewController = advertiseViewControllre;
    
    advertiseViewControllre.dismissBlock = ^() {
        [weakSelf chooseRootViewController];
    };
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

/// 选择一个根控制器
- (void)chooseRootViewController
{
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:AXHVersionKey];
    //版本检测
    if ([currentVersion isEqualToString:lastVersion]) { // 没有最新的版本号
        [self enterTheGesturePasswordVCOrTabBar];
    } else { // 有新版本
        AXHNewFeatureController *VC = [[AXHNewFeatureController alloc] init];
        VC.force = self.versionUpdateModel.force;
        self.window.rootViewController = VC;
        
        //保存当前版本，用偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:AXHVersionKey];
    }
}

/**
 判断是否进入手势密码
 */
- (void)enterTheGesturePasswordVCOrTabBar
{
    if (KeyChain.validateGesturePwd) {
        KeyChain.ishaveNet = YES;
        HXBGesturePasswordViewController *gesturePasswordVC = [[HXBGesturePasswordViewController alloc] init];
        gesturePasswordVC.type = GestureViewControllerTypeLogin;
        self.window.rootViewController = gesturePasswordVC;
    } else {
        [self makeTabbarRootVC];
    }
}

- (void)checkVersionUpdate
{
    kWeakSelf
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    HXBVersionUpdateRequest *versionUpdateRequest = [[HXBVersionUpdateRequest alloc] init];
    [versionUpdateRequest versionUpdateRequestWitversionCode:version andSuccessBlock:^(id responseObject) {
        weakSelf.versionUpdateModel = [HXBVersionUpdateModel yy_modelWithDictionary:responseObject[@"data"]];
    } andFailureBlock:^(NSError *error) { 
    }];
}

- (void)makeTabbarRootVC {
    self.window.rootViewController = self.mainTabbarVC;
}

#pragma mark - Lazy
/// 懒加载主界面Tabbar
- (HXBBaseTabBarController *)mainTabbarVC
{
    if (!_mainTabbarVC) {
        _mainTabbarVC = [[HXBBaseTabBarController alloc]init];
        _mainTabbarVC.selectColor = [UIColor redColor];///选中的颜色
        _mainTabbarVC.normalColor = [UIColor grayColor];///平常状态的颜色
        
        NSArray *controllerNameArray = @[
                                         @"HxbHomeViewController",//首页
                                         @"HxbFinanctingViewController",//理财
                                         @"HxbMyViewController"];//我的
        //title 集合
        NSArray *controllerTitleArray = @[@"首页", @"投资", @"我的"];
        NSArray *imageArray = @[@"home_Unselected.svg",@"investment_Unselected.svg",@"my_Unselected.svg"];
        //选中下的图片前缀
        NSArray *commonName = @[@"home_Selected.svg",@"investment_Selected.svg",@"my_Selected.svg"];
        for (UIView *view in self.mainTabbarVC.tabBar.subviews) {
            NSLog(@"view = %@", view);
            if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
                UIImageView *ima = (UIImageView *)view;
                ima.height = 0.000001;
                ima.hidden = YES;
            }
        }
        
        [_mainTabbarVC subViewControllerNames:controllerNameArray andNavigationControllerTitleArray:controllerTitleArray andImageNameArray:imageArray andSelectImageCommonName:commonName];
    }
    return _mainTabbarVC ;
}

@end
