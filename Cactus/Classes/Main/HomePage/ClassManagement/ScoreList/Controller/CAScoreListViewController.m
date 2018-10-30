//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAScoreListViewController.h"
#import "CAScoreListView.h"
#import "ExcelView.h"
@interface CAScoreListViewController ()<ExcelViewDelegate>
@property (nonatomic,strong) CAScoreListView *scoreListView;
@property (nonatomic,strong) ExcelView *excelView;

@property (nonatomic,assign) BOOL firstAppear;

@end

@implementation CAScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    if (!_firstAppear) {
        _firstAppear = YES;
        _excelView = [[ExcelView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _excelView.delegate = self;
        [self.view addSubview:_excelView];
        ExcelModel *headerModel = [ExcelModel new];
        headerModel.title = @"学生姓名";
        headerModel.contentArray = @[@"年龄",@"爱好",@"工作",@"邮箱",@"对象",@"父母",
                                     @"年龄",@"爱好",@"工作",@"邮箱",@"对象",@"父母"];
        _excelView.headerModel = headerModel;
        
        ExcelModel *contentModel = [ExcelModel new];
        contentModel.title = @"小刘";
        contentModel.contentArray = @[@"16",@"打游戏",@"开发",@"3944423@163.com",@"翠花",@"隐私",
                                      @"16",@"打游戏",@"开发",@"3944423@163.com",@"翠花",@"隐私"];
        _excelView.dataArray = @[contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel];
        
        [_excelView drawExcel];
        //获取数据
//        _scoreListView = [[CAScoreListView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY)];
//        [self.view addSubview:_scoreListView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemOnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    NSLog(@"点击了第%ld行第%ld个",indexPath.row + 1 , index + 1);
}

- (void)headerItemOnClick:(UIButton *)sender index:(NSInteger)index {
    NSLog(@"点击了第%ld个", index + 1);
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
