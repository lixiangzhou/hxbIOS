//
//  HXBBasePasswordView.m
//  hoomxb
//
//  Created by HXB on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBasePasswordView.h"
@interface HXBBasePasswordView () <UITextFieldDelegate>
///密码输入框
@property (nonatomic, strong) UITextField *password_TextField;
///输入密码说明
@property (nonatomic, strong) UILabel *password_constLable;
///眼睛按钮
@property (nonatomic, strong) UIButton *eyeButton;
/// 用户输入的密码
@property (nonatomic, strong) NSMutableString *passwordStr;
/// 隐藏的密码的string
@property (nonatomic, strong) NSMutableString *hiddenPasswordStr;
/// 密码是否合格 （字符，数字不能有特殊字符）
@property (nonatomic, assign) BOOL isPasswordQualified;
@property (nonatomic, copy) void(^layoutSubViewBlock)(UILabel *password_constLable,UITextField *password_TextField , UIButton *eyeButton);
@end


@implementation HXBBasePasswordView

- (instancetype)initWithFrame:(CGRect)frame layoutSubView_WithBlock: (void(^)(UILabel *password_constLable,UITextField *password_TextField , UIButton *eyeButton)) layoutSubViewBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
        [self setSubView];
        [self addButtonTarget];
        self.layoutSubViewBlock = layoutSubViewBlock;
        if (self.layoutSubViewBlock) {
            self.layoutSubViewBlock(self.password_constLable, self.password_TextField, self.eyeButton);
        }else {
            [self hxb_layoutSubView];
        }
    }
    return self;
}

- (NSString *)hiddenStr {
    if (!_hiddenStr) {
        _hiddenStr = @"·";
    }
    return _hiddenStr;
}
- (void)setHiddenPasswordImage:(UIImage *)hiddenPasswordImage {
    _hiddenPasswordImage = hiddenPasswordImage;
    _eyeButton.imageView.image = hiddenPasswordImage;
}
- (void)setPasswordTextFiled_Placeholder:(NSString *)passwordTextFiled_Placeholder {
    _passwordTextFiled_Placeholder = passwordTextFiled_Placeholder;
    self.password_TextField.placeholder = passwordTextFiled_Placeholder;
}
- (void)setPasswordConstTitle:(NSString *)passwordConstTitle {
    _passwordConstTitle = passwordConstTitle;
    self.password_constLable.text = passwordConstTitle;
}
///创建对象
- (void)creatSubView {
    self.hiddenPasswordStr = [[NSMutableString alloc]init];
    self.passwordStr = [[NSMutableString alloc]init];

    self.password_TextField = [[UITextField alloc]init];
    self.password_constLable = [[UILabel alloc]init];
    self.eyeButton = [[UIButton alloc]init];

    [self addSubview : self.password_TextField];
    [self addSubview : self.password_constLable];
    [self addSubview : self.eyeButton];
}

///布局
- (void)hxb_layoutSubView {
    kWeakSelf
    [self.password_constLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(kScrAdaptationH(20));
        make.right.equalTo(@(kScrAdaptationW(-20)));
        make.width.equalTo(@(kScrAdaptationW(40)));
    }];
    [self.password_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.password_constLable);
        make.left.equalTo(weakSelf.password_constLable.mas_right);
        make.right.equalTo(weakSelf.eyeButton).offset(kScrAdaptationW(-10));
    }];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.password_constLable);
        make.right.equalTo(weakSelf).offset(kScrAdaptationW(20));
        make.width.height.offset(kScrAdaptationW(10));
    }];
    
    self.password_TextField.backgroundColor = [UIColor hxb_randomColor];
    self.password_constLable.backgroundColor = [UIColor hxb_randomColor];
    self.eyeButton.backgroundColor = [UIColor hxb_randomColor];
}
///设置
- (void)setSubView {
    self.password_TextField.delegate = self;
}


///事件
- (void) addButtonTarget {
    [self.eyeButton addTarget:self action:@selector(clickEyeButton:) forControlEvents:UIControlEventTouchUpInside];
}

///点击了眼睛的按钮
- (void)clickEyeButton: (UIButton *)button {
    self.eyeButton.selected = !self.eyeButton.selected;
    if (self.eyeButton.selected) {
        self.password_TextField.text = self.passwordStr;
    }else {
        self.password_TextField.text = self.hiddenPasswordStr;
    }
}

#pragma mark - textField delegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return false;
    }
    if (![textField isEqual: self.password_TextField]) {
        return true;
    }
    if (!string.length){//删除字符
        NSRange range = NSMakeRange(self.passwordStr.length - 1, 1);
        [self.passwordStr deleteCharactersInRange: range];
        [self.hiddenPasswordStr deleteCharactersInRange:range];
        return true;
    }
    [self.passwordStr appendString:string];
    [self.hiddenPasswordStr appendString:self.hiddenStr];
    
    //显示 字符
    if (self.eyeButton.selected) {
        self.password_TextField.text = self.passwordStr;
    }else {
        self.password_TextField.text = self.hiddenPasswordStr;
    }
    return false;
}
///6-20位数字和字母组成 密码
+ (BOOL)isPasswordQualifiedFunWithStr: (NSString *)password {
    return [self checkPassWordWithString:password];
}
///6-20位数字和字母组成 密码
+ (BOOL)checkPassWordWithString: (NSString *)str
{
    if ([NSString isIncludeSpecialCharact:str]) return NO;
    
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:str]) {
        return YES ;
    }else{
        return NO;
    }
}

///
- (void)layoutSubView_WithBlock: (void(^)(UILabel *password_constLable,UITextField *password_TextField , UIButton *eyeButton)) layoutSubViewBlock{
    self.layoutSubViewBlock = layoutSubViewBlock;
}
@end
