//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAHomePageViewController.h"
#import "CAClassManagementViewController.h"
#import "CAClassInfo.h"
#import "CAHomePageView.h"
@interface CAHomePageViewController ()
@property (nonatomic,strong) CAHomePageView *homePageView;
@property (strong, nonatomic) NSDictionary *teacherProfileData;
@property (strong, nonatomic) NSArray *classInfoData;

#pragma mark --添加其他组件
@end

@implementation CAHomePageViewController

#pragma mark --设置headerview，自动刷新或下拉刷新获取数据

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程主页";
    
    _homePageView = [[CAHomePageView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-tabbarVCStartY)];
    _homePageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_homePageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToLessonManagementViewController:) name:@"CAJumpToClassManagementViewControllerNotification" object:nil];
#pragma mark --获取教师以及教学班数据，获取数据量较大
    __unsafe_unretained typeof(self) weakSelf = self;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    /*
     * 异步获取教师与教学班数据
     */
    //同时获取到之后再刷新数据
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [baseURL stringByAppendingString:@"user/info/format"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        NSString *teacherId = [userDefaults valueForKey:@"userId"];
        params[@"token"] = token;
        params[@"id"] = teacherId;
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {

            NSArray *subjects = responseObject[@"subjects"];
            NSLog(@"%@",subjects[0]);
            weakSelf.teacherProfileData = subjects[0];
            dispatch_semaphore_signal(semaphore);

//            [self.homePageView setTeacherProfileData:subjects[0]];
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            [MBProgressHUD showError:@"个人信息获取失败"];
        }];
    });
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [baseURL stringByAppendingString:@"table/class_info/format"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        NSString *teacherId = [userDefaults valueForKey:@"userId"];
        params[@"token"] = token;
        params[@"teacher_id"] = teacherId;
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSLog(@"class_info:%@",responseObject);
            weakSelf.classInfoData = responseObject[@"subjects"];
            dispatch_semaphore_signal(semaphore);

//            [self.homePageView setClassInfoData:responseObject[@"subjects"]];
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);

            [MBProgressHUD showError:@"教学信息获取失败"];
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(queue, ^{
            //两个请求对应两次信号等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.homePageView setTeacherProfileData:self.teacherProfileData];
                [self.homePageView setClassInfoData:self.classInfoData];
            });
    
        });
        

    });
    
}


#pragma mark --跳转控制器
- (void)jumpToLessonManagementViewController:(NSNotification *)notification{
    CAClassManagementViewController *classManagementVC = [[CAClassManagementViewController alloc] init];
    classManagementVC.classInfo = (CAClassInfo*)notification.object;
    [self.navigationController pushViewController:classManagementVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
