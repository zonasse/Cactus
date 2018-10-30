//
//  CAStudentListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAStudentListViewController.h"
#import <YWExcelView.h>
#import "CAStudent.h"
@interface CAStudentListViewController ()<YWExcelViewDataSource>
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation CAStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"show CAStudentListViewController");

    // Do any additional setup after loading the view.
}
- (void)setLessonClass:(CAClass *)lessonClass{
    _lessonClass = lessonClass;
    
    NSLog(@"CAStudentListViewController setClass");

    [self test1];
}

- (void)test1{
    
    
    //    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(20, 74, CGRectGetWidth(self.view.frame) - 40, 250) style:YWExcelViewStyleDefalut headViewText:@[@"类目",@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"] height:40];
    
    YWExcelViewMode *mode = [YWExcelViewMode new];
    mode.style = YWExcelViewStyleDefalut;
    mode.headTexts = @[@"学号",@"姓名",@"性别",@"星座",@"年龄"];
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
//    return self.lessonClass.students.count;
    return 0;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 8;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
//    if (indexPath.row < self.lessonClass.students.count) {
//        CAStudent *currentStudent = self.lessonClass.students[indexPath.row];
//        if (indexPath.item == 0) {
//            label.text = currentStudent.s_id;
//        }else{
            //NSArray *values = dict[@"score"];
            //label.text = values[indexPath.item - 1];
//            label.text = currentStudent.name;
//        }
//    }
}
- (void)viewWillAppear:(BOOL)animated{
    if (!_firstAppear) {
        _firstAppear = YES;
        //获取数据
    }
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
