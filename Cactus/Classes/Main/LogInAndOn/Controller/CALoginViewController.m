//
//  CALoginViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CALoginViewController.h"
#import "CALogonViewController.h"
#import "CAHomePageViewController.h"
#import "CATeacherModel.h"
#import "CACollegeModel.h"
#import "CAClassModel.h"
#import "CAMD5Tool.h"

#import "Masonry.h"
@interface CALoginViewController ()
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *AvatarView;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
//@property (strong, nonatomic) UIButton *logonButton;
@property (strong, nonatomic) UIButton *findPasswordButton;

@end

@implementation CALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控件
    [self setupSubView];
    
    
    /*
     * 2.检查本地缓存是否有账号记录，若有，则直接填充账号输入框
     */
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ------ 设置子控件
- (void)setupSubView{
    //1.Masonry布局，设置子控件位置
    self.backgroundImageView = [[UIImageView alloc] init];
    self.AvatarView = [[UIImageView alloc] init];
    self.accountTextField = [[UITextField alloc] init];
    self.passwordTextField = [[UITextField alloc] init];
    self.loginButton = [[UIButton alloc] init];
    self.findPasswordButton = [[UIButton alloc] init];
    
    [self.view addSubview:_backgroundImageView];
    [self.backgroundImageView addSubview:_AvatarView];
    [self.backgroundImageView addSubview:_accountTextField];
    [self.backgroundImageView addSubview:_passwordTextField];
    [self.backgroundImageView addSubview:_loginButton];
    [self.backgroundImageView addSubview:_findPasswordButton];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.AvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundImageView).with.offset(20);
        make.right.mas_equalTo(self.backgroundImageView).with.offset(-20);
        make.top.mas_equalTo(self.backgroundImageView).with.offset(44);
        make.height.mas_equalTo(@100);
    }];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.AvatarView);
        make.right.mas_equalTo(self.AvatarView);
        make.top.mas_equalTo(self.AvatarView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(@50);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.accountTextField.mas_bottom).with.offset(20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).with.offset(30);
    }];
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginButton);
        make.top.mas_equalTo(self.loginButton.mas_bottom).with.offset(20);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(30);
    }];
//
    //2.设置子控件内容
    self.backgroundImageView.image = [UIImage imageNamed:@"background"];
    [self.backgroundImageView setUserInteractionEnabled:YES];

    /*
     * 设置账号密码输入框的左部占位图
     */
    self.accountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.accountTextField.placeholder = @"请输入学工号";
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec0f", 34, [UIColor orangeColor])]];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"reward_button"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.logonButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    //[self.logonButton addTarget:self action:@selector(logon) forControlEvents:UIControlEventTouchUpInside];
    
    [self.findPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.findPasswordButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark ------ 点击动作
#pragma mark - 登录
- (void)login{
    
    /*
     * 1.检查账号密码格式的合法性
     */
    if(self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0){
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    if (self.accountTextField.text.length < 4) {
        [MBProgressHUD showError:@"账号长度需要8位以上"];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [MBProgressHUD showError:@"密码长度需要6位以上"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中..."];
    
    NSString *urlString = [kBASE_URL stringByAppendingString:@"user/login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tid"] = self.accountTextField.text;
#warning 此处做密码加密
    params[@"password"] = self.passwordTextField.text;

//    params[@"password"] = [CAMD5Tool md5:self.passwordTextField.text];
    /*
     * 2.发送请求
     */
    [ShareDefaultHttpTool POSTWithCompleteURL:urlString parameters:params progress:^(id progress) {
        
    } success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSString *code = responseObject[@"code"];
        if(![code isEqualToString:@"1014"]){
            [MBProgressHUD showError:@"用户名或密码错误"];
            return;
        }
        NSDictionary *subjects = responseDict[@"subjects"];
        /*
         * 跳转
         */
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:subjects[@"token"] forKey:@"userToken"];
        [userDefaults setValue:subjects[@"id"] forKey:@"userId"];
        CAHomePageViewController *homePageVC = [[CAHomePageViewController alloc] init];

        UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
        [self presentViewController:homePageNav animated:YES completion:^{

        }];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}





    

#pragma mark - 注册
//- (void)logon{
//    /*
//     * 进入注册界面并清除登录界面文本框内容
//     */
//    CALogonViewController *logonVC = [[CALogonViewController alloc] init];
//    logonVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:logonVC animated:YES completion:^{
//
//    }];
//
//}

#pragma mark - 找回密码
- (void)findPassword{
    
}

#pragma mark --设置点击或滑动背景退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
