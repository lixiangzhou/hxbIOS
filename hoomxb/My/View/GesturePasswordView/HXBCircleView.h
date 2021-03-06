//
//  HXBCircleView.h
//  hoomxb
//
//  Created by HXB-C on 2017/6/20.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  手势密码界面用途类型
 */
typedef enum{
    CircleViewTypeSetting = 1, // 设置手势密码
    CircleViewTypeLogin,       // 登陆手势密码
    CircleViewTypeVerify       // 验证旧手势密码
    
}CircleViewType;
@class HXBCircleView;

@protocol HXBCircleViewDelegate <NSObject>

@optional

#pragma mark - 设置手势密码代理方法
/**
 *  连线个数少于4个时，通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 手势结果
 */
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture;

/**
 *  连线个数多于或等于4个，获取到第一个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第一个次保存的密码
 */
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture;

/**
 *  获取到第二个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第二次手势密码
 *  @param equal   第二次和第一次获得的手势密码匹配结果
 */
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal;

#pragma mark - 登录手势密码代理方法
/**
 *  登陆或者验证手势密码输入完成时的代理方法
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 登陆时的手势密码
 */
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal;

@end

@interface HXBCircleView : UIView
/**
 *  是否剪裁 default is YES
 */
@property (nonatomic, assign) BOOL clip;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

/**
 *  是否显示手势轨迹 default is YES
 */
@property (nonatomic, assign) BOOL isDisplayTrajectory;

/**
 *  解锁类型
 */
@property (nonatomic, assign) CircleViewType type;


// 代理
@property (nonatomic, weak) id<HXBCircleViewDelegate> delegate;

// 初始化方法（设置view的相关类型、参数）
- (instancetype)initWithType:(CircleViewType)type clip:(BOOL)clip arrow:(BOOL)arrow;
/**
 重置手势密码
 */
- (void)resetGesturePassword;

@end
