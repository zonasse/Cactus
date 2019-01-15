//
//  QLLoginView.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/14.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLLoginView.h"

@interface QLLoginView()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UITextField *accountTextField;
///分割线
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIView *lineView2;

@property (strong, nonatomic) UIButton *loginButton;


@end

@implementation QLLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
#pragma mark ------ 设置子控件
- (void)setupSubviews{
    //1.Masonry布局，设置子控件位置
    self.backgroundImageView = [[UIImageView alloc] init];
    //    self.AvatarView = [[UIImageView alloc] init];
    self.accountTextField = [[UITextField alloc] init];
    self.lineView1 = [[UIView alloc] init];
    self.passwordTextField = [[UITextField alloc] init];
    self.lineView2 = [[UIView alloc] init];
    self.loginButton = [[UIButton alloc] init];
    //    self.findPasswordButton = [[UIButton alloc] init];
    
    [self addSubview:_backgroundImageView];
    //    [self.backgroundImageView addSubview:_AvatarView];
    [self.backgroundImageView addSubview:_accountTextField];
    [self.backgroundImageView addSubview:_lineView1];
    [self.backgroundImageView addSubview:_passwordTextField];
    [self.backgroundImageView addSubview:_lineView2];
    [self.backgroundImageView addSubview:_loginButton];
    //    [self.backgroundImageView addSubview:_findPasswordButton];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //    [self.AvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.backgroundImageView).with.offset(20);
    //        make.right.mas_equalTo(self.backgroundImageView).with.offset(-20);
    //        make.top.mas_equalTo(self.backgroundImageView).with.offset(44);
    //        make.height.mas_equalTo(@100);
    //    }];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundImageView).with.offset(40);
        make.right.mas_equalTo(self.backgroundImageView).with.offset(-40);
        make.top.mas_equalTo(self.backgroundImageView.mas_centerY);
        make.height.mas_equalTo(@44);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.accountTextField.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.lineView1);
        make.height.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.lineView1.mas_bottom).with.offset(10);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.lineView2.mas_bottom).with.offset(30);
    }];
    //    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.loginButton);
    //        make.top.mas_equalTo(self.loginButton.mas_bottom).with.offset(20);
    //        make.width.mas_equalTo(@100);
    //        make.height.mas_equalTo(30);
    //    }];
    //
    //2.设置子控件内容
    //    self.backgroundImageView.image = [UIImage imageNamed:@"background"];
    [self.backgroundImageView setUserInteractionEnabled:YES];
    
    //    self.AvatarView.image = [UIImage imageNamed:@"bupt"];
    /*
     * 设置账号密码输入框的左部占位图
     */
    
    
    self.accountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 30, kDefaultGreenColor)]];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.background = [UIImage imageNamed:@"login_input_bg"];
    self.accountTextField.placeholder = @"请输入学工号";
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.lineView1.backgroundColor = kDefaultGreenColor;
    self.lineView2.backgroundColor = kDefaultGreenColor;
    
    self.passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec0f", 30, kDefaultGreenColor)]];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.background = [UIImage imageNamed:@"login_input_bg"];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_enable_bg"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_unable_bg"] forState:UIControlStateHighlighted];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.logonButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    //[self.logonButton addTarget:self action:@selector(logon) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self.findPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    //    [self.findPasswordButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 登录
- (void)login{
    if ([self.delegate respondsToSelector:@selector(didClickLoginButtonWithTid:password:)]) {
        [self.delegate didClickLoginButtonWithTid:self.accountTextField.text password:self.passwordTextField.text];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}
@end
