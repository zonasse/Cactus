//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "QLHomePageViewController.h"
#import "QLTabBarViewController.h"
#import "QLHomePageView.h"

#import "QLTeacherModel.h"
#import "QLUniversityModel.h"
#import "QLCollegeModel.h"
#import "QLClassInfoModel.h"
#import "QLHomeViewModel.h"
@interface QLHomePageViewController ()
@property (nonatomic,strong) QLHomeViewModel *homeViewModel;
@end

@implementation QLHomePageViewController
#pragma mark - life cycle

- (void)viewDidLoad {
   [super viewDidLoad];
   self.title = @"课程主页";
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
   self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
   self.homeViewModel = [[QLHomeViewModel alloc] initWithController:self];
   //1.添加主页视图
//   _homePageView = [[QLHomePageView alloc] init];
//   [self.view addSubview:_homePageView];
//   [_homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.top.and.right.mas_equalTo(self.view);
//      make.bottom.mas_equalTo(self.view);
//   }];
//   _homePageView.backgroundColor = [UIColor whiteColor];
//
   //2.添加主页通知
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToClassInfoManagementViewController:) name:@"CAJumpToClassManagementViewControllerNotification" object:nil];
   
}

- (void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark - getters and setters
//- (NSMutableArray *)classInfoArray{
//   if (!_classInfoArray) {
//      _classInfoArray = [NSMutableArray array];
//   }
//   return _classInfoArray;
//}
#pragma mark - private

#pragma mark - notification methods

/**
 跳转控制器
 */
- (void)jumpToClassInfoManagementViewController:(NSNotification *)notification{
   QLTabBarViewController *tabBarVC = [[QLTabBarViewController alloc] init];
   tabBarVC.classInfo = (QLClassInfoModel*)notification.object;
   [self presentViewController:tabBarVC animated:YES completion:^{

   }];
   
//   [self.navigationController pushViewController:classManagementVC animated:YES];
}



@end
