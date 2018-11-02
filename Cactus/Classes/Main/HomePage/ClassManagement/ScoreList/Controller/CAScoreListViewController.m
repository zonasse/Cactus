//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAScoreListViewController.h"
//#import "ExcelView.h"
#import "YWExcelView.h"
#import "CAPoint.h"
#import "CATitle.h"
#import "CAStudent.h"
@interface CAScoreListViewController ()<YWExcelViewDelegate,YWExcelViewDataSource>
@property (nonatomic,strong) YWExcelView *excelView;
@property (nonatomic,strong) YWExcelViewMode *excelViewMode;
@property (nonatomic,strong) NSMutableArray *headTextsArray;
@property (nonatomic,assign) BOOL firstAppear;

@property (nonatomic,strong) NSMutableArray *students;
@property (nonatomic,strong) NSMutableArray *points;
@property (nonatomic,strong) NSMutableArray *titles;

@end

@implementation CAScoreListViewController
{
    NSString *_ctl;
    NSMutableArray *_list;
}

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
- (NSMutableArray *)headTextsArray{
    if (!_headTextsArray) {
        _headTextsArray = [NSMutableArray array];
    }
    return _headTextsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTitle) name:@"addTitleNotification" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRightItemNotification" object:nil];
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
                    [self setupExcelView];
                });
            });
        });
    }
}
#pragma mark --设置表格

- (void)setupExcelView{
    [self.headTextsArray addObject:@"学号"];
    [_headTextsArray addObject:@"姓名"];
    for (CATitle *title in self.titles) {
        [_headTextsArray addObject:title.name];
    }
    
    self.excelViewMode = [YWExcelViewMode new];
    _excelViewMode.headTexts = _headTextsArray;
    _excelViewMode.style = YWExcelViewStyleDefalut;
    _excelViewMode.defalutHeight = 40;
    //推荐使用这样初始化
    _excelView = [[YWExcelView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-44-tabbarVCStartY) mode:_excelViewMode];
    _excelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _excelView.dataSource = self;
    _excelView.showBorder = YES;
    [self.view addSubview:_excelView];
    
    
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_excelView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 20)];
    menuLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    menuLabel.textColor = [UIColor redColor];
    menuLabel.font = [UIFont systemFontOfSize:13];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.text = _ctl;
    [self.view addSubview:menuLabel];
    
   
    _list = [NSMutableArray array];
    for (int i=0; i<10; ++i) {
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
            [_list addObject:rowArray];
        }
    }
    [_excelView reloadData];

}
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 2+_titles.count;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
//    if (indexPath.row < _list.count) {
//        NSDictionary *dict = _list[indexPath.row];
//        if (indexPath.item == 0) {
//            label.text = dict[@"grade"];
//        }else{
//            NSArray *values = dict[@"score"];
//            label.text = values[indexPath.item - 1];
//        }
    NSArray *arr = _list[indexPath.row];
    label.text = arr[indexPath.item];
    label.tag = indexPath.row * (2+_titles.count) + indexPath.item;
//    }
}
#pragma mark --增加一列
- (void)addTitle{
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//
//    CATitle *newTitle = [[CATitle alloc] init];
//    newTitle.name = @"";
//    [self.titles addObject:newTitle];
//    [_headTextsArray addObject:@""];
//    [self setupExcelView];  

//    _excelViewMode.headTexts = _headTextsArray;
//    [_excelView resetMode:_excelViewMode];
    
}
@end
