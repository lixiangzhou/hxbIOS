//
//  HXBFinancing_planList.m
//  hoomxb
//
//  Created by HXB on 2017/5/6.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFinancing_planListAPI.h"

@implementation HXBFinancing_planListAPI
//192.168.1.21:8070/financeplan/queryForIndexUplanListNew.action 红利计划列表
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

//- (NSString *)requestUrl {
//    return @"/financeplan/financeplanlist.action";
//}

- (NSString *)requestUrl {
    return @"/plan";
}

- (NYRequestMethod)requestMethod {
    return NYRequestMethodGet;
}

@end
