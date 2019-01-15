//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by  zonasse on 2018/9/22.
//  Copyright © 2018年  zonasse. All rights reserved.
//  

#import "QLHomePageViewController.h"
#import "QLTabBarViewController.h"
#import "QLHomePageProfileCell.h"

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
   
}

- (void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark - getters and setters
#pragma mark - private

#pragma mark - notification methods



@end
