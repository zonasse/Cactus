//
//  CALoginViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "QLLoginViewController.h"
#import "QLLogonViewController.h"
#import "QLHomePageViewController.h"
#import "QLTeacherModel.h"
#import "QLCollegeModel.h"
#import "QLClassModel.h"
#import "QLMD5Tool.h"

#import "QLLoginViewModel.h"
@interface QLLoginViewController ()
//@property (strong, nonatomic) UIButton *logonButton;
//@property (strong, nonatomic) UIButton *findPasswordButton;
@property (nonatomic,strong) QLLoginViewModel *loginViewModel;
@end

@implementation QLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控件
    self.loginViewModel = [[QLLoginViewModel alloc] initWithController:self];
    
    
    
    /*
     * 2.检查本地缓存是否有账号记录，若有，则直接填充账号输入框
     */
    
}
#pragma mark ------ 点击动作



    

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
