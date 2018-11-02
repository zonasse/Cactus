//
//  CAClassHomePageViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAClassInfoDisplayMViewController.h"
#import "CATeacher.h"
#import "CAClassInfo.h"
@interface CAClassInfoDisplayMViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *classInfoTableView;
@property (nonatomic,strong) UIImageView *classImageView;
@property (nonatomic,strong) UILabel *teacherNameLabel;
@property (nonatomic,strong) UILabel *studentNumberLabel;
@property (nonatomic,strong) UILabel *lessonTimeLabel;
@property (nonatomic,strong) UILabel *teachRoomLabel;
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation CAClassInfoDisplayMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.classImageView];
//    [self.view addSubview:self.teacherNameLabel];
//    [self.view addSubview:self.studentNumberLabel];
//    [self.view addSubview:self.lessonTimeLabel];
//    [self.view addSubview:self.teachRoomLabel];

#pragma mark --所有子控件y值应从64开始
    
    NSLog(@"show CALessonHomePageViewController");
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideRightItemNotification" object:nil];
    if (!_firstAppear) {
        _firstAppear = YES;
        //获取数据
        self.classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY) style:UITableViewStyleGrouped];
//        self.classInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.classInfoTableView];
        self.classInfoTableView.delegate = self;
        self.classInfoTableView.dataSource = self;
    }
}
- (void)setClassInfo:(CAClassInfo *)classInfo{
    _classInfo = classInfo;
//    NSLog(@"CALessonHomePageViewController setClass");
//    self.classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 150)];
//    [self.classImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"课程占位"]];
//
//    self.teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.classImageView.frame) + 10, 150, 34)];
//    self.teacherNameLabel.text = [NSString stringWithFormat:@"任课教师 : %ld", classInfo.teacher_id];
//    self.teacherNameLabel.textAlignment = NSTextAlignmentLeft;
//
//    self.studentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150 - 20, self.teacherNameLabel.frame.origin.y, 100, self.teacherNameLabel.frame.size.height)];
//    self.studentNumberLabel.text = [NSString stringWithFormat:@"学生人数 : %lu", _classInfo.year];
//    self.studentNumberLabel.textAlignment = NSTextAlignmentLeft;
//
//    self.lessonTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.teacherNameLabel.frame.origin.x, CGRectGetMaxY(self.teacherNameLabel.frame) + 10, self.teacherNameLabel.frame.size.width, self.teacherNameLabel.frame.size.height)];
//    self.lessonTimeLabel.text = [NSString stringWithFormat:@"上课时间 : %@",self.classInfo.date];
//    self.lessonTimeLabel.textAlignment = NSTextAlignmentLeft;
//
//    self.teachRoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.studentNumberLabel.frame.origin.x, self.lessonTimeLabel.frame.origin.y, self.lessonTimeLabel.frame.size.width, self.lessonTimeLabel.frame.size.height)];
//    self.teachRoomLabel.text = [NSString stringWithFormat:@"上课地点 : %@",_classInfo.room];
//    self.teachRoomLabel.textAlignment = NSTextAlignmentLeft;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableViewDelegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"classInfoDisplayCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"班级：";
            cell.detailTextLabel.text = self.classInfo.name;
            break;
        case 1:
            cell.textLabel.text = @"教师：";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", self.classInfo.teacher_id];
            break;
        case 2:
            cell.textLabel.text = @"上课时间：";
            cell.detailTextLabel.text = self.classInfo.date;
            break;
        case 3:
            cell.textLabel.text = @"上课地点：";
            cell.detailTextLabel.text = self.classInfo.room;
            break;
        case 4:
            cell.textLabel.text = @"学生人数：";
            cell.detailTextLabel.text = @"41";
            break;
        case 5:
            cell.textLabel.text = @"学年：";
            cell.detailTextLabel.text = self.classInfo.year;
            break;
        default:
            break;
    }
    
    return cell;
}
@end
