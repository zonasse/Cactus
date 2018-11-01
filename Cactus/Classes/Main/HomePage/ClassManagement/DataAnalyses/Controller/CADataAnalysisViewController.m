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
@property (nonatomic,strong) CADataAnalysisContentView *contentView;
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation CADataAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_firstAppear) {
        _firstAppear = YES;
        _contentView = [[CADataAnalysisContentView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY)];
        _contentView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 600);
        _contentView.showsVerticalScrollIndicator = YES;
        [self.view addSubview:_contentView];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
