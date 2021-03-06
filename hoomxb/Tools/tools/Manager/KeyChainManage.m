//
//  KeyChainManage.m
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import "KeyChainManage.h"

#import <UICKeyChainStore.h>
#import <Security/Security.h>
#import "HXBRequestUserInfo.h"

#define kGesturePwd self.keychain[kMobile]
#define kSiginPwd @"HXBSinInCount"

static NSString * const kService = @"www.hoomxb.com";
//注册时返回的信息
static NSString * const kToken = @"token";
static NSString * const kPhone = @"phone";
static NSString * const kUserId = @"userId";
static NSString * const kInviteCode = @"inviteCode";

static NSString * const kLoginPwd = @"loginPwd";
static NSString * const kTradePwd = @"tradePwd";
//static NSString * const kGesturePwd = @"gesturePwd";
static NSString * const kGesturePwdCount = @"gesturePwdCount";

static NSString * const kRealName = @"realName";
static NSString * const kRealId = @"realId";
static NSString * const kDefBankNum = @"defBankNum";

static NSString * const kBankNumArr = @"bankNumArr";
static NSString * const kAvatarImageURL = @"avatarImageURL";
static NSString * const kLocalAvatarImageData = @"kLocalAvatarImageData";

//统一密文处理
static NSString * const kCiphertext = @"ciphertext";

///错误
static NSString * const kNo = @"0";
///是否实名认证
static NSString *const kIsAllPassed = @"kIsAllPassed";
///是否绑卡
static NSString *const kIsBindCard = @"kIsBindCard";
///是否有交易密码
static NSString *const kISCashPasswordPassed = @"kISCashPasswordPassed";
///是否实名
static NSString *const kIsIdPassed = @"kIsIdPassed";
///是否 手机号
static NSString *const kIsMobilePassed = @"kIsMobilePassed";
///手机号
static NSString *const kMobile = @"kMobile";
///用户名
static NSString *const kUserName = @"kUserName";
///    double    总资产
static NSString *const kAssetsTotal = @"kAssetsTotal";
///    double    累计收益
static NSString *const kEarnTotal = @"kEarnTotal";
///    double    红利计划-持有资产
static NSString *const kFinancePlanAssets = @"kFinancePlanAssets";
///    double    红利计划-累计收益
static NSString *const kFinancePlanSumPlanInterest = @"kFinancePlanSumPlanInterest";
///    double    散标债权-持有资产
static NSString *const kLenderPrincipal = @"kLenderPrincipal";
///    double    散标债权-累计收益
static NSString *const kLenderEarned = @"kLenderEarned";
///    double    可用余额
static NSString *const kAvailablePoint = @"kAvailablePoint";
///    double    冻结余额
static NSString *const kFrozenPoint = @"kFrozenPoint";
/// 是否登录
static NSString *const kIsLogin = @"kIsLogin";
///isEscrow    int    是否开通存管账户 1：已开通， 0：未开通
static NSString *const kISEscrow = @"kISEscrow";
//H5页面的BaseURL
static NSString *const hostH5 = @"hostH5";

@interface KeyChainManage ()

@property (nonatomic, strong) UICKeyChainStore *keychain;

///    double    总资产
@property (nonatomic,copy) NSString *assetsTotal;
///    double    累计收益
@property (nonatomic,copy) NSString *earnTotal;
///    double    红利计划-持有资产
@property (nonatomic,copy) NSString *financePlanAssets;
///    double    红利计划-累计收益
@property (nonatomic,copy) NSString *financePlanSumPlanInterest;
///    double    散标债权-持有资产
@property (nonatomic,copy) NSString *lenderPrincipal;
///    double    散标债权-累计收益
@property (nonatomic,copy) NSString *lenderEarned;
///    double    可用余额
@property (nonatomic,copy) NSString *availablePoint;
///    double    冻结余额
@property (nonatomic,copy) NSString *frozenPoint;


