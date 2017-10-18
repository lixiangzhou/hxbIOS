//
//  HXBMiddlekey.h
//  hoomxb
//
//  Created by HXB-C on 2017/7/24.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBMiddlekey : NSObject

/**
 存管的逻辑
 */
+ (void)depositoryJumpLogicWithNAV:(UINavigationController *)nav;

/**
 充值够没的逻辑
 */
+ (void)rechargePurchaseJumpLogicWithNAV:(UINavigationController *)nav;



/**
 tableView适配iOS11
 */
+ (void)AdaptationiOS11WithTableView:(UITableView *)tableView;

/**
 设置H5显示超过9个文字
 
 @param title 标题
 */
+ (NSString *)H5Title:(NSString *)title;

@end
