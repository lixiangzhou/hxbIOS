//
//  HXBVerificationCodeAlertView.m
//  hoomxb
//
//  Created by HXB-C on 2017/7/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBVerificationCodeAlertView.h"

@interface HXBVerificationCodeAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *speechVerificationCodeLab;
@property (nonatomic, strong) UIButton *speechVerificationCodeBtn;

@property (nonatomic, assign) int count;

@property (nonatomic, strong) NSTimer *timer;
@end


@implementation HXBVerificationCodeAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.codeBtn];
        [self addSubview:self.line];
        [self addSubview:self.speechVerificationCodeLab];
        [self addSubview:self.speechVerificationCodeBtn];
        [self setupSubViewFrame];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self getVerificationCode];
//        [self getSpeechVerificationCode];
//        if (_isSpeechVerificationCode) {
//            [self getSpeechVerificationCode];
//        }
    }
    return self;
}

- (void)setIsCleanSmsCode:(BOOL)isCleanSmsCode {
    _isCleanSmsCode = isCleanSmsCode;
    if (_isCleanSmsCode) {
        _textField.text = @"";
    } else {
        
    }
}
-(void)setIsSpeechVerificationCode:(BOOL)isSpeechVerificationCode{
    _isSpeechVerificationCode = isSpeechVerificationCode;
    self.speechVerificationCodeLab.hidden = !isSpeechVerificationCode;
    self.speechVerificationCodeBtn.hidden = !isSpeechVerificationCode;
    if (_isSpeechVerificationCode) {
        [self.speechVerificationCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(kScrAdaptationH(10));
            make.left.equalTo(self.textField.mas_left);
            make.height.offset(kScrAdaptationH(12.5));
        }];
        [self.speechVerificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(kScrAdaptationH(10.5));
            make.left.equalTo(self.speechVerificationCodeLab.mas_right);
            make.right.equalTo(self.mas_right);
            make.height.offset(kScrAdaptationH(12));
        }];
    }
//    if (isSpeechVerificationCode) {
//        [self getSpeechVerificationCode];
//    }
}
- (void)setupSubViewFrame
{
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.width.offset(kScrAdaptationW750(160));
        make.height.offset(kScrAdaptationH750(60));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeBtn);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.codeBtn.mas_left).offset(kScrAdaptationW750(-50));
        make.height.offset(kScrAdaptationH(32));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_left);
        make.right.equalTo(self.textField.mas_right);
        make.bottom.equalTo(self.codeBtn.mas_bottom);
        make.height.offset(kHXBDivisionLineHeight);
    }];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.line.backgroundColor = lineColor;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    self.textField.delegate = delegate;
}
- (void)getSpeechVerificationCode
{
    self.speechVerificationCodeBtn.enabled = NO;
    [self.speechVerificationCodeBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    self.codeBtn.enabled = NO;
    self.count = 60;
    [self.codeBtn setBackgroundColor:COR12];
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    if (self.getSpeechVerificationCodeBlock) {
        self.getSpeechVerificationCodeBlock();
    }
}
- (void)getVerificationCode
{
    if (self.isSpeechVerificationCode) {
        self.speechVerificationCodeBtn.enabled = NO;
        [self.speechVerificationCodeBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    self.codeBtn.enabled = NO;
    self.count = 60;
    [self.codeBtn setBackgroundColor:COR12];
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    if (self.getVerificationCodeBlock) {
        self.getVerificationCodeBlock();
    }
}

- (void)timeDown
{
    self.count--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    if (self.count <= -1) {
        self.codeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
        self.codeBtn.layer.borderWidth = kXYBorderWidth;
        self.codeBtn.layer.borderColor = COR29.CGColor;
        [self.codeBtn setTitleColor:COR29 forState:(UIControlStateNormal)];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.isSpeechVerificationCode = _isSpeechVerificationCode;
        if (_speechType) {
            self.isSpeechVerificationCode = YES;
        }
        self.speechVerificationCodeBtn.enabled = YES;
        [_speechVerificationCodeBtn setTitleColor:RGB(45, 121, 243) forState:UIControlStateNormal];

    }
}

- (NSString *)verificationCode
{
    return self.textField.text;
}


#pragma mark - 懒加载
-(UILabel *)speechVerificationCodeLab{
    if (!_speechVerificationCodeLab) {
        _speechVerificationCodeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _speechVerificationCodeLab.textAlignment = NSTextAlignmentLeft;
        _speechVerificationCodeLab.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _speechVerificationCodeLab.textColor = RGB(153, 153, 153);
        [_speechVerificationCodeLab sizeToFit];
        _speechVerificationCodeLab.text = @"若没有收到短信，可点此";
    }
    return _speechVerificationCodeLab;
}
- (UIButton *)speechVerificationCodeBtn{
    if (!_speechVerificationCodeBtn) {
        _speechVerificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _speechVerificationCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _speechVerificationCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _speechVerificationCodeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_speechVerificationCodeBtn setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        [_speechVerificationCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_speechVerificationCodeBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR(12)];
        [_speechVerificationCodeBtn addTarget:self action:@selector(getSpeechVerificationCode) forControlEvents:UIControlEventTouchUpInside];//点击 获得语音验证码的事件处理
    }
    return _speechVerificationCodeBtn;
}
- (UIButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        _codeBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn setBackgroundColor:RGB(245, 81, 81)];
        _codeBtn.layer.cornerRadius = kScrAdaptationW750(8);
        _codeBtn.layer.masksToBounds = YES;
        
    }
    return _codeBtn;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = kHXBFont_PINGFANGSC_REGULAR_750(32);
        _textField.textColor = RGB(51, 51, 51);
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.placeholder = @"验证码";
    }
    return _textField;
}
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGB(221, 221, 221);
    }
    return _line;
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
