//
//  QLHomeViewModel.m
//  Cactus
//
//  Created by  zonasse on 2019/1/15.
//  Copyright © 2019  zonasse. All rights reserved.
//

#import "QLHomeViewModel.h"
#import "QLHomePageViewController.h"
#import "QLHomePageProfileCell.h"
#import "QLHomePageClassInfoCell.h"
#import "QLTeacherModel.h"
#import "QLCollegeModel.h"
#import "QLUniversityModel.h"
#import "QLClassInfoModel.h"
#import "QLTabBarViewController.h"

@interface QLHomeViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) QLHomePageViewController *homePageVC;
///教师模型对象
@property (nonatomic,strong) QLTeacherModel *teacher;
///学院模型对象
@property (nonatomic,strong) QLCollegeModel *college;
///学校模型对象
@property (nonatomic,strong) QLUniversityModel *university;
///教学班模型对象数组
@property (nonatomic,strong) NSMutableArray *classInfoArray;
///当前学期教学班模型对象数组
@property (nonatomic,strong) NSMutableArray *currentSemesterClassInfoArray;
///当前学期
@property (nonatomic,copy) NSString *currentSemester;
///学期集合
@property (nonatomic,strong) NSMutableArray *semesterArray;

//@property (nonatomic,strong) UIPickerView *semesterPickerView;
@end

@implementation QLHomeViewModel
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.homePageVC = (QLHomePageViewController*)controller;
        self.homePageVC.tableView.delegate = self;
        self.homePageVC.tableView.dataSource = self;
        self.homePageVC.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.homePageVC.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshData];
        }];
        [self.homePageVC.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (NSMutableArray *)classInfoArray{
    if (!_classInfoArray) {
        _classInfoArray = [NSMutableArray array];
    }
    return _classInfoArray;
}
- (NSMutableArray *)currentSemesterClassInfoArray{
    if (!_currentSemesterClassInfoArray) {
        _currentSemesterClassInfoArray = [NSMutableArray array];
    }
    return _currentSemesterClassInfoArray;
}
- (NSMutableArray *)semesterArray{
    if (!_semesterArray) {
        _semesterArray = [NSMutableArray array];
    }
    return _semesterArray;
}
- (void)refreshData{
    //发送网络请求获取数据
    __unsafe_unretained typeof(self) weakSelf = self;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //异步获取教师数据
    __block BOOL tag = YES;
    dispatch_group_async(group, queue, ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        params[@"id"] = [userDefaults valueForKey:k_user_id_key];
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_user_display parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
                tag = NO;
            }else{
                NSArray *subjects = responseDict[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    weakSelf.teacher = [[QLTeacherModel alloc] initWithDict:dict];
                    [[NSUserDefaults standardUserDefaults] setObject:weakSelf.teacher.name forKey:k_teacher_name_key];
                    weakSelf.college = [[QLCollegeModel alloc] initWithDict:dict[@"college_message"]];
                    weakSelf.university = [[QLUniversityModel alloc] initWithDict:dict[@"university_message"]];
                }
                
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            tag = NO;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //3.2异步获取教学班数据
    dispatch_group_async(group, queue, ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        params[@"teacher_id"] = [userDefaults valueForKey:k_user_id_key];
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_classInfo_display parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
                tag = NO;
            }else{
                //移除旧数据
                [self.classInfoArray removeAllObjects];
                [self.currentSemesterClassInfoArray removeAllObjects];
                [self.semesterArray removeAllObjects];
                //设置新数据
                NSArray *subjects = responseDict[@"subjects"];
                NSMutableSet *semesterSet = [NSMutableSet set];
                for (NSDictionary *classInfoDict in subjects) {
                    QLClassInfoModel *classInfo = [[QLClassInfoModel alloc] initWithDict:classInfoDict];
                    [weakSelf.classInfoArray addObject:classInfo];
                    [semesterSet addObject:classInfo.semester];
                    self.currentSemester = classInfo.currentSemester;
                    if ([self.currentSemester isEqualToString:classInfo.semester]) {
                        [self.currentSemesterClassInfoArray addObject:classInfo];
                    }
                }
                [self.semesterArray addObject:self.currentSemester];

                [semesterSet enumerateObjectsUsingBlock:^(NSString *obj, BOOL * _Nonnull stop) {
                    if (![obj isEqualToString:self.currentSemester]) {
                        [self.semesterArray addObject:obj];
                    }
                }];
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            tag = NO;
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //3.3同时获取到时刷新UI
    dispatch_group_notify(group, queue, ^{
        //两个请求对应两次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tag == YES) {
                [self.homePageVC.tableView.mj_header endRefreshing];
                [self.homePageVC.tableView reloadData];
            }
        });
    });
    
}

