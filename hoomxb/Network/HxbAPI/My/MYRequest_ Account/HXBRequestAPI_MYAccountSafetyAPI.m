//
//  HXBRequestAPI_MYAccount.m
//  hoomxb
//
//  Created by HXB on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBRequestAPI_MYAccountSafetyAPI.h"

@implementation HXBRequestAPI_MYAccountSafetyAPI

- (NSString *)requestUrl {
    return @"/account/userplanAssets.action";
}

- (NYRequestMethod)requestMethod {
    return NYRequestMethodPost;
}

@end