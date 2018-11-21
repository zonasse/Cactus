//
//  CAStudentListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAStudentListViewController.h"
#import "YWExcelView.h"
#import "CAStudentModel.h"
#import "CAMajorModel.h"
@interface CAStudentListViewController ()<YWExcelViewDelegate,YWExcelViewDataSource>
///excel视图
@property (nonatomic,strong) YWExcelView *excelView;
///excel视图模式
@property (nonatomic,strong) YWExcelViewMode *excelViewMode;
///excel视图表头标题数组
@property (nonatomic,strong) NSMutableArray *headTextsArray;
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

- (NSMutableArray *)headTextsArray{
    if (!_headTextsArray) {
        _headTextsArray = [NSMutableArray array];
    }
    return _headTextsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
                [self setupExcelView];
            } failure:^(NSError *error) {
                
            }];
        });
        
    }
}

#pragma mark --设置表格
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return self.students.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 4;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    
    CAStudentModel *student = self.students[indexPath.row];
    label.textColor = kRGB(51, 51, 51);
    label.textAlignment = NSTextAlignmentCenter;
    switch (indexPath.item) {
        case 0:
            label.text = student.sid;
            break;
            
        case 1:
            label.text = student.name;
            break;
            
        case 2:
            label.text = student.year;
            break;
            
        case 3:
            label.text = student.major.name;
            break;
        default:
            break;
    }
}

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
- (void)setupExcelView{
    
    //1.设置表格表头标题
    [self.headTextsArray addObject:@"学号"];
    [_headTextsArray addObject:@"姓名"];
    [_headTextsArray addObject:@"学年"];
    [_headTextsArray addObject:@"专业"];
    
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
    
    [_excelView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