///    是否安全认证
@property (nonatomic,copy) NSString *isVerify;
///是否绑卡
@property (nonatomic,copy) NSString *isBindCard;
///isCashPasswordPassed
@property (nonatomic,copy) NSString *isCashPasswordPassed;
///isIdPassed    String    是否实名
@property (nonatomic,copy) NSString *isIdPassed;
///是否手机号
@property (nonatomic,copy) NSString *isMobilePassed;

///用户id
@property (nonatomic,copy) NSString *userId;
///username    String    用户名称
@property (nonatomic,copy) NSString *userName;
///真实姓名
@property (nonatomic,copy) NSString *realName;
///idNo
@property (nonatomic,copy) NSString *idNo;
///是否开通存管账户
@property (nonatomic,copy) NSString *isEscrow;

@end

@implementation KeyChainManage
@synthesize mobile = _mobile;

+ (instancetype)sharedInstance
{
    static KeyChainManage *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.keychain = [UICKeyChainStore keyChainStoreWithService:kService];
    });
    
    return sharedInstance;
}

#pragma mark - 常用方法

- (void)setValueWithUserInfoModel: (HXBRequestUserInfoViewModel *)userInfoViewModel {
    
    //是否实名
    _isVerify = userInfoViewModel.userInfoModel.userInfo.isAllPassed;
    _keychain[kIsAllPassed] = _isVerify;
    
    //是否绑卡 已绑卡， 0：未绑卡
    _isBindCard = userInfoViewModel.userInfoModel.userInfo.hasBindCard;
    _keychain[kIsBindCard] = _isBindCard;
    
    //isCashPasswordPassed    String    是否有交易密码
    _isCashPasswordPassed = userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed;
     _keychain[kISCashPasswordPassed] = _isCashPasswordPassed;
    
    ///isIdPassed    String    是否实名
    _isIdPassed = userInfoViewModel.userInfoModel.userInfo.isIdPassed;
    _keychain[kIsIdPassed] = _isIdPassed;
    
    
    ///isMobilePassed    String    是否手机号
    _isMobilePassed = userInfoViewModel.userInfoModel.userInfo.isMobilePassed;
    _keychain[kIsMobilePassed] = _isMobilePassed;
    
    ///isEscrow 是否开通存管
    _isEscrow = userInfoViewModel.userInfoModel.userInfo.isEscrow;
    _keychain[kISEscrow] = _isEscrow;
    
    ///用户手机号
    _mobile = userInfoViewModel.userInfoModel.userInfo.mobile;
    _keychain[kMobile] = _mobile;
    
    
    /// 用户名
    _userName = userInfoViewModel.userInfoModel.userInfo.username;
    _keychain[kUserName] = _userName;
    
    
    ///用户id
    _userId = userInfoViewModel.userInfoModel.userInfo.userId;
    _keychain[kUserId] = _userId;
    
    ///    double    总资产
    _assetsTotal = userInfoViewModel.userInfoModel.userAssets.assetsTotal;
    ///    double    累计收益
    _earnTotal = userInfoViewModel.userInfoModel.userAssets.earnTotal;
    ///    double    红利计划-持有资产
    _financePlanAssets = userInfoViewModel.userInfoModel.userAssets.financePlanAssets;
    ///    double    红利计划-累计收益
    _financePlanSumPlanInterest = userInfoViewModel.userInfoModel.userAssets.financePlanSumPlanInterest;
    ///    double    散标债权-持有资产
    _lenderPrincipal = userInfoViewModel.userInfoModel.userAssets.lenderPrincipal;
    ///    double    散标债权-累计收益
    _lenderEarned = userInfoViewModel.userInfoModel.userAssets.lenderEarned;
    ///    double    可用余额
    _availablePoint = userInfoViewModel.userInfoModel.userAssets.availablePoint;
    ///    double    冻结余额
    _frozenPoint = userInfoViewModel.userInfoModel.userAssets.frozenPoint;
}
///    double    总资产
- (void)assetsTotalWithBlock: (void(^)(NSString *assetsTotal))assetsTotalWithBlock {
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (assetsTotalWithBlock) {
            assetsTotalWithBlock(_assetsTotal);
        }
    } andFailure:^(NSError *error) {
        if (assetsTotalWithBlock) {
            assetsTotalWithBlock(nil);
        }
    }];
}
///    double    累计收益
- (void)earnTotalWithBlock: (void(^)(NSString *earnTotal))earnTotalBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (earnTotalBlock) {
            earnTotalBlock(_earnTotal);
        }
    } andFailure:^(NSError *error) {
        if (earnTotalBlock) {
            earnTotalBlock(nil);
        }
    }];
}
///    double    红利计划-持有资产
- (void)financePlanAssetsWithBlock: (void(^)(NSString *financePlanAssets))financePlanAssetsBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (financePlanAssetsBlock) {
            financePlanAssetsBlock(_financePlanAssets);
        }
    } andFailure:^(NSError *error) {
        if (financePlanAssetsBlock) {
            financePlanAssetsBlock(nil);
        }
    }];
}
///    double    红利计划-累计收益
- (void)financePlanSumPlanInterestWithBlock: (void(^)(NSString *financePlanSumPlanInterest))financePlanSumPlanInterestBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (financePlanSumPlanInterestBlock) {
            financePlanSumPlanInterestBlock(_financePlanSumPlanInterest);
        }
    } andFailure:^(NSError *error) {
        if (financePlanSumPlanInterestBlock) {
            financePlanSumPlanInterestBlock(nil);
        }
    }];
}
///    double    散标债权-持有资产
- (void)lenderPrincipalWithBlock: (void(^)(NSString *lenderPrincipal))lenderPrincipalBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (lenderPrincipalBlock) {
            lenderPrincipalBlock(_lenderPrincipal);
        }
    } andFailure:^(NSError *error) {
        if (lenderPrincipalBlock) {
            lenderPrincipalBlock(nil);
        }
    }];
}
///    double    散标债权-累计收益
- (void)lenderEarnedWithBlock: (void(^)(NSString *lenderEarned))lenderEarnedBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (lenderEarnedBlock) {
            lenderEarnedBlock(_lenderEarned);
        }
    } andFailure:^(NSError *error) {
        if (lenderEarnedBlock) {
            lenderEarnedBlock(nil);
        }
    }];
}
///    double    可用余额
- (void)availablePointWithBlock: (void(^)(NSString *availablePoint))availablePointBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (availablePointBlock) {
            availablePointBlock(_availablePoint);
        }
    } andFailure:^(NSError *error) {
        if (availablePointBlock) {
            availablePointBlock(nil);
        }
    }];
}
///    double    冻结余额
- (void)frozenPointWithBlock: (void(^)(NSString *frozenPoint))frozenPointBlock{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (frozenPointBlock) {
            frozenPointBlock(_frozenPoint);
        }
    } andFailure:^(NSError *error) {
        if (frozenPointBlock) {
            frozenPointBlock(nil);
        }
    }];
}



