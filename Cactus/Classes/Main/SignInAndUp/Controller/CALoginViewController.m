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
@interface CALoginViewController ()
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *AvatarView;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *logonButton;
@property (strong, nonatomic) UIButton *findPasswordButton;

@end

@implementation CALoginViewController
const CGFloat _leftEdge = 20;
const CGFloat _rightEdge = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控件
    [self setupSubView];
    /*
     * 1.设置账号密码输入框的左部占位图
     */
    self.accountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ece1", 34, [UIColor lightGrayColor])]];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec0f", 34, [UIColor lightGrayColor])]];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    /*
     * 2.检查本地缓存是否有账号记录，若有，则直接填充账号输入框
     */
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ------ 设置子控件
- (void)setupSubView{
    //设置子控件位置
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.AvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftEdge, 64, SCREEN_WIDTH-2*_leftEdge, 100)];
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(_leftEdge, self.AvatarView.getMaxY + 20, self.AvatarView.width, 50)];
    
    //设置子控件内容
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
    [MBProgressHUD showMessage:@"登录中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    if(![self.accountTextField.text isEqualToString:@"admin"] || ![self.passwordTextField.text isEqualToString:@"admin"]){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"账号或密码错误"];
        return;
    }
    /*
     * 2.检查网络状态
     */
    
    /*
     * 3.显示加载过渡动画
     */
    /*
     * 4.连接服务器，附送账号和密码加密文段
     */
    //    __block NSError *error;
    //
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSDictionary *params = @{@"username":self.accountTextField.text,@"password":self.passwordTextField.text};
    //    NSString *urlString = [baseURL stringByAppendingString:@"user/login"];
    //
    //    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    //        /*
    //         * 5.判断服务器返回字段
    //         */
    
    //[MBProgressHUD hideHUD];
    //        if(responseDict[@"token"]){
    //            [NSUserDefaults setValue:responseObject[@"token"] forKey:@"userToken"];
    [MBProgressHUD showSuccess:@"登录成功"];
    CAHomePageViewController *homePageVC = [[CAHomePageViewController alloc] init];
    //设置课程主页用户
    CACollege *college = [[CACollege alloc] init];
    college.name = @"外国语";
    CATeacher *teacher = [[CATeacher alloc] init];
    teacher.t_id = @"1928374";
    teacher.name = @"方世玉";
    teacher.college = college;
    teacher.is_manager = TRUE;
    
    homePageVC.teacher = teacher;
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    [self presentViewController:homePageNav animated:YES completion:^{
        
    }];
    //        }else{
    [MBProgressHUD hideHUD];
    //            [MBProgressHUD showError:@"登录失败，请重新检查"];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        [MBProgressHUD hideHUD];
    //        [MBProgressHUD showError:@"未知错误"];
    //    }];
    //
    
}

#pragma mark - 注册
- (void)logon{
    /*
     * 进入注册界面并清除登录界面文本框内容
     */
    [self presentViewController:[[CALogonViewController alloc] init] animated:YES completion:^{
        
    }];
    
}

#pragma mark - 找回密码
- (void)findPassword{
    
}

#pragma mark --设置点击或滑动背景退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponder];
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
