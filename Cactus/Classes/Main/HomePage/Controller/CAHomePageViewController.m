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
#import "CALesson.h"
#import "CAClass.h"
@interface CAHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userPic;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;//用户职工号
@property (weak, nonatomic) IBOutlet UILabel *userCollegeLabel;//用户所在学院
@property (weak, nonatomic) IBOutlet UIImageView *isManagerPic;//管理员标志图
@property (weak, nonatomic) IBOutlet UITableView *lessonListTableView;//课程列表

@property (nonatomic,strong) NSArray *lessons;//课程组
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
     * 搜索教师所有课程及课程所有教学班
     */
#pragma mark --获取数据量较大
    __block NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{@"teacher":self.teacher.t_id};
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"数据载入中..."];
        [manager GET:[baseURL stringByAppendingString:@"/lesson/info/format"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            /*
             * 5.判断服务器返回字段
             */
            if(responseDict[@"token"]){
                [MBProgressHUD hideHUD];
                self.lessons = responseDict[@"lessons"];
                [self.lessonListTableView reloadData];
            }else{
                [MBProgressHUD showError:@"课程信息获取失败，请刷新"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showError:@"未知错误"];
        }];
    });
    
    
    /*
     * 设置页面布局
     */
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- tableview datasource/delegate --------------
#pragma mark --课程行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CALesson *currentLesson = self.lessons[section];
    return currentLesson.classes.count;
}
#pragma mark --课程组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lessons.count;
}
#pragma mark --设置课程单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"lessonCell";
    CALessonViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[CALessonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        CALesson *currentLesson = self.lessons[indexPath.section];
        CAClass *currentClass = self.lessons[indexPath.section][indexPath.row];
        [cell setCellContentInformationWithLessonImage:@"" lessonClassName:currentClass.classInfo.name lessonName:currentLesson.name studentNumber:currentClass.students.count lessonTime:currentClass.classInfo.date];
    }
    return cell;
}
#pragma mark --单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
#pragma mark --点击当前课程
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     * 由indexPath判断当前课程并跳转到课程主界面
     */
    CALessonManagementViewController *lessonManagementVC = [[CALessonManagementViewController alloc] init];
    lessonManagementVC.lessonClass = self.lessons[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:lessonManagementVC animated:YES];
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
