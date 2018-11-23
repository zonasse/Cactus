//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAHomePageViewController.h"
#import "CAClassManagementViewController.h"
#import "CAHomePageView.h"

#import "CATeacherModel.h"
#import "CAUniversityModel.h"
#import "CACollegeModel.h"
#import "CAClassInfoModel.h"

@interface CAHomePageViewController ()
///主页视图
@property (nonatomic,strong) CAHomePageView *homePageView;
///教师模型对象
@property (nonatomic,strong) CATeacherModel *teacher;
///学院模型对象
@property (nonatomic,strong) CACollegeModel *college;
///学校模型对象
@property (nonatomic,strong) CAUniversityModel *university;
///教学班模型对象数组
@property (nonatomic, strong) NSMutableArray *classInfoArray;

@end

@implementation CAHomePageViewController
#pragma mark - life cycle

- (void)viewDidLoad {
   [super viewDidLoad];
   self.title = @"课程主页";
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
   self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   //1.添加主页视图
   _homePageView = [[CAHomePageView alloc] init];
   [self.view addSubview:_homePageView];
   [_homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.and.right.mas_equalTo(self.view);
      make.bottom.mas_equalTo(self.view);
   }];
   _homePageView.backgroundColor = [UIColor whiteColor];
   
   //2.添加主页通知
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToClassInfoManagementViewController:) name:@"CAJumpToClassManagementViewControllerNotification" object:nil];
   //3.发送网络请求获取数据
   __unsafe_unretained typeof(self) weakSelf = self;
   
   dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
   
   dispatch_group_t group = dispatch_group_create();
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
   
   //3.1异步获取教师数据
   [MBProgressHUD showMessage:@"教学信息获取中..."];
   __block BOOL tag = YES;
   dispatch_group_async(group, queue, ^{
      NSString *urlString = [kBASE_URL stringByAppendingString:@"user/info/display"];
      NSMutableDictionary *params = [NSMutableDictionary dictionary];
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *token = [userDefaults valueForKey:@"userToken"];
      NSString *teacherId = [userDefaults valueForKey:@"userId"];
      params[@"token"] = token;
      params[@"id"] = teacherId;
      [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
         
      } success:^(id responseObject) {
         NSDictionary *responseDict = responseObject;
         if ([responseDict[@"code"] isEqualToString:@"1041"]) {
            tag = NO;
         }else{
            NSArray *subjects = responseDict[@"subjects"];
            for (NSDictionary *dict in subjects) {
               weakSelf.teacher = [[CATeacherModel alloc] initWithDict:dict];
               [[NSUserDefaults standardUserDefaults] setObject:weakSelf.teacher.name forKey:@"teacher_name"];
               weakSelf.college = [[CACollegeModel alloc] initWithDict:dict[@"college_message"]];
               weakSelf.university = [[CAUniversityModel alloc] initWithDict:dict[@"university_message"]];
            }
         
         }
         dispatch_semaphore_signal(semaphore);
         
      } failure:^(NSError *error) {
         tag = NO;
         dispatch_semaphore_signal(semaphore);
      }];
   });
   //3.2异步获取教学班数据
   dispatch_group_async(group, queue, ^{
      NSString *urlString = [kBASE_URL stringByAppendingString:@"table/class_info/display"];
      NSMutableDictionary *params = [NSMutableDictionary dictionary];
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *token = [userDefaults valueForKey:@"userToken"];
      NSString *teacherId = [userDefaults valueForKey:@"userId"];
      params[@"token"] = token;
      params[@"teacher_id"] = teacherId;
      [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
         
      } success:^(id responseObject) {
         NSDictionary *responseDict = responseObject;
         if ([responseDict[@"code"] isEqualToString:@"1041"]) {
            tag = NO;
         }else{
            
            weakSelf.classInfoArray = responseDict[@"subjects"];

         }
         dispatch_semaphore_signal(semaphore);
         
      } failure:^(NSError *error) {
         tag = NO;
         dispatch_semaphore_signal(semaphore);
         
      }];
   });
   //3.3同时获取到时刷新UI
   dispatch_group_notify(group, queue, ^{
         //两个请求对应两次信号等待
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if (tag == YES) {
               [MBProgressHUD showSuccess:@"教学信息获取成功"];
               [self.homePageView setTeacherName:self.teacher.name tid:self.teacher.tid universityName:self.university.name collegeName:self.college.name];
               

               [self.homePageView setClassInfoArray:self.classInfoArray];
            }else{
               [MBProgressHUD showError:@"教学信息获取失败"];
            }
         });
   });
   
}

- (void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark - getters and setters
- (NSMutableArray *)classInfoArray{
   if (!_classInfoArray) {
      _classInfoArray = [NSMutableArray array];
   }
   return _classInfoArray;
}
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
