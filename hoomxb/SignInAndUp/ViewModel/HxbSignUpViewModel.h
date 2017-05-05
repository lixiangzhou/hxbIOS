//
//  HxbSignUpViewModel.h
//  hoomxb
//
//  Created by HXB-C on 2017/5/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYBaseRequest.h"

@interface HxbSignUpViewModel : NSObject

- (void)signUpRequestSuccessBlock:(void(^)(BOOL signupSuccess,  NSString *message))success FailureBlock:(void(^)(NYBaseRequest *request, NSError *error))failure;

@end