//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAScoreListViewController.h"
#import <YWExcelView.h>
@interface CAScoreListViewController ()<YWExcelViewDataSource>
@property (nonatomic,strong) NSMutableArray *list;
@end

@implementation CAScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"show CAScoreListViewController");


    self.view.backgroundColor = [UIColor whiteColor];
    
    _list = @[].mutableCopy;
    
    [_list addObject:@{@"grade":@"2015196852",@"score":@[@"李松",@"20",@"30",@"40",@"50",@"60",@"70"]}];
    [_list addObject:@{@"grade":@"2015196853",@"score":@[@"张晶",@"201",@"301",@"401",@"501",@"601",@"701"]}];
    [_list addObject:@{@"grade":@"2015196854",@"score":@[@"赵信",@"202",@"302",@"402",@"502",@"602",@"702"]}];
    [_list addObject:@{@"grade":@"2015196855",@"score":@[@"文艺",@"203",@"303",@"403",@"503",@"603",@"703"]}];
    [_list addObject:@{@"grade":@"2015196855",@"score":@[@"夏磊",@"204",@"304",@"404",@"504",@"604",@"704"]}];
    [_list addObject:@{@"grade":@"2015196856",@"score":@[@"仙人",@"204",@"304",@"404",@"504",@"604",@"704"]}];
    [_list addObject:@{@"grade":@"2015196857",@"score":@[@"kami",@"204",@"304",@"404",@"504",@"604",@"704"]}];
    [_list addObject:@{@"grade":@"2015196858",@"score":@[@"haha",@"204",@"304",@"404",@"504",@"604",@"704"]}];

    
    [self test1];
    
    
}
- (void)test1{
    
    
    //    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(20, 74, CGRectGetWidth(self.view.frame) - 40, 250) style:YWExcelViewStyleDefalut headViewText:@[@"类目",@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"] height:40];
    
    YWExcelViewMode *mode = [YWExcelViewMode new];
    mode.style = YWExcelViewStyleDefalut;
    mode.headTexts = @[@"学号",@"姓名",@"听力",@"写作",@"阅读",@"期中",@"期末",@"总成绩"];
    mode.defalutHeight = 40;
    //推荐使用这样初始化
    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY) mode:mode];
    
    exceView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    exceView.dataSource = self;
    exceView.showBorder = YES;
    [self.view addSubview:exceView];
    
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(exceView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 20)];
    menuLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    menuLabel.textColor = [UIColor redColor];
    menuLabel.font = [UIFont systemFontOfSize:13];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.text = @"test";
    [self.view addSubview:menuLabel];
    
}

//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 8;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    if (indexPath.row < _list.count) {
        NSDictionary *dict = _list[indexPath.row];
        if (indexPath.item == 0) {
            label.text = dict[@"grade"];
        }else{
            NSArray *values = dict[@"score"];
            label.text = values[indexPath.item - 1];
        }
    }
}
- (void)setLessonClass:(CAClass *)lessonClass{
    NSLog(@"CAScoreListViewController setClass");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
