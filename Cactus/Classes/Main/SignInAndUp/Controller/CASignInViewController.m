//
//  CASignInViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CASignInViewController.h"
#import "CASignUpViewController.h"
#import "CAHomePageViewController.h"
#import "CATeacher.h"
@interface CASignInViewController ()
@property (weak, nonatomic) IBOutlet UIView *AvatarView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CASignInViewController
#pragma mark -- 点击注册按钮
- (IBAction)SignUp:(id)sender {
    /*
     * 进入注册界面并清除登录界面文本框内容
     */
    [self presentViewController:[[CASignUpViewController alloc] init] animated:YES completion:^{
        
    }];

}
#pragma mark --点击登录按钮
- (IBAction)signIn:(id)sender {
    
    /*
     * 1.检查账号密码格式的合法性
     */
    if(self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0){
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    /*
     * 2.检查网络状态
     */
    
    /*
     * 3.显示加载过渡动画
     */
    [MBProgressHUD showMessage:@"登录中..."];
    /*
     * 4.连接服务器，附送账号和密码加密文段
     */
    __block NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"username":self.accountTextField.text,@"password":self.passwordTextField.text};
    [manager POST:[baseURL stringByAppendingString:@"/user/login"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        /*
         * 5.判断服务器返回字段
         */
        if(responseDict[@"token"]){
            [NSUserDefaults setValue:responseObject[@"token"] forKey:@"userToken"];
            [MBProgressHUD showSuccess:@"登录成功"];
            CAHomePageViewController *homePageVC = [[CAHomePageViewController alloc] init];
            //设置课程主页用户
            homePageVC.teacher = [[CATeacher alloc] initWithDict:@{}];
            UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
            [self presentViewController:homePageNav animated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD showError:@"登录失败，请重新检查"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"未知错误"];
    }];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
