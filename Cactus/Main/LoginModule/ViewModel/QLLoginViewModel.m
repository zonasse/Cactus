//
//  QLLoginViewModel.m
//  Cactus
//
//  Created by  zonasse on 2019/1/14.
//  Copyright © 2019  zonasse. All rights reserved.
//

#import "QLLoginViewModel.h"
#import "QLLoginViewController.h"
#import "QLHomePageViewController.h"
#import "QLLoginView.h"
@interface QLLoginViewModel()<QLLoginViewDelegate,UITextViewDelegate>
@property (nonatomic,weak) QLLoginViewController *loginController;
@end

@implementation QLLoginViewModel

- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.loginController = (QLLoginViewController*)controller;
        
        QLLoginView *loginView = [[QLLoginView alloc] init];
        loginView.delegate = self;
        [self.loginController.view addSubview:loginView];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *existTid = [userDefaults valueForKey:k_tid_key];
        NSString *existPassword = [userDefaults valueForKey:k_password_key];
        
        if (existTid && existPassword) {
            [loginView setExistTid:existTid password:existPassword];
        }
        
        [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.loginController.view);
        }];
        
        //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)didClickLoginButtonWithTid:(NSString *)tid password:(NSString *)password{
    
    /*
     * 1.检查账号密码格式的合法性
     */
    if(tid.length == 0 || password.length == 0){
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    if (![NSString checkValidWithNormalString: tid]) {
        [MBProgressHUD showError:@"账号不符合规则"];
        return;
    }
    if (![NSString checkValidWithNormalString: password]) {
        [MBProgressHUD showError:@"密码不符合规则"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //password = [QLMD5Tool md5:[password stringByAppendingString:@"fuck"]];

    params[@"tid"] = tid;
    params[@"password"] = password;
    
    /*
     * 2.发送请求
     */
    [ShareDefaultHttpTool POSTWithCompleteURL:kURL_user_login parameters:params progress:^(id progress) {
        
    } success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSString *code = responseObject[@"code"];
        if(![code isEqualToString:k_status_get_succeed]){
            [MBProgressHUD showError:@"用户名或密码错误"];
            return;
        }
        NSDictionary *subjects = responseDict[@"subjects"];
        /*
         * 跳转
         */
        //保存账号密码及相关设置
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:subjects[@"token"] forKey:k_token_key];
        [userDefaults setValue:subjects[@"id"] forKey:k_user_id_key];
        [userDefaults setValue:tid forKey:k_tid_key];
        [userDefaults setValue:password forKey:k_password_key];
        
        QLHomePageViewController *homePageVC = [[QLHomePageViewController alloc] init];
        
        UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
        [self.loginController presentViewController:homePageNav animated:YES completion:^{
            
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
    CGFloat offset = (textField.frame.origin.y+textField.frame.size.height+INTERVAL_KEYBOARD) - (self.loginController.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.loginController.view.frame = CGRectMake(0.0f, -offset-20, self.loginController.view.frame.size.width, self.loginController.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.loginController.view.frame = CGRectMake(0, 0, self.loginController.view.frame.size.width, self.loginController.view.frame.size.height);
    }];
}


@end
