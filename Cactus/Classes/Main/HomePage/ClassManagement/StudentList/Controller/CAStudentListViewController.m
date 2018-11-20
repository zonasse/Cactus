//
//  CAStudentListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAStudentListViewController.h"
#import "ExcelView.h"
#import "CAStudentModel.h"
@interface CAStudentListViewController ()
@property (nonatomic,strong) ExcelView *excelView;
@property(nonatomic,strong) NSMutableArray *leftTableDataArray;//表格第一列数据
@property(nonatomic,strong) NSMutableArray *excelDataArray;//表格数据
@property(nonatomic,strong) NSMutableArray *rightTableHeadArray;//表格第一行表头数据
@property(nonatomic,strong) NSMutableArray *allTableDataArray;//表格所有数据
@property (nonatomic,assign) BOOL firstAppear;

@property (nonatomic,strong) NSMutableArray *students;
@end

@implementation CAStudentListViewController
#warning 懒加载必须使用self.xx才能调用
- (NSMutableArray *)students{
    if (!_students) {
        _students = [NSMutableArray array];
    }
    return _students;
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

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideRightItemNotification" object:nil];
    if (!_firstAppear) {
        _firstAppear = YES;
        /*
         * 请求学生列表数据
         */
        
        
        
        NSString *urlString = [kBASE_URL stringByAppendingString:@"student/display"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        params[@"token"] = token;
//        params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", self.classInfo._id ];
        params[@"classInfo_id"] = @"1";
        
        
        
        __unsafe_unretained typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [ShareDefaultHttpTool GETWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSArray *subjects = responseObject[@"subjects"];
                NSLog(@"%@",subjects);
                for (NSDictionary *dict in subjects) {
                    CAStudentModel *student = [[CAStudentModel alloc] initWithDict:dict];
                    [weakSelf.students addObject:student];
                }
                [self getScoreData];
            } failure:^(NSError *error) {
                
            }];
        });
        
    }
}

#pragma mark --设置表格
- (void)setupExcelView{
    _excelView=[[ExcelView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-44)];
    
    _excelView.isLockFristColumn=YES;
    _excelView.isLockFristRow=YES;
    _excelView.isColumnTitlte=YES;
    _excelView.columnTitlte=@"学生列表";
    _excelView.textFont = [UIFont systemFontOfSize:16.0];
//    [_excelView show];
    [self.view addSubview:_excelView];
}
#pragma mark --获取分数数据
- (void)getScoreData{
    NSArray *headTitles = @[@"id",@"学号",@"姓名",@"学年",@"专业id"];
    [self.allTableDataArray addObject:headTitles];
    for (int i=0; i<10; ++i) {
        for (CAStudentModel *student in _students) {
            NSMutableArray *rowArray = [NSMutableArray array];
            [rowArray addObject:[NSString stringWithFormat:@"%ld", student._id]];
            [rowArray addObject:student.sid];
            [rowArray addObject:student.name];
            [rowArray addObject:student.year];
            [rowArray addObject:[NSString stringWithFormat:@"%ld", student.major_id]];
            [_allTableDataArray addObject:rowArray];
        }
    }
    
    
    _excelView.allTableDatas = _allTableDataArray;

//    _excelView.topTableHeadDatas=self.rightTableHeadArray;
//    _excelView.leftTabHeadDatas=self.leftTableDataArray;
//    _excelView.tableDatas=self.excelDataArray;
    [_excelView show];
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
