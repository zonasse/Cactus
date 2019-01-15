//
//  QLHomeViewModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/15.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLHomeViewModel.h"
#import "QLHomePageViewController.h"
#import "QLHomePageView.h"
@interface QLHomeViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) QLHomePageViewController *homePageVC;

///主页视图
@property (nonatomic,strong) QLHomePageView *homePageView;
///教师模型对象
//@property (nonatomic,strong) QLTeacherModel *teacher;
/////学院模型对象
//@property (nonatomic,strong) QLCollegeModel *college;
/////学校模型对象
//@property (nonatomic,strong) QLUniversityModel *university;
///教学班模型对象数组
@property (nonatomic, strong) NSMutableArray *classInfoArray;
@end

@implementation QLHomeViewModel
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.homePageVC = (QLHomePageViewController*)controller;
        self.homePageVC.tableView.delegate = self;
        
        [self refreshData];
    }
    return self;
}

- (void)refreshData{
    //发送网络请求获取数据
    __unsafe_unretained typeof(self) weakSelf = self;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //异步获取教师数据
    [MBProgressHUD showMessage:@"教学信息获取中..."];
    __block BOOL tag = YES;
    dispatch_group_async(group, queue, ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        params[@"id"] = [userDefaults valueForKey:k_user_id_key];
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_user_display parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:@"1041"]) {
                tag = NO;
            }else{
                NSArray *subjects = responseDict[@"subjects"];
                for (NSDictionary *dict in subjects) {
//                    weakSelf.teacher = [[QLTeacherModel alloc] initWithDict:dict];
//                    [[NSUserDefaults standardUserDefaults] setObject:weakSelf.teacher.name forKey:@"teacher_name"];
//                    weakSelf.college = [[QLCollegeModel alloc] initWithDict:dict[@"college_message"]];
//                    weakSelf.university = [[QLUniversityModel alloc] initWithDict:dict[@"university_message"]];
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
        NSString *urlString = [kBASE_URL stringByAppendingString:@"table/class_info/display"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *teacherId = [userDefaults valueForKey:@"userId"];
        params[@"teacher_id"] = teacherId;
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:@"1041"]) {
                tag = NO;
            }else{
                
                weakSelf.classInfoArray = responseDict[@"subjects"];
                
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
            [MBProgressHUD hideHUD];
            if (tag == YES) {
                [MBProgressHUD showSuccess:@"教学信息获取成功"];
//                [self.homePageView setTeacherName:self.teacher.name tid:self.teacher.tid universityName:self.university.name collegeName:self.college.name];
                [self.homePageVC.tableView reloadData];
                
//                [self.homePageView setClassInfoArray:self.classInfoArray];
            }else{
                [MBProgressHUD showError:@"教学信息获取失败"];
            }
        });
    });
    
}

#pragma mark ----tableview delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kSCREEN_HEIGHT * 0.4;
    }
    return 88;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _classInfoArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    return view;
}

- (QLClassInfoViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"classInfoCell";
    QLClassInfoViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[QLClassInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.classInfoArray[indexPath.section];
        //        NSDictionary *dict = self.classInfoArray[0];
        
        [cell setCellContentInformationWithClassInfoImage:@"" classInfoName:dict[@"name"] classInfoRoom:dict[@"room"] classInfoTime:dict[@"date"] classInfoStudentCount:[dict[@"student_count"] integerValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 选中cell后立马取消选中，达到点击cell的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.classInfoArray[indexPath.section];
    QLClassInfoModel *classInfo = [[QLClassInfoModel alloc] initWithDict:dict];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%ld", classInfo._id] forKey:@"currentClassInfo_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CAJumpToClassManagementViewControllerNotification" object:classInfo];
    
}
@end