///userId    int    用户id
- (void)userIdWithBlock: (void(^)(NSString *userID))userIdBlock {
    if (![_keychain[kUserName] length]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (userIdBlock) {
                userIdBlock(_userId);
            }
        } andFailure:^(NSError *error) {
            _userId = @"";
            if (userIdBlock) {
                userIdBlock(_userId);
            }
        }];
        return;
    }
    if (userIdBlock) {
        userIdBlock(_userId);
    }
}

///用户名
- (void)userNameWithBlock: (void(^)(NSString *userName))userNameBlock {
    if (![_keychain[kUserName] length]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (userNameBlock) {
                userNameBlock(_userName);
            }
        } andFailure:^(NSError *error) {
            _userName = @"";
            if (userNameBlock) {
                userNameBlock(_userName);
            }
        }];
        return;
    }
    if (userNameBlock) {
        userNameBlock(_userName);
    }
}

///用户手机号
- (void)mobileWithBlock: (void(^)(NSString *mobile))userMobileBlock{
    if (![_keychain[kMobile] length]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (userMobileBlock) {
                userMobileBlock(_mobile);
            }
        } andFailure:^(NSError *error) {
            _mobile = @"";
            if (userMobileBlock) {
                userMobileBlock(_mobile);
            }
        }];
        return;
    }
    if (userMobileBlock) {
        userMobileBlock(_mobile);
    }
}

