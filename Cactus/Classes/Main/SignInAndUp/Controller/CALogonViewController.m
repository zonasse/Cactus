//
//  CALoginViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CALogonViewController.h"
#import "CAHomePageViewController.h"
#import "UIResponder+CAFirstResponder.h"
@interface CALogonViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *backgroundScrollView;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPasswordTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *collegeTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *mobileTextField;
@property (strong, nonatomic) UIButton *logonButton;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation CALogonViewController
const CGFloat INTERVAL_KEYBOARD = 50;
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupSubView];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark --点击返回按钮
- (void)cancelLogon{
    /*
     * 若任何一个文本框有内容，则弹出提示
     */
    if(self.accountTextField.text.length || self.passwordTextField.text.length){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"放弃修改吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
#pragma mark --点击注册按钮
- (void)logon{
    /*
     * 1.检查各输入框合法性
     */
    if(self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0){
        [MBProgressHUD showError:@"标号*选项不能为空"];
        return;
    }
    
    /*
     * 2.检查网络状态
     */
    
    /*
     * 3.向服务器发送注册请求
     */
    __block NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"username":self.accountTextField.text,@"password":self.passwordTextField.text};
    [manager POST:[baseURL stringByAppendingString:@"/user/logout"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        /*
         * 5.判断服务器返回字段
         */
        if(responseDict[@"token"]){
            [NSUserDefaults setValue:responseObject[@"token"] forKey:@"userToken"];
            [MBProgressHUD showSuccess:@"注册成功"];
            CAHomePageViewController *homePageVC = [[CAHomePageViewController alloc] init];
            //设置课程主页用户
            homePageVC.teacher = [[CATeacher alloc] initWithDict:@{}];
            UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
            [self presentViewController:homePageNav animated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD showError:@"注册失败，请重新检查"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"未知错误"];
    }];
    /*
     * 4.判断服务器返回字段进行相应处理,若注册成功则直接登录，跳过登录界面，进入主界面
     */
}

#pragma mark --设置子控件
- (void)setupSubView{
    //设置位置
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard)];
    tapGeature.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [_backgroundScrollView addGestureRecognizer:tapGeature];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 100, 50)];
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _backButton.getMaxY+20, SCREEN_WIDTH-2*leftEdge, 44)];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _accountTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _passwordTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _confirmPasswordTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.collegeTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _nameTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _collegeTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, _emailTextField.getMaxY+20, _accountTextField.width, _accountTextField.height)];
    self.logonButton = [[UIButton alloc] initWithFrame:CGRectMake(leftEdge, _mobileTextField.getMaxY+20, _mobileTextField.width, 50)];
    
    [self.view addSubview:_backgroundScrollView];
    [self.backgroundScrollView addSubview:_backButton];
    [self.backgroundScrollView addSubview:_accountTextField];
    [self.backgroundScrollView addSubview:_passwordTextField];
    [self.backgroundScrollView addSubview:_confirmPasswordTextField];
    [self.backgroundScrollView addSubview:_nameTextField];
    [self.backgroundScrollView addSubview:_collegeTextField];
    [self.backgroundScrollView addSubview:_emailTextField];
    [self.backgroundScrollView addSubview:_mobileTextField];
    [self.backgroundScrollView addSubview:_logonButton];
    //设置内容
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    [self.backButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec91", 34, [UIColor grayColor])] forState:UIControlStateNormal];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(cancelLogon) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.accountTextField.placeholder = @"学工号*";
    
    self.passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.passwordTextField.placeholder = @"密码*";
    
    self.confirmPasswordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.confirmPasswordTextField.placeholder = @"确认密码*";
    
    self.nameTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.nameTextField.placeholder = @"姓名*";
    
    self.collegeTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.collegeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.collegeTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.collegeTextField.placeholder = @"学院*";
    
    self.emailTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.emailTextField.placeholder = @"邮箱";
    
    self.mobileTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor orangeColor])]];
    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    self.mobileTextField.background = [UIImage imageNamed:@"hotweibo_edit_button_background_default.png"];
    self.mobileTextField.placeholder = @"手机号";
    
    [self.logonButton setBackgroundImage:[UIImage imageNamed:@"reward_button"] forState:UIControlStateNormal];
    [self.logonButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.logonButton addTarget:self action:@selector(logon) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark --设置点击或滑动背景退出键盘
- (void)exitKeyboard{
    [self.view endEditing:YES];
}
#pragma mark --scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self exitKeyboard];
}

#pragma mark --弹出键盘视图上移
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
