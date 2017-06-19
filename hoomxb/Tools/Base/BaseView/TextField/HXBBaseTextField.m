//
//  HXBBaseTextField.m
//  hoomxb
//
//  Created by HXB on 2017/6/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseTextField.h"

@interface HXBBaseTextField ()

@property (nonatomic,assign) CGFloat lienHeight;
@property (nonatomic,assign) CGFloat buttonWidth;
@property (nonatomic,assign) CGFloat space;
@property (nonatomic,assign) BOOL isDrawLine;
@end

@implementation HXBBaseTextField {
    CGFloat _red;
    CGFloat _green;
    CGFloat _blue;
    CGFloat _alpha;
}

- (void)setTextFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate {
    self.textField.delegate = textFieldDelegate;
}
- (instancetype)initWithFrame:(CGRect)frame andBottomLienSpace: (CGFloat)space
          andBottomLienHeight: (CGFloat)lienHeight
              andRightButtonW: (CGFloat) rightButtonWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lienHeight = lienHeight;
        self.space = space;
        self.buttonWidth = rightButtonWidth;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) show {
     [self setUP];
}
- (void) setUP {
    [self creatViews];
    [self layoutViews];
}

- (void)creatViews {
    self.textField = [[UITextField alloc]init];
    self.button = [[UIButton alloc]init];
    self.textField.returnKeyType = UIReturnKeyDone;
}

- (void)layoutViews {
    [self addSubview: self.textField];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(self.lienHeight);
        make.width.equalTo(@(self.buttonWidth));
        make.right.equalTo(self);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.offset(self.lienHeight);
        make.left.equalTo(self);
        make.right.equalTo(self.button.mas_left);
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    

    if (!self.isDrawLine) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, self.space, self.frame.size.height - self.lienHeight);
    CGPathAddLineToPoint(path, nil, self.frame.size.width - self.space, self.frame.size.height - self.lienHeight);
    
    CGContextAddPath(context, path);
    
    CGContextSetLineWidth(context, self.lienHeight);
    
    CGContextSetRGBFillColor(context, _red, _green, _blue, _alpha);
}

- (void) lienColorWithRed:(CGFloat)red andGreen: (CGFloat)green andBlue: (CGFloat)blue andAlpha: (CGFloat)alpha {
    self.isDrawLine = alpha;
    if (!alpha) return;
    _red = red;
    _green = green;
    _blue = blue;
    _alpha = alpha;
    [self setNeedsLayout];
}
@end