///isMobilePassed    String    是否手机号
- (void)isMobilePassedWithBlock: (void(^)(NSString *mobilePassed))mobilePassedBlock {
   if (![_isMobilePassed integerValue]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (mobilePassedBlock) {
                mobilePassedBlock(_isMobilePassed);
            }
        } andFailure:^(NSError *error) {
            _isMobilePassed = kNo;
            if (mobilePassedBlock) {
                mobilePassedBlock(_isMobilePassed);
            }
        }];
       return;
    }
    if (mobilePassedBlock) {
        mobilePassedBlock(_isMobilePassed);
    }
}

///isIdPassed    String    是否实名
- (void)isIdPassedWithBlock: (void(^)(NSString *isIdPassed))isIdPassedBlock {
    if (!_isIdPassed.integerValue) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if(isIdPassedBlock) {
                isIdPassedBlock(_isIdPassed);
            }
        } andFailure:^(NSError *error) {
            _isIdPassed = kNo;
            if(isIdPassedBlock) {
                isIdPassedBlock(_isIdPassed);
            }
        }];
        return;
    }
    if(isIdPassedBlock) {
        isIdPassedBlock(_isIdPassed);
    }
}

///是否有交易密码
- (void)isCashPasswordPassedWithBlock: (void(^)(NSString *isCashPasswordPassed))isCashPasswordPassedBlock {
    if (![_keychain[kISCashPasswordPassed] integerValue]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (isCashPasswordPassedBlock) {
                isCashPasswordPassedBlock(_isCashPasswordPassed);
            }
        } andFailure:^(NSError *error) {
            _isCashPasswordPassed = kNo;
            if (isCashPasswordPassedBlock) {
                isCashPasswordPassedBlock(_isCashPasswordPassed);
            }
        }];
        return;
    }
    if (isCashPasswordPassedBlock) {
        isCashPasswordPassedBlock(_isCashPasswordPassed);
    }
}



/// 用户信息的请求
- (void)downLoadUserInfoWithSeccessBlock:(void(^)(HXBRequestUserInfoViewModel *viewModel))seccessBlock andFailure: (void(^)(NSError *error))failure{
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (seccessBlock) {
            seccessBlock(viewModel);
        }
    } andFailure:^(NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

- (void)downLoadUserInfoNoHUDWithSeccessBlock:(void(^)(HXBRequestUserInfoViewModel *viewModel))seccessBlock andFailure: (void(^)(NSError *error))failure
{
    [HXBRequestUserInfo downLoadUserInfoNoHUDWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        [self setValueWithUserInfoModel:viewModel];
        if (seccessBlock) {
            seccessBlock(viewModel);
        }
    } andFailure:^(NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

///是否绑卡
- (void)isBindCardWithBlock: (void (^)(NSString *isBindCard))isBindCardBlock {
    if (![_keychain[kIsBindCard] integerValue]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            [self setValueWithUserInfoModel:viewModel];
            if (isBindCardBlock) {
                isBindCardBlock(_isBindCard);
            }
        } andFailure:^(NSError *error) {
            _isBindCard = kNo;
            if (isBindCardBlock) {
                isBindCardBlock(_isBindCard);
            }
        }];
        return;
    }
    if (isBindCardBlock) {
        isBindCardBlock(_isBindCard);
    }
}
///    是否安全认证
- (void) isVerifyWithBlock: (void(^)(NSString *isVerify))isVerifyBlock {
    if (![KeyChain isLogin]) {
        return;
    }
    if (![self.isVerify length]) {
        [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
            _isVerify = viewModel.userInfoModel.userInfo.isAllPassed;
            [_keychain setObject:_isVerify forKeyedSubscript:kIsAllPassed];
            if (isVerifyBlock) {
                isVerifyBlock(_isVerify);
            }
        } andFailure:^(NSError *error) {
            if (isVerifyBlock) {
                isVerifyBlock(_isVerify);
            }
        }];
        return;
    }
    if (isVerifyBlock) {
        isVerifyBlock(_isVerify);
    }
}
//!<手势密码是否开启
- (BOOL)isSwitchOn
{
    BOOL isSwitchOn = (![[KeyChain gesturePwd] isEqualToString:@""] && [KeyChain isLogin]);
    
    return isSwitchOn;
}

