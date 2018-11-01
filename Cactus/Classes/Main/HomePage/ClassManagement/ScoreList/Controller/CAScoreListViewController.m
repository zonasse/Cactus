//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAScoreListViewController.h"
#import "ExcelView.h"
#import "CAPoint.h"
#import "CATitle.h"
#import "CAStudent.h"
@interface CAScoreListViewController ()
@property (nonatomic,strong) ExcelView *excelView;
@property(nonatomic,strong) NSMutableArray *leftTableDataArray;//表格第一列数据
@property(nonatomic,strong) NSMutableArray *excelDataArray;//表格数据
@property(nonatomic,strong) NSMutableArray *rightTableHeadArray;//表格第一行表头数据
@property(nonatomic,strong) NSMutableArray *allTableDataArray;//表格所有数据
@property (nonatomic,assign) BOOL firstAppear;

@property (nonatomic,strong) NSMutableArray *students;
@property (nonatomic,strong) NSMutableArray *points;
@property (nonatomic,strong) NSMutableArray *titles;

@end

@implementation CAScoreListViewController
- (NSMutableArray *)students{
    if (!_students) {
        _students = [NSMutableArray array];
    }
    return _students;
}
- (NSMutableArray *)points{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
- (NSMutableArray *)leftTableDataArray{
    if (!_leftTableDataArray) {
        _leftTableDataArray = [NSMutableArray array];
    }
    return _leftTableDataArray;
}
- (NSMutableArray *)rightTableHeadArray{
    if (!_rightTableHeadArray) {
        _rightTableHeadArray = [NSMutableArray array];
    }
    return _rightTableHeadArray;
}
- (NSMutableArray *)allTableDataArray{
    if (!_allTableDataArray) {
        _allTableDataArray = [NSMutableArray array];
    }
    return _allTableDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupExcelView];

}
- (void)viewWillAppear:(BOOL)animated{
    if (!_firstAppear) {
        _firstAppear = YES;

        /*
         * 同时请求分数、学生、列名数据
         */
        __unsafe_unretained typeof(self) weakSelf = self;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        params[@"token"] = token;
//        params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", weakSelf.classInfo._id];
        params[@"classInfo_id"] = @"1";
        //1.请求分数
        dispatch_group_async(group, queue, ^{
            NSString *urlString = [baseURL stringByAppendingString:@"point/display"];
            [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSArray *subjects = responseObject[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    CAPoint *point = [[CAPoint alloc] initWithDict:dict];
                    [weakSelf.points addObject:point];
                }
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);

            }];
        });
        //2.请求学生列表
        dispatch_group_async(group, queue, ^{
            NSString *urlString = [baseURL stringByAppendingString:@"student/display"];

            [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSArray *subjects = responseObject[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    CAStudent *student = [[CAStudent alloc] initWithDict:dict];
                    [weakSelf.students addObject:student];
                }
                
                dispatch_semaphore_signal(semaphore);

            } failure:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);

            }];
        });
        //3.请求分数项
        dispatch_group_async(group, queue, ^{
            NSString *urlString = [baseURL stringByAppendingString:@"title/display"];

            [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSArray *subjects = responseObject[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    CATitle *title = [[CATitle alloc] initWithDict:dict];
                    [weakSelf.titles addObject:title];
                }
                dispatch_semaphore_signal(semaphore);

            } failure:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);

            }];
        });
        dispatch_notify(group, queue, ^{
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新UI
                    [self getScoreData];
                });
            });
        });
    }
}
#pragma mark --设置表格
- (void)setupExcelView{

    _excelView=[[ExcelView alloc]initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY)];
    _excelView.isLockFristColumn=YES;
    _excelView.isLockFristRow=YES;
    _excelView.isColumnTitlte=YES;
    _excelView.columnTitlte=@"地区";
    [self.view addSubview:_excelView];
}
#pragma mark --获取分数数据
- (void)getScoreData{
    //列数
    NSMutableArray *headTitles = [NSMutableArray array];
    [headTitles addObject:@"学号"];
    [headTitles addObject:@"姓名"];
    for (CATitle *title in self.titles) {
        [headTitles addObject:title.name];
    }
    [self.allTableDataArray addObject:headTitles];
    //行数
    for (CAStudent *student in self.students) {
        NSMutableArray *rowArray = [NSMutableArray array];
        [rowArray addObject:student.sid];
        [rowArray addObject:student.name];
        for (CATitle *title in self.titles) {
            BOOL flag = NO;
            for (CAPoint *point in self.points) {
                if (point.student_id == student._id && point.title_id == title._id) {
                    [rowArray addObject:[NSString stringWithFormat:@"%ld",point.pointNumber]];
                    flag = YES;
                    break;
                }
            }
            if (!flag) {
                [rowArray addObject:@""];
            }
        }
        [self.allTableDataArray addObject:rowArray];
        
    }
    _excelView.allTableDatas = self.allTableDataArray;
    [_excelView show];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
