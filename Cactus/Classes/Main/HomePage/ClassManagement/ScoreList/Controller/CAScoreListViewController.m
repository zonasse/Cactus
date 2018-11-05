//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAScoreListViewController.h"
#import "CAChangeScoreViewController.h"
#import "CAAddPointTitleViewController.h"
#import "CADeletePointTitleViewController.h"
#import "YWExcelView.h"
#import "YCXMenu.h"
#import "CAPointModel.h"
#import "CATitleModel.h"
#import "CAStudentModel.h"
#import "NSDictionary+CADictionaryDeepCopy.h"
@interface CAScoreListViewController ()<YWExcelViewDelegate,YWExcelViewDataSource>
///excel视图
@property (nonatomic,strong) YWExcelView *excelView;
///excel视图模式
@property (nonatomic,strong) YWExcelViewMode *excelViewMode;
///excel视图表头标题数组
@property (nonatomic,strong) NSMutableArray *headTextsArray;
///学生对象数组
@property (nonatomic,strong) NSMutableArray *students;
///分数对象数组
@property (nonatomic,strong) NSMutableArray *points;
///分数列对象数组
@property (nonatomic,strong) NSMutableArray *titles;
///学生-分数-分数列字典
@property (nonatomic,strong) NSMutableDictionary *hashMap;

@property (nonatomic,assign) BOOL firstAppear;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightNavigationItemClicked) name:@"rightNavigationItemClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchPointCell:) name:@"pointCellTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pointModifySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRightItemNotification" object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_firstAppear) {
        _firstAppear = YES;
        [self refresh];
       
    }
}
#pragma mark --设置表格

- (void)setupExcelView{
    [self.headTextsArray addObject:@"学号"];
    [_headTextsArray addObject:@"姓名"];
    for (CATitleModel *title in self.titles) {
        [_headTextsArray addObject:title.name];
    }
    
    self.excelViewMode = [YWExcelViewMode new];
    _excelViewMode.headTexts = _headTextsArray;
    _excelViewMode.style = YWExcelViewStyleDefalut;
    _excelViewMode.defalutHeight = 40;
    //推荐使用这样初始化
    _excelView = [[YWExcelView alloc] initWithFrame:CGRectMake(0, kTABBAR_START_Y, kSCREEN_WIDTH, kSCREEN_HEIGHT-44-kTABBAR_START_Y) mode:_excelViewMode];
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
    _hashMap = [NSMutableDictionary dictionary];
    for (CAStudentModel *student in self.students) {
        NSMutableDictionary *inner = [NSMutableDictionary dictionary];
        for (CATitleModel *title in self.titles) {
            for (CAPointModel *point in self.points) {
                if (point.student_id == student._id && point.title_id == title._id) {
                    NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
                    [inner setValue:point forKey:title_id_str];
                }
            }
        }
        NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];

        [_hashMap setValue:inner forKey:student_id_str];
    }
   
    _list = [NSMutableArray array];
    for (int i=0; i<10; ++i) {
        for (CAStudentModel *student in self.students) {
            NSMutableArray *rowArray = [NSMutableArray array];
            [rowArray addObject:student.sid];
            [rowArray addObject:student.name];
            for (CATitleModel *title in self.titles) {
//                BOOL flag = NO;
                NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];
                NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
                CAPointModel *point = _hashMap[student_id_str][title_id_str];
                if (point.pointNumber) {
                    [rowArray addObject:[NSString stringWithFormat:@"%ld",point.pointNumber]];
                }else{
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
    NSArray *arr = _list[indexPath.row];
    label.text = arr[indexPath.item];
    if (indexPath.item > 1) {
        label.tag = indexPath.row * (_titles.count) + indexPath.item-2;
    }else{
        label.tag = -1;
    }
}
#pragma mark --增加一列
- (void)rightNavigationItemClicked{
    [YCXMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        NSMutableArray *items = [NSMutableArray array];
        YCXMenuItem *addTitleItem = [YCXMenuItem menuItem:@"增加分数列" image:nil target:self action:@selector(addTitle)];
        YCXMenuItem *deleteTitleItem = [YCXMenuItem menuItem:@"删除分数列" image:nil target:self action:@selector(deleteTitle)];
        [items addObject:addTitleItem];
        [items addObject:deleteTitleItem];
        
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, kTABBAR_START_Y, 50, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
    
}
- (void)addTitle{
        CAAddPointTitleViewController *addPointTitleVC = [[CAAddPointTitleViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addPointTitleVC];
        addPointTitleVC.students = self.students;
        addPointTitleVC.hashMap = [_hashMap mutableDeepCopy];
    
        [self presentViewController:nav animated:YES completion:^{
    
        }];
}
- (void)deleteTitle{
    CADeletePointTitleViewController *deletePointTitleVC = [[CADeletePointTitleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deletePointTitleVC];
    deletePointTitleVC.titles = [self.titles mutableCopy];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (void)touchPointCell:(NSNotification*) noti{
    NSArray *labels = noti.object;
    CAStudentModel *currentStudent;
    NSMutableArray *currentTitles = [NSMutableArray array];
    for (UILabel *label in labels) {
        if (label.tag == -1) {
            continue;
        }
        currentStudent = self.students[label.tag/self.titles.count];
        CATitleModel *title = self.titles[label.tag%self.titles.count];
        [currentTitles addObject:title];
        NSLog(@"%@ %@",currentStudent.name,title.name);

    }
    CAChangeScoreViewController *changeScoreVC = [[CAChangeScoreViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changeScoreVC];
    changeScoreVC.student = currentStudent;
    changeScoreVC.titles = currentTitles;
    changeScoreVC.hashMap = [_hashMap mutableDeepCopy];

    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (void)refresh{
    [self clearOriginData];
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
        NSString *urlString = [kBASE_URL stringByAppendingString:@"point/display"];
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSArray *subjects = responseObject[@"subjects"];
            for (NSDictionary *dict in subjects) {
                CAPointModel *point = [[CAPointModel alloc] initWithDict:dict];
                [weakSelf.points addObject:point];
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //2.请求学生列表
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [kBASE_URL stringByAppendingString:@"student/display"];
        
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSArray *subjects = responseObject[@"subjects"];
            for (NSDictionary *dict in subjects) {
                CAStudentModel *student = [[CAStudentModel alloc] initWithDict:dict];
                [weakSelf.students addObject:student];
            }
            
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //3.请求分数项
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [kBASE_URL stringByAppendingString:@"title/display"];
        
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSArray *subjects = responseObject[@"subjects"];
            for (NSDictionary *dict in subjects) {
                CATitleModel *title = [[CATitleModel alloc] initWithDict:dict];
                [weakSelf.titles addObject:title];
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    dispatch_group_notify(group, queue, ^{
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
- (void)clearOriginData{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self.headTextsArray removeAllObjects];
    [self.students removeAllObjects];
    [self.points removeAllObjects];
    [self.titles removeAllObjects];
    [self.hashMap removeAllObjects];
    [_list removeAllObjects];
}
@end
