//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAHomePageViewController.h"
#import "CALessonViewCell.h"
#import "CALessonManagementViewController.h"
@interface CAHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userPic;//用户头像
@property (weak, nonatomic) IBOutlet UITableView *lessonListTableView;//课程列表
#pragma mark --添加其他组件
@end

@implementation CAHomePageViewController

#pragma mark --设置headerview，自动刷新或下拉刷新获取数据

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程主页";
    self.lessonListTableView.delegate = self;
    self.lessonListTableView.dataSource = self;
    
    /*
     * 设置页面布局
     */
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- tableview datasource/delegate --------------
#pragma mark --课程行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark --课程组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark --设置课程单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"lessonCell";
    CALessonViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[CALessonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
#pragma mark --单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
#pragma mark --点击当前课程
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     * 由indexPath判断当前课程并跳转到课程主界面
     */
    [self.navigationController pushViewController:[[CALessonManagementViewController alloc] init] animated:YES];
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
