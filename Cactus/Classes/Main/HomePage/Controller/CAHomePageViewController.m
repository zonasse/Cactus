//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAHomePageViewController.h"
#import "CAClassManagementViewController.h"
#import "CAClassInfoModel.h"
#import "CAHomePageView.h"
@interface CAHomePageViewController ()
///主页视图
@property (nonatomic,strong) CAHomePageView *homePageView;
///教师数据字典
@property (nonatomic,strong) NSDictionary *teacherProfileData;
///教学班数据数组
@property (nonatomic, strong) NSArray *classInfoData;

@end

@implementation CAHomePageViewController
#pragma mark - life cycle

- (void)viewDidLoad {
   [super viewDidLoad];
   self.title = @"课程主页";
   //1.添加主页视图
   _homePageView = [[CAHomePageView alloc] initWithFrame:CGRectMake(0, kTABBAR_START_Y, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTABBAR_START_Y)];
   _homePageView.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:_homePageView];
   
   //2.添加主页通知
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToClassInfoManagementViewController:) name:@"CAJumpToClassManagementViewControllerNotification" object:nil];
   //3.发送网络请求获取数据
   __unsafe_unretained typeof(self) weakSelf = self;
   
   dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
   
   dispatch_group_t group = dispatch_group_create();
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
   
   //3.1异步获取教师数据
   
   dispatch_group_async(group, queue, ^{
      NSString *urlString = [kBASE_URL stringByAppendingString:@"user/info/format"];
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
   //3.2异步获取教学班数据
   dispatch_group_async(group, queue, ^{
      NSString *urlString = [kBASE_URL stringByAppendingString:@"table/class_info/format"];
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
         
      } failure:^(NSError *error) {
         dispatch_semaphore_signal(semaphore);
         
         [MBProgressHUD showError:@"教学信息获取失败"];
      }];
   });
   //3.3同时获取到时刷新UI
   dispatch_group_notify(group, queue, ^{
//      dispatch_async(queue, ^{
         //两个请求对应两次信号等待
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         dispatch_async(dispatch_get_main_queue(), ^{
            [self.homePageView setTeacherProfileData:self.teacherProfileData];
            [self.homePageView setClassInfoData:self.classInfoData];
         });
         
//      });
      
   });
   
}

- (void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark - getters and setters

#pragma mark - private

#pragma mark - notification methods

/**
 跳转控制器
 */
- (void)jumpToClassInfoManagementViewController:(NSNotification *)notification{
   CAClassManagementViewController *classManagementVC = [[CAClassManagementViewController alloc] init];
   classManagementVC.classInfo = (CAClassInfoModel*)notification.object;
   [self.navigationController pushViewController:classManagementVC animated:YES];
}

@end
