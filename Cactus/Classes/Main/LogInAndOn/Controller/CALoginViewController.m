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
#import "CATeacher.h"
#import "CACollege.h"
#import "CAClass.h"
#import "CAMD5Tool.h"
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
    //1.设置子控件位置
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.AvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(leftEdge, 44, SCREEN_WIDTH-2*leftEdge, 100)];
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, self.AvatarView.getMaxY + 20, self.AvatarView.width, 50)];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _accountTextField.getMaxY + 20, _accountTextField.width, _accountTextField.height)];
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(leftEdge, _passwordTextField.getMaxY + 30, _passwordTextField.width , 50)];
    self.findPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(leftEdge, _loginButton.getMaxY+20, 100, 30)];
    //self.logonButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-rightEdge-_findPasswordButton.width, _findPasswordButton.y, _findPasswordButton.width, _findPasswordButton.height)];
    [self.backgroundImageView addSubview:_AvatarView];
    [self.backgroundImageView addSubview:_accountTextField];
    [self.backgroundImageView addSubview:_passwordTextField];
    [self.backgroundImageView addSubview:_loginButton];
    //[self.backgroundImageView addSubview:_logonButton];
    [self.backgroundImageView addSubview:_findPasswordButton];
    [self.view addSubview:_backgroundImageView];
    
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
    //[MBProgressHUD showMessage:@"登录中..."];
    /*
     * 2.检查网络状态
     */
    
    /*
     * 3.显示加载过渡动画
     */
    
    /*
     * 4.连接服务器，附送账号和密码加密文段
     */
    __block NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tid"] = self.accountTextField.text;
    dict[@"password"] = [CAMD5Tool md5:self.passwordTextField.text];

//    NSDictionary *params = @{@"tid":self.accountTextField.text,@"password":[CAMD5Tool md5:self.passwordTextField.text]};
//    NSDictionary *params = @{@"tid":self.accountTextField.text,@"password":self.passwordTextField.text};

    NSString *urlString = [baseURL stringByAppendingString:@"university/format"];
#pragma mark ---GET
//    [manager GET:urlString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
#pragma mark --POST
//    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
#pragma mark --PUT
//    [manager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
#pragma mark --DELETE
    [manager DELETE:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
//         * 5.判断服务器返回字段
//         */
//
//        [MBProgressHUD hideHUD];
//        if(responseDict[@"token"]){
//            [NSUserDefaults setValue:responseObject[@"token"] forKey:@"userToken"];
//            [MBProgressHUD hideHUD];
//            CAHomePageViewController *homePageVC = [[CAHomePageViewController alloc] init];
//            //设置课程主页用户
//            CACollege *college = [[CACollege alloc] init];
//            college.name = @"外国语";
//            CATeacher *teacher = [[CATeacher alloc] init];
//            teacher.t_id = @"1928374";
//            teacher.name = @"方世玉";
//            teacher.college = college;
//            teacher.is_manager = TRUE;
//
//            homePageVC.teacher = teacher;
//            UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
//            [self presentViewController:homePageNav animated:YES completion:^{
//
//            }];
//        }else{
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"登录失败，请重新检查"];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"未知错误"];
//    }];
//
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