- (BOOL)hasBindBankcard
{
    NSArray *bankArr = [KeyChain bankNumArr];
    
    BOOL hasBankcard = (bankArr != nil && ![bankArr  isEqual: @[]]);
    
    return hasBankcard;
}

- (BOOL)isInvest{
    BOOL isInvest = ![[KeyChain assetsTotal] isEqualToString:@""] && [KeyChain isLogin];
    return isInvest;
}

- (BOOL)removeAllInfo
{
    KeyChainManage *manager = KeyChain;
    BOOL rmSuccess = [manager.keychain removeAllItems];
    
    return rmSuccess;
}

- (void)signOut
{
    KeyChainManage *manager = KeyChain;
    self.isLogin = false;
    [HXBRequestUserInfo signOut];
    [manager.keychain removeItemForKey:kLoginPwd];
    [manager.keychain removeItemForKey:kTradePwd];
    [manager.keychain removeItemForKey:kToken];
    [manager.keychain removeItemForKey:kCiphertext];
}

- (void)removePassword
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kLoginPwd];
    [manager.keychain removeItemForKey:kTradePwd];
    [self removeGesture];
}

- (void)removeGesture
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kGesturePwd];
    [manager.keychain removeItemForKey:kGesturePwdCount];
}

- (BOOL)validateGesturePwd {
    return (KeyChain.gesturePwd.length >= 4) && [KeyChain isLogin] && [kUserDefaults boolForKey:kHXBGesturePWD];
}

- (void)removeGesturePwdCount
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kGesturePwdCount];
}

- (void)removeToken
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kToken];
}
- (void)removeMobile
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kMobile];
}

- (void)removeCiphertext
{
    KeyChainManage *manager = KeyChain;
    [manager.keychain removeItemForKey:kCiphertext];
}

#pragma mark - KVC
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    DLog(@"undefine key ---%@",key);
}

#pragma mark - getter/setter
-(BOOL)isLogin
{
    NSLog(@"token = %@",self.token);
    NSLog(@"phone = %@",self.mobile);
//    BOOL isLogin = self.mobile.length;
    return [self.keychain[kIsLogin] integerValue];
}

- (void)setIsLogin:(BOOL)isLogin {
    self.keychain[kIsLogin] = @(isLogin).description;
    NSLog(@"description = %@",  @(isLogin).description);
}

- (void)isLoginWithInRealTimeBlock: (void (^)(BOOL isLogin))isLoginInRealTimeBlock {
    if (!self.isLogin) {
        isLoginInRealTimeBlock (false);
        return;
    }
    [HXBRequestUserInfo downLoadUserInfoWithSeccessBlock:^(HXBRequestUserInfoViewModel *viewModel) {
        if (isLoginInRealTimeBlock) {
            [self setValueWithUserInfoModel: viewModel];
            isLoginInRealTimeBlock(true);
        }
    } andFailure:^(NSError *error) {
        if (isLoginInRealTimeBlock) {
            isLoginInRealTimeBlock(false);
        }
    }];
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    self.keychain[kMobile] = mobile;
}
- (NSString *)mobile {
    return self.keychain[kMobile];
}
- (void)setToken:(NSString *)token
{
    self.keychain[kToken] = token;
    
    //    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:kService];
    //    keychain[kPhoneNum] = phoneNum;
    //    keychain[kToken] = token;
}
- (NSString *)token
{
    NSString *token = self.keychain[kToken];
    return token?:@"";
}

- (NSString *)h5host
{
    NSString *h5Host = self.keychain[hostH5];
    if (!h5Host.length) {
        h5Host = @"https://m.hoomxb.com";
    }
    return h5Host;
}

- (void)setH5host:(NSString *)h5host
{
    self.keychain[hostH5] = h5host;
}

-(void)setAvatarImageURL:(NSString *)avatarImageURL
{
    self.keychain[kAvatarImageURL] = avatarImageURL;
}

