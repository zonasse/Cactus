//
//  CAHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAHomePageViewController.h"
#import "CALessonManagementViewController.h"

#import "CAHomePageView.h"
@interface CAHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UIImageView *userPic;//用户头像
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;//用户姓名
//@property (weak, nonatomic) IBOutlet UILabel *useridLabel;//用户职工号
//@property (weak, nonatomic) IBOutlet UILabel *userCollegeLabel;//用户所在学院
//@property (weak, nonatomic) IBOutlet UIImageView *isManagerPic;//管理员标志图
//@property (weak, nonatomic) IBOutlet UITableView *lessonListTableView;//课程列表

@property (nonatomic,strong) CAHomePageView *homePageView;

//@property (nonatomic,strong) NSArray *lessons;//课程组
#pragma mark --添加其他组件
@end

@implementation CAHomePageViewController

#pragma mark --设置headerview，自动刷新或下拉刷新获取数据

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程主页";
    
    _homePageView = [[CAHomePageView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-tabbarVCStartY)];
    [self.view addSubview:_homePageView];
    
    
#pragma mark --获取教师以及教学班数据，获取数据量较大
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    /*
     * 异步获取教师与教学班数据
     */
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [baseURL stringByAppendingString:@"user/info/format"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        NSString *teacherId = [userDefaults valueForKey:@"userId"];
        params[@"token"] = token;
        params[@"id"] = teacherId;
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSArray *subjects = responseObject[@"subjects"];
            [self.homePageView setTeacherProfileData:subjects[0]];
            NSLog(@"teaherProfile:%@",subjects);
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"个人信息获取失败"];
        }];
    });
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [baseURL stringByAppendingString:@"table/class_info/format"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        NSString *teacherId = [userDefaults valueForKey:@"userId"];
        params[@"token"] = token;
        params[@"teacher_id"] = teacherId;
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSLog(@"class_info:%@",responseObject);
            [self.homePageView setClassInfoData:responseObject[@"subjects"]];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"教学信息获取失败"];
        }];
    });
    
    

    
//    self.lessonListTableView.delegate = self;
//    self.lessonListTableView.dataSource = self;
//
//
//    self.usernameLabel.text = [NSString stringWithFormat:@"教师:%@",self.teacher.name];
//    self.userCollegeLabel.text = [NSString stringWithFormat:@"学院:%@",self.teacher.college.name];;
//    self.useridLabel.text = [NSString stringWithFormat:@"工号:%@",self.teacher.t_id];;
//    self.isManagerPic.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec1d", 34, [UIColor orangeColor])];
//    [self.userPic sd_setImageWithURL:[NSURL URLWithString:self.teacher.avatar] placeholderImage:[UIImage imageNamed:@"头像占位"]];
//#pragma mark --构造虚拟数据用于展示
//    NSMutableArray *lessons = [[NSMutableArray alloc] init];
//    CALesson *lesson1 = [[CALesson alloc] init];
//    lesson1.name = @"英语视听说";
//    CAClass *class1 = [[CAClass alloc] init];
//    class1.classInfo = [[CAClassInfo alloc] initWithDict:@{@"name":@"英语视听说1班",@"date":@"秋季学期4-18双周",@"room":@"10-202"}];
//    class1.teacher = self.teacher;
//    CAClass *class2 = [[CAClass alloc] init];
//    class2.classInfo = [[CAClassInfo alloc] initWithDict:@{@"name":@"英语视听说2班",@"date":@"秋季学期4-18单周",@"room":@"10-309"}];
//    class2.teacher = self.teacher;
//
//    lesson1.classes = [NSArray arrayWithObjects:class1,class2, nil];
//
//    CALesson *lesson2 = [[CALesson alloc] init];
//    lesson2.name = @"英语学术写作";
//    CAClass *class3 = [[CAClass alloc] init];
//    class3.classInfo = [[CAClassInfo alloc] initWithDict:@{@"name":@"英语写作1班",@"date":@"秋季学期3-12双周",@"room":@"5-101"}];
//    class3.teacher = self.teacher;
//
//    CAClass *class4 = [[CAClass alloc] init];
//    class4.classInfo = [[CAClassInfo alloc] initWithDict:@{@"name":@"英语写作2班",@"date":@"秋季学期3-12单周",@"room":@"5-891"}];
//    class4.teacher = self.teacher;
//
//    lesson2.classes = [NSArray arrayWithObjects:class3,class4, nil];
//    [lessons addObject:lesson1];
//    [lessons addObject:lesson2];
//    self.lessons = lessons;
//    [self.lessonListTableView reloadData];
    /*
     * 搜索教师所有课程及课程所有教学班
     */
    
//    __block NSError *error;
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *params = @{@"teacher":self.teacher.t_id};
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD showMessage:@"数据载入中..."];
//        [manager GET:[baseURL stringByAppendingString:@"/lesson/info/format"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
//            /*
//             * 5.判断服务器返回字段
//             */
//            if(responseDict[@"token"]){
//                [MBProgressHUD hideHUD];
//                self.lessons = responseDict[@"lessons"];
//                [self.lessonListTableView reloadData];
//            }else{
//                [MBProgressHUD showError:@"课程信息获取失败，请刷新"];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [MBProgressHUD showError:@"未知错误"];
//        }];
//    });

    
    /*
     * 设置页面布局
     */
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- tableview datasource/delegate --------------
//#pragma mark --课程行数
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    CALesson *currentLesson = self.lessons[section];
//    return currentLesson.classes.count;
//}
//#pragma mark --课程组数
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.lessons.count;
//}
//#pragma mark --设置课程单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"lessonCell";
//    CALessonViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if(!cell){
//        cell = [[CALessonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        CALesson *currentLesson = self.lessons[indexPath.section];
//        CAClass *currentClass = currentLesson.classes[indexPath.row];
//        [cell setCellContentInformationWithLessonImage:@"" lessonClassName:currentClass.classInfo.name lessonName:currentLesson.name studentNumber:currentClass.students.count lessonTime:currentClass.classInfo.date classRoom:currentClass.classInfo.room];
//    }
//    return cell;
//}
//#pragma mark --单元格行高
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return cellHeight;
//}
//#pragma mark --点击当前课程
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    /*
//     * 取消单元格背景灰色
//     */
//    CALessonViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    /*
//     * 由indexPath判断当前课程并跳转到课程主界面
//     */
//    CALessonManagementViewController *lessonManagementVC = [[CALessonManagementViewController alloc] init];
//    CALesson *currentLesson = self.lessons[indexPath.section];
//    lessonManagementVC.lessonClass = currentLesson.classes[indexPath.row];
//    [self.navigationController pushViewController:lessonManagementVC animated:YES];
//}
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
