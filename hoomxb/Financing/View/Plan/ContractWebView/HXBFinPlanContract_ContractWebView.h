//
//  HXBFinPlanContract_ContractWebView.h
//  hoomxb
//
//  Created by HXB on 2017/5/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <WebKit/WebKit.h>
@interface HXBFinPlanContract_ContractWebView : WKWebView
- (void)loadURL: (NSString *)URL;
@property (nonatomic,assign) BOOL isHiddenHUD;
//- (void)clickEventWithBlock:(void(^)(HXBFinPlanContract_ContractWebView *webView))clickEventBlock;
@end
