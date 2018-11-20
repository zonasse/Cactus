//
//  CADataAnalasisViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/1.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CADataAnalysisViewController.h"
#import "CADataAnalysisContentView.h"
@interface CADataAnalysisViewController ()
///替换视图
@property (nonatomic,strong) CADataAnalysisContentView *contentView;
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation CADataAnalysisViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideRightItemNotification" object:nil];
    if (!_firstAppear) {
        _firstAppear = YES;
        //添加替换视图
        _contentView = [[CADataAnalysisContentView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-44)];
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
