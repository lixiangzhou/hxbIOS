//
//  HXBUmengViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/11/13.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#define kHXBShareViewHeight kScrAdaptationH(213)

#import "HXBUmengViewController.h"
#import "HXBUmengView.h"
#import "HXBUMShareViewModel.h"
#import "HXBUMShareModel.h"
@interface HXBUmengViewController ()
{
    HXBUMShareViewModel *_shareVM;
}

@property (nonatomic, strong) UIView *bottomShareView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) HXBUmengView *umengView;


@end

@implementation HXBUmengViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


#pragma mark - UI

- (void)setUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self.view addSubview:self.bottomShareView];
    [self.bottomShareView addSubview:self.titleLabel];
    [self.bottomShareView addSubview:self.cancelBtn];
    [self.bottomShareView addSubview:self.umengView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomShareView);
        make.top.equalTo(self.bottomShareView).offset(kScrAdaptationH(25));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bottomShareView);
        make.height.offset(kScrAdaptationH(49));
    }];
    [self.umengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomShareView).offset(kScrAdaptationW(20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(25));
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
    
}

#pragma mark - Network
- (void)loadShareData {
    kWeakSelf
    [self.shareVM UMShareRequestSuccessBlock:^(HXBUMShareViewModel *shareViewModel) {
        weakSelf.shareVM = shareViewModel;
    } andFailureBlock:^(NSError *error) {
        
    }];
}


#pragma mark - Action

- (void)cancelShare {
    [self cancelShareView];
}


- (void)cancelShareView {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomShareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)showShareView {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomShareView.y = kScreenHeight - kHXBShareViewHeight;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelShareView];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    [self cancelShareView];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
   
    //创建网页内容对象
    NSString* thumbURL = self.shareVM.shareModel.image;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareVM.shareModel.title descr:self.shareVM.shareModel.desc thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [self.shareVM getShareLink:platformType];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [self.shareVM sharFailureStringWithCode:error.code];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

#pragma mark - Setter / Getter / Lazy

- (void)setShareVM:(HXBUMShareViewModel *)shareVM{
    _shareVM = shareVM;
    if (!shareVM) {
        [self loadShareData];
    }
}

- (HXBUMShareViewModel *)shareVM {
    if (!_shareVM) {
        _shareVM = [[HXBUMShareViewModel alloc] init];
    }
    return _shareVM;
}

- (UIView *)bottomShareView {
    if (!_bottomShareView) {
        _bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kHXBShareViewHeight)];
        _bottomShareView.backgroundColor = kHXBColor_ShareViewBackGround;
    }
    return _bottomShareView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"分享到";
        _titleLabel.textColor = COR6;
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn setTitleColor:COR6 forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        [_cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (HXBUmengView *)umengView {
    if (!_umengView) {
        _umengView = [[HXBUmengView alloc] init];
        _umengView.backgroundColor = [UIColor clearColor];
        kWeakSelf
        _umengView.shareWebPageToPlatformType = ^(UMSocialPlatformType type) {
            [weakSelf shareWebPageToPlatformType:type];
        };
    }
    return _umengView;
}

#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