#pragma mark ----tableview delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 210;
    }
    return 90;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.currentSemesterClassInfoArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    headerView.backgroundColor = kRGB(212.0, 212.0, 212.0);
    UILabel *semesterLabel = [[UILabel alloc] init];
    semesterLabel.font = [UIFont systemFontOfSize:12.0];
    semesterLabel.textColor = [UIColor grayColor];
    semesterLabel.text = self.currentSemester;
    CGSize size = [semesterLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    CGSize adaptionSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    semesterLabel.frame = CGRectMake(20, 0, adaptionSize.width, 30);
    
    
    UIButton *changeSemesterButton = [[UIButton alloc] initWithFrame:CGRectMake(semesterLabel.getMaxX + 20, semesterLabel.y, 40, semesterLabel.height)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更改"];
    
    NSRange strRange = {0,[str length]};
    
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:strRange];
    [changeSemesterButton setAttributedTitle:str forState:UIControlStateNormal];
    [changeSemesterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [changeSemesterButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [changeSemesterButton addTarget:self action:@selector(changeSemester) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:semesterLabel];
    [headerView addSubview:changeSemesterButton];
    
    return headerView;

}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.0;
//    }else{
//        return 5;
//    }
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
//    footerView.backgroundColor = kRGB(212, 212, 212);
//    return footerView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QLHomePageProfileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[QLHomePageProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
            [cell setTeacherName:self.teacher.name tid:self.teacher.tid universityName:self.university.name collegeName:self.college.name];
        }
        return cell;
    }else{
        static NSString *cellId = @"classInfoCell";
        QLHomePageClassInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[QLHomePageClassInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            QLClassInfoModel *classInfo = self.currentSemesterClassInfoArray[indexPath.row];

            [cell setCellContentInformationWithClassInfoImage:@"" classInfoName:classInfo.name classInfoRoom:classInfo.room classInfoTime:classInfo.semester classInfoStudentCount:classInfo.student_count];
        }
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 选中cell后立马取消选中，达到点击cell的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    QLClassInfoModel *classInfo = self.currentSemesterClassInfoArray[indexPath.row];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%ld", classInfo._id] forKey:k_classInfo_id_key];
    
    QLTabBarViewController *tabBarVC = [[QLTabBarViewController alloc] init];
    tabBarVC.classInfo = classInfo;
    [self.homePageVC presentViewController:tabBarVC animated:YES completion:^{
        
    }];
    
}

- (void)changeSemester{
 
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改当前学期" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    for (NSString *semester in self.semesterArray) {
        [alert addAction:[UIAlertAction actionWithTitle:semester style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![action.title isEqualToString:self.currentSemester]) {
                self.currentSemester = action.title;
                [self.currentSemesterClassInfoArray removeAllObjects];
                for (QLClassInfoModel *classInfo in self.classInfoArray) {
                    if ([classInfo.semester isEqualToString:self.currentSemester]) {
                        [self.currentSemesterClassInfoArray addObject:classInfo];
                    }
                }
                [self.homePageVC.tableView reloadData];
            }
        }]];
    }
    [self.homePageVC presentViewController:alert animated:YES completion:^{
        
    }];
}

@end