-(NSString *)avatarImageURL
{
    NSString *avatarImageUrl = self.keychain[kAvatarImageURL];
    return avatarImageUrl?:@"";
}

/**
- (void)setPhone:(NSString *)phone
{
    self.keychain[kPhone] = phone;
}
- (NSString *)phone
{
    NSString *phone = self.keychain[kPhone];
    return phone?:@"";
}
*/

/*
- (void)setUserId:(NSString *)userId
{
    self.keychain[kUserId] = userId;
}
- (NSString *)userId
{
    NSString *userId = self.keychain[kUserId];
    return userId?:@"";
}
 **/

- (void)setInviteCode:(NSString *)inviteCode
{
    self.keychain[kInviteCode] = inviteCode;
}
- (NSString *)inviteCode
{
    NSString *inviteCode = self.keychain[kInviteCode];
    return inviteCode?:@"";
}

- (void)setLoginPwd:(NSString *)loginPwd
{
    self.keychain[kLoginPwd] = loginPwd;
}
- (NSString *)loginPwd
{
    NSString *loginPwd = self.keychain[kLoginPwd];
    return loginPwd?:@"";
}

- (NSString *)ciphertext
{
    NSString *ciphertext = self.keychain[kCiphertext];
    return ciphertext?:@"";
}

- (void)setCiphertext:(NSString *)ciphertext
{
    self.keychain[kCiphertext] = ciphertext;
}

- (void)setTradePwd:(NSString *)tradePwd
{
    self.keychain[kTradePwd] = tradePwd;
}
- (NSString *)tradePwd
{
    NSString *tradePwd = self.keychain[kTradePwd];
    return tradePwd?:@"";
}

- (void)setGesturePwd:(NSString *)gesturePwd
{
    self.keychain[kGesturePwd] = gesturePwd;
}

- (void)setGesturePwdCount:(NSString *)gesturePwdCount
{
    self.keychain[kGesturePwdCount] = gesturePwdCount;
}

- (void)setSiginCount:(NSString *)siginCount {
    self.keychain[kSiginPwd] = siginCount;
}
- (NSString *)siginCount {
    return self.keychain[kSiginPwd] ? : @"0";
}

- (NSString *)gesturePwd
{
    NSString *gesturePwd = self.keychain[kGesturePwd];
    return gesturePwd?:@"";
}

- (NSString *)gesturePwdCount
{
    NSString *gesturePwdCount = self.keychain[kGesturePwdCount];
    return gesturePwdCount?:@"";
}

- (void)setRealId:(NSString *)realId
{
    self.keychain[kRealId] = realId;
}
- (NSString *)realId
{
    NSString *realId = self.keychain[kRealId];
    return realId?:@"";
}

- (void)setRealName:(NSString *)realName
{
    self.keychain[kRealName] = realName;
}
- (NSString *)realName
{
    NSString *realName = self.keychain[kRealName];
    return realName?:@"";
}

- (void)setDefBankNum:(NSString *)defBankNum
{
    self.keychain[kDefBankNum] = defBankNum;
}

- (NSString *)defBankNum
{
    NSString *defBankNum = self.keychain[kDefBankNum];
    return defBankNum?:@"";
}
/*
- (NSString *)assetsTotal{
    NSString *assetsTotal = self.keychain[kAssetsTotal];
    return assetsTotal?:@"";
}

- (void)setAssetsTotal:(NSString *)assetsTotal{
    self.keychain[kAssetsTotal] = assetsTotal;
}
**/
// 对象存取时，需要做处理
- (void)setBankNumArr:(NSArray *)bankNumArr
{
    NSData *bankData = [NSKeyedArchiver archivedDataWithRootObject:bankNumArr];
    [self.keychain setData:bankData forKey:kBankNumArr];
}

- (NSArray *)bankNumArr
{
    NSData *bankData = [self.keychain dataForKey:kBankNumArr];
    NSArray *bankArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:bankData];
    
    return bankArr.count?bankArr:[NSArray array];
}

//- (void)setValueWith
@end
