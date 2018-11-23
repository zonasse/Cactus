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

@interface CALoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIImageView *backgroundImageView;
//@property (strong, nonatomic) UIImageView *AvatarView;
@property (strong, nonatomic) UITextField *accountTextField;
///分割线
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIView *lineView2;

@property (strong, nonatomic) UIButton *loginButton;
//@property (strong, nonatomic) UIButton *logonButton;
//@property (strong, nonatomic) UIButton *findPasswordButton;

@end

@implementation CALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控件
    [self setupSubView];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    /*
     * 2.检查本地缓存是否有账号记录，若有，则直接填充账号输入框
     */
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ------ 设置子控件
- (void)setupSubView{
    //1.Masonry布局，设置子控件位置
    self.backgroundImageView = [[UIImageView alloc] init];
//    self.AvatarView = [[UIImageView alloc] init];
    self.accountTextField = [[UITextField alloc] init];
    self.lineView1 = [[UIView alloc] init];
    self.passwordTextField = [[UITextField alloc] init];
    self.lineView2 = [[UIView alloc] init];
    self.loginButton = [[UIButton alloc] init];
//    self.findPasswordButton = [[UIButton alloc] init];
    
    [self.view addSubview:_backgroundImageView];
//    [self.backgroundImageView addSubview:_AvatarView];
    [self.backgroundImageView addSubview:_accountTextField];
    [self.backgroundImageView addSubview:_lineView1];
    [self.backgroundImageView addSubview:_passwordTextField];
    [self.backgroundImageView addSubview:_lineView2];
    [self.backgroundImageView addSubview:_loginButton];
//    [self.backgroundImageView addSubview:_findPasswordButton];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
    if (![NSString checkValidWithNormalString: self.accountTextField.text]) {
        [MBProgressHUD showError:@"账号不符合规则"];
        return;
    }
    if (![NSString checkValidWithNormalString: self.passwordTextField.text]) {
        [MBProgressHUD showError:@"密码不符合规则"];
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
        if(![code isEqualToString:@"2000"]){
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




#pragma mark --弹出键盘视图上移
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    const CGFloat INTERVAL_KEYBOARD = 60;

    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIView * firstResponder = [UIResponder currentFirstResponder];
    UITextField *textField = (UITextField*)firstResponder;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (textField.frame.origin.y+textField.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset-20, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
//- (void)findPassword{
//
//}

#pragma mark --设置点击或滑动背景退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
