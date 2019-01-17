////
////  CAStudentListViewController.m
////  Cactus
////
////  Created by  zonasse on 2018/9/22.
////  Copyright © 2018年  zonasse. All rights reserved.
////
//
#import "QLStudentListViewController.h"
#import "QLStudentListViewModel.h"
@interface QLStudentListViewController ()
@property (nonatomic,strong) QLStudentListViewModel *studentListViewModel;
/////excel视图表头标题数组
@property (nonatomic,assign) BOOL firstAppear;
//
@end
//
@implementation QLStudentListViewController
- (void)viewDidLoad{
    self.navigationItem.title = self.classInfo.name;
    //0.设置导航栏返回按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_btn_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_firstAppear) {
        _firstAppear = YES;
        self.studentListViewModel = [[QLStudentListViewModel alloc] initWithController:self];
    }
}

/**
 点击了导航栏左上角按钮
 */
- (void)leftNavigationItemClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftNavigationItemClickedNotification" object:nil];
}
@end
