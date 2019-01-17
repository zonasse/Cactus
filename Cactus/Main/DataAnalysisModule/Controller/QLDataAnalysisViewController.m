//
//  CADataAnalasisViewController.m
//  Cactus
//
//  Created by  zonasse on 2018/11/1.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import "QLDataAnalysisViewController.h"
#import "QLDataAnalysisContentView.h"
@interface QLDataAnalysisViewController ()
///替换视图
@property (nonatomic,strong) QLDataAnalysisContentView *contentView;
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation QLDataAnalysisViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.classInfo.name;

    //0.设置导航栏返回按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_btn_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
}

/**
 点击了导航栏左上角按钮
 */
- (void)leftNavigationItemClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftNavigationItemClickedNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideRightItemNotification" object:nil];
    if (!_firstAppear) {
        _firstAppear = YES;
        //添加替换视图
        _contentView = [[QLDataAnalysisContentView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-44)];
        _contentView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT + 600);
        _contentView.showsVerticalScrollIndicator = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
    }
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark - getters and setters

#pragma mark - private

#pragma mark - notification methods

@end
