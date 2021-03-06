//
//  HXBRequestAccountInfo.m
//  hoomxb
//
//  Created by hxb on 2017/10/30.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBRequestAccountInfo.h"
#import "HXBBaseRequest.h"
#import "HXBMyCouponListModel.h"

@implementation HXBRequestAccountInfo

+ (void)downLoadMyCouponExchangeInfoHUDWithCode:(NSString *)code withSeccessBlock:(void(^)(HXBMyCouponListModel *Model, NSString *message))seccessBlock andFailure: (void(^)(NSError *error))failureBlock{
    NYBaseRequest *myAccountListInfoAPI = [[NYBaseRequest alloc]init];
    myAccountListInfoAPI.requestUrl = kHXBMY_CouponExchangeInfoURL;
    myAccountListInfoAPI.requestMethod = NYRequestMethodPost;
    myAccountListInfoAPI.requestArgument = @{@"code":code};
    
    [myAccountListInfoAPI startWithHUDStr:@"加载中..." Success:^(NYBaseRequest *request, id responseObject) {
        if ([responseObject[kResponseStatus] integerValue] == 0) {
            HXBMyCouponListModel *accountInfoModel = [[HXBMyCouponListModel alloc]init];
            [accountInfoModel yy_modelSetWithDictionary:responseObject[@"data"][@"coupon"]];
            if (seccessBlock) {
                seccessBlock(accountInfoModel, @"");
            }
        } else {
            if ([responseObject[kResponseStatus] integerValue] == 2 || [responseObject[kResponseStatus] integerValue] == 500) {
                if (seccessBlock) {
                    seccessBlock(nil, responseObject[kResponseMessage]);
                }
            } else {
                kHXBResponsShowHUD
                return;
            }
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        NSLog(@"%@",error);
        if (failureBlock) {
            failureBlock(error);
        }
        kNetWorkError(@"用户请求失败");
    }];
}

+ (NSMutableArray <HXBMyCouponListModel *>*)dataProcessingWitharr:(NSArray *)dataList
{
    NSMutableArray <HXBMyCouponListModel *>*planListViewModelArray = [[NSMutableArray alloc]init];
    
    [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXBMyCouponListModel *financtingPlanListModel = [[HXBMyCouponListModel alloc]init];
        //字典转模型
        [financtingPlanListModel yy_modelSetWithDictionary:obj];
        [planListViewModelArray addObject:financtingPlanListModel];
    }];
    return planListViewModelArray;
}

+ (void)downLoadMyAccountListInfoHUDWithParameterDict:(NSDictionary *)parameterDict withSeccessBlock:(void(^)(NSArray<HXBMyCouponListModel *>* modelArray, NSInteger totalCount))seccessBlock andFailure: (void(^)(NSError *error))failureBlock{
    
    NYBaseRequest *myAccountListInfoAPI = [[NYBaseRequest alloc]init];
    myAccountListInfoAPI.requestUrl = kHXBMY_AccountListInfoURL;
    myAccountListInfoAPI.requestMethod = NYRequestMethodPost;
    myAccountListInfoAPI.requestArgument = parameterDict;
    //@"加载中..."
    [myAccountListInfoAPI startWithHUDStr:nil Success:^(NYBaseRequest *request, id responseObject) {
        if ([responseObject[kResponseStatus] integerValue]) {
            kHXBResponsShowHUD
        }
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSArray <NSDictionary *>*dataList = [data valueForKey:@"dataList"];
        NSMutableArray <HXBMyCouponListModel *>*modelArray = [HXBRequestAccountInfo dataProcessingWitharr:dataList];
        
        if (seccessBlock) {
            seccessBlock(modelArray, [[data valueForKey:@"totalCount"] integerValue]);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        NSLog(@"%@",error);
        if (failureBlock) {
            failureBlock(error);
        }
        kNetWorkError(@"用户请求失败");
    }];
}

+ (void)downLoadAccountInfoNoHUDWithSeccessBlock:(void (^)(HXBMyRequestAccountModel *))seccessBlock andFailure:(void (^)(NSError *))failureBlock{
    
    NYBaseRequest *accountInfoAPI = [[NYBaseRequest alloc]init];
    accountInfoAPI.requestUrl = kHXBUser_AccountInfoURL;
    accountInfoAPI.requestMethod = NYRequestMethodGet;
    [accountInfoAPI startWithSuccess:^(NYBaseRequest *request, id responseObject) {
        if ([responseObject[kResponseStatus] integerValue]) {
            kHXBResponsShowHUD
        }

        HXBMyRequestAccountModel *accountInfoModel = [[HXBMyRequestAccountModel alloc]init];
        [accountInfoModel yy_modelSetWithDictionary:responseObject[@"data"]];
        
        if (seccessBlock) {
            seccessBlock(accountInfoModel);
        }
        
    } failure:^(NYBaseRequest *request, NSError *error) {
        NSLog(@"%@",error);
        if (failureBlock) {
            failureBlock(error);
        }
        kNetWorkError(@"用户请求失败");
    }];
}

@end
