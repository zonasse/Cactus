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
#import "CAEditPointTitleViewController.h"
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

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightNavigationItemClicked) name:@"rightNavigationItemClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchPointCell:) name:@"pointCellTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pointModifySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headTextClicked:) name:@"headTextClickedNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRightItemNotification" object:nil];

    if (!_firstAppear) {
        _firstAppear = YES;
        [self refresh];
        
    }
}
#pragma mark - event response


/**
 设置表格
 */
- (void)setupExcelView{
    //1.设置表格表头标题
    [self.headTextsArray addObject:@"学号"];
    [_headTextsArray addObject:@"姓名"];
    for (CATitleModel *title in self.titles) {
        [_headTextsArray addObject:title.name];
    }
    
    self.excelViewMode = [YWExcelViewMode new];
    _excelViewMode.headTexts = _headTextsArray;
    _excelViewMode.style = YWExcelViewStyleDefalut;
    _excelViewMode.defalutHeight = 40;
    //2.初始化excelView
    _excelView = [[YWExcelView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-44) mode:_excelViewMode];
    _excelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _excelView.dataSource = self;
    _excelView.delegate = self;
    _excelView.showBorder = YES;
    [self.view addSubview:_excelView];
    
    
    //3.表格左上角
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_excelView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 20)];
    menuLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    menuLabel.textColor = [UIColor redColor];
    menuLabel.font = [UIFont systemFontOfSize:13];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.text = _ctl;
    [self.view addSubview:menuLabel];
    
    //4.初始化hashMap
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
    
    //5.设置表格数据数组
    _list = [NSMutableArray array];
//    for (int i=0; i<10; ++i) {
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
//    }
    //6.重绘表格
    [_excelView reloadData];
    
}

/**
 点击了导航栏右上角按钮
 */
- (void)rightNavigationItemClicked{
    [YCXMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        
        NSMutableArray *items = [NSMutableArray array];
        YCXMenuItem *addTitleItem = [YCXMenuItem menuItem:@"增加分数列" image:nil target:self action:@selector(addTitle)];
        YCXMenuItem *deleteTitleItem = [YCXMenuItem menuItem:@"删除分数列" image:nil target:self action:@selector(deleteTitle)];
        YCXMenuItem *editTitleItem = [YCXMenuItem menuItem:@"编辑分数列" image:nil target:self action:@selector(editTitle)];
        [items addObject:addTitleItem];
        [items addObject:deleteTitleItem];
        [items addObject:editTitleItem];
        [YCXMenu setTintColor:kDefaultGreenColor];
        [YCXMenu setSelectedColor:kRGB(263, 161, 53)];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50,0, 50, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
    
}
/**
 增加分数列
 */
- (void)addTitle{
    //跳转到增加分数列控制器
    CAAddPointTitleViewController *addPointTitleVC = [[CAAddPointTitleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addPointTitleVC];
    addPointTitleVC.students = self.students;
    addPointTitleVC.hashMap = [_hashMap mutableDeepCopy];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


/**
 删除分数列
 */
- (void)deleteTitle{
    //跳转到删除分数列控制器
    CADeletePointTitleViewController *deletePointTitleVC = [[CADeletePointTitleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deletePointTitleVC];
    deletePointTitleVC.titles = [self.titles mutableCopy];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

/**
 编辑分数列
 */
- (void)editTitle{
    __unsafe_unretained typeof(self)weakSelf = self;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择要编辑的分数列" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (CATitleModel *title in self.titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到编辑分数列控制器
            CAEditPointTitleViewController *editPointTitleVC = [[CAEditPointTitleViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editPointTitleVC];
            
            editPointTitleVC.students = self.students;
            editPointTitleVC.titles = self.titles;
            editPointTitleVC.pointTitle = title;
            editPointTitleVC.hashMap = [weakSelf.hashMap mutableDeepCopy];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

/**
 刷新表格数据
 */
- (void)refresh{
    //1.清空表格数据
    [self clearOriginData];
    
    //同时请求分数、学生、列名数据
    [MBProgressHUD showMessage:@"教学班信息获取中..."];
    __block BOOL tag = YES;
    __unsafe_unretained typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //2.1请求分数数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"userToken"];
    params[@"token"] = token;
//            params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", weakSelf.classInfo._id];
    params[@"classInfo_id"] = @"1";
    
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [kBASE_URL stringByAppendingString:@"point/format"];
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:@"1041"]) {
                tag = NO;
            }else{
                NSArray *subjects = responseDict[@"subjects"];
                
                for (NSDictionary *dict in subjects) {
                    CAPointModel *point = [[CAPointModel alloc] initWithDict:dict];
                    [weakSelf.points addObject:point];
                }
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //2.2请求学生数据
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [kBASE_URL stringByAppendingString:@"student/format"];
        
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:@"1041"]) {
                tag = NO;
            }else{
                NSArray *subjects = responseDict[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    CAStudentModel *student = [[CAStudentModel alloc] initWithDict:dict];
                    [weakSelf.students addObject:student];
                }
            }
            
           
            
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            tag = NO;
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //2.3请求分数项数据
    dispatch_group_async(group, queue, ^{
        NSString *urlString = [kBASE_URL stringByAppendingString:@"title/format"];
        
        [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:@"1041"]) {
                tag = NO;
            }else{
                NSArray *subjects = responseObject[@"subjects"];
                for (NSDictionary *dict in subjects) {
                    CATitleModel *title = [[CATitleModel alloc] initWithDict:dict];
                    [weakSelf.titles addObject:title];
                }
            }
            
            
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            tag = NO;
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    //3.三个请求全部完成后执行
    dispatch_group_notify(group, queue, ^{
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                //刷新UI
                if (tag == YES) {
                    [self setupExcelView];
                }else{
                    [MBProgressHUD showError:@"教学信息获取失败"];
                }
            });
        });
    });
}

/**
 清空表格数据
 */
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
#pragma mark - delegete and datasource methods

#pragma mark -- excelView delegate/datasource
- (NSArray *)widthForItemOnExcelView:(YWExcelView *)excelView{
    NSMutableArray *widthArray = [NSMutableArray array];
    for (NSString *str in self.headTextsArray) {
        CGSize size = CGSizeMake(320,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGSize labelsize = [str boundingRectWithSize:size options:  NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
        [widthArray addObject:[NSNumber numberWithFloat:labelsize.width+60]];
    }
    return widthArray;
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

#pragma mark - getters and setters

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
#pragma mark - private

#pragma mark - notification methods

/**
 点击了表格中某个单元格
 */
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
    //跳转到更改分数控制器
    CAChangeScoreViewController *changeScoreVC = [[CAChangeScoreViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changeScoreVC];
    changeScoreVC.student = currentStudent;
    changeScoreVC.titles = currentTitles;
    changeScoreVC.hashMap = [_hashMap mutableDeepCopy];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

/**
 点击了标题列
 */
- (void)headTextClicked:(NSNotification *)noti{
    NSInteger headTextIndex = [noti.object integerValue];
    //跳转到编辑分数列控制器
    CAEditPointTitleViewController *editPointTitleVC = [[CAEditPointTitleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editPointTitleVC];
    
    editPointTitleVC.students = self.students;
    editPointTitleVC.titles = self.titles;
    editPointTitleVC.pointTitle = self.titles[headTextIndex];
    editPointTitleVC.hashMap = [self.hashMap mutableDeepCopy];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
@end
