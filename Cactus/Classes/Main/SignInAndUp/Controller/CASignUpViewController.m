//
//  CASignUpViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CASignUpViewController.h"
#import "CAHomePageViewController.h"

@interface CASignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;//返回按钮
#pragma mark --添加用户名、密码等文本输入框

@end

@implementation CASignUpViewController
#pragma mark --点击返回按钮
- (IBAction)close:(id)sender {
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
}
#pragma mark --点击注册按钮
- (IBAction)signUp:(id)sender{
    /*
     * 1.检查各输入框合法性
     */
    if(self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0){
        [MBProgressHUD showMessage:@"账号或密码不能为空"];
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
- (void)viewDidLoad
{
    
    [super viewDidLoad];
#pragma mark  --各组件样式处理
    /*
     * 设置返回按钮普通及高亮图片
     */
    [self.backButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec91", 34, [UIColor blackColor])] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec91", 34, [UIColor orangeColor])] forState:UIControlStateHighlighted];

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark --设置点击或滑动背景退出键盘

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
