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
//#import "YWExcelView.h"
#import "YCXMenu.h"
#import "CAPointModel.h"
#import "CATitleModel.h"
#import "CAStudentModel.h"
#import "NSDictionary+CADictionaryDeepCopy.h"
#import "NSString+CAExtension.h"
#import "ScoreListCollectionCell.h"
#import "ScoreListCollectionViewLayout.h"
@interface CAScoreListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UICollectionView *_collectionView;
    ScoreListCollectionViewLayout *_collectionViewLayout;
    
    UIView *_scoreKeyboardView;
    UITextView *_scoreKeyboardTextView;
    UIButton *_scoreKeyboardConfirmButton;
    
    ScoreListCollectionCell *_selectedCell;
    CGFloat currentOffsetY;
    
    
    NSMutableArray *_modifiedPoints;
    NSMutableArray *_insertPoints;
}

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
///控制器首次出现
@property (nonatomic,assign) BOOL firstAppear;
///全局编辑状态
@property (nonatomic,assign) BOOL editingStatus;
@end

@implementation CAScoreListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightNavigationItemClicked) name:@"rightNavigationItemClickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pointModifySuccessNotification" object:nil];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-100, 20, 40, 44)];
    [self.view.window addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
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
    [_collectionView removeFromSuperview];
    [self.headTextsArray removeAllObjects];
    //1.设置表格表头标题
    [self.headTextsArray addObject:@"学号"];
    [self.headTextsArray addObject:@"姓名"];
    for (CATitleModel *title in self.titles) {
        [_headTextsArray addObject:title.name];
    }
    
    _collectionViewLayout = [[ScoreListCollectionViewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.bounces = NO;
    _collectionView.directionalLockEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.delaysContentTouches = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [_collectionView registerClass:[ScoreListCollectionCell class] forCellWithReuseIdentifier:@"QuotationCell"];

    
    //5.设置表格数据数组
//    _list = [NSMutableArray array];
//        for (CAStudentModel *student in self.students) {
//            NSMutableArray *rowArray = [NSMutableArray array];
//            [rowArray addObject:student.sid];
//            [rowArray addObject:student.name];
//            for (CATitleModel *title in self.titles) {
//                //                BOOL flag = NO;
//                NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];
//                NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
//                CAPointModel *point = _hashMap[student_id_str][title_id_str];
//                if (point.pointNumber) {
//                    [rowArray addObject:[NSString stringWithFormat:@"%ld",point.pointNumber]];
//                }else{
//                    [rowArray addObject:@""];
//                }
//            }
//            [_list addObject:rowArray];
//        }
    //6.重绘表格
//    [_excelView reloadData];
    
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
        [items addObject:addTitleItem];
        [items addObject:deleteTitleItem];
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
//- (void)addTitle{
//    //跳转到增加分数列控制器
//    CAAddPointTitleViewController *addPointTitleVC = [[CAAddPointTitleViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addPointTitleVC];
//    addPointTitleVC.students = self.students;
//    addPointTitleVC.hashMap = [_hashMap mutableDeepCopy];
//
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}


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
//- (void)editTitle{
//    __unsafe_unretained typeof(self)weakSelf = self;
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择要编辑的分数列" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    for (CATitleModel *title in self.titles) {
//        UIAlertAction *action = [UIAlertAction actionWithTitle:title.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //跳转到编辑分数列控制器
//            CAEditPointTitleViewController *editPointTitleVC = [[CAEditPointTitleViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editPointTitleVC];
//
//            editPointTitleVC.students = self.students;
//            editPointTitleVC.titles = self.titles;
//            editPointTitleVC.pointTitle = title;
//            editPointTitleVC.hashMap = [weakSelf.hashMap mutableDeepCopy];
//            [self presentViewController:nav animated:YES completion:^{
//
//            }];
//        }];
//        [alert addAction:action];
//    }
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:^{
//
//    }];
//}

/**
 刷新表格数据
 */
- (void)refresh{
    
    
    //1.清空表格数据
//    [self clearOriginData];
    
    //同时请求分数、学生、列名数据
    [MBProgressHUD showMessage:@"教学班信息获取中..."];
    __block BOOL tag = YES;
    __unsafe_unretained typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //2.1请求分数数据
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [userDefaults valueForKey:@"userToken"];
//    params[@"token"] = token;
    params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", weakSelf.classInfo._id];
//    params[@"classInfo_id"] = @"1";
    
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
                    //初始化hashMap
                    weakSelf.hashMap = [NSMutableDictionary dictionary];
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
                        
                        [weakSelf.hashMap setValue:inner forKey:student_id_str];
                    }

                    [self setupExcelView];
                }else{
                    [MBProgressHUD showError:@"教学信息获取失败"];
                }
            });
        });
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.students.count+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.headTextsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScoreListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuotationCell" forIndexPath:indexPath];
 
    if (self.headTextsArray.count == 0) {
        return cell;
    }
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.labelInfo.textColor = [UIColor blackColor];
        cell.rightLine.hidden = NO;
        
        cell.labelInfo.text = self.headTextsArray[indexPath.row];

    } else {
        cell.rightLine.hidden = NO;

        CAStudentModel *student = _students[indexPath.section-1];
        
        switch (indexPath.row) {
            case 0:{
                cell.backgroundColor = [UIColor whiteColor];
                cell.labelInfo.text = student.sid;
                
            }
            break;
            case 1:{
                cell.labelInfo.text = student.name;
            }
            break;
            default:{
                CATitleModel *title = _titles[indexPath.row-2];

                NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];
                NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];

                CAPointModel *point = _hashMap[student_id_str][title_id_str];
                cell.labelInfo.text = [NSString stringWithFormat:@"%ld",point.pointNumber];
                cell.point = point;
                cell.title = title;
                cell.student = student;
            }
                break;
        }
    }
    return cell;
}
//单击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScoreListCollectionCell *cell = (ScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _selectedCell = cell;
    [self createCommentsView];
    _scoreKeyboardTextView.text = cell.labelInfo.text;
    [_scoreKeyboardTextView becomeFirstResponder];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (!_editingStatus) {
        return;
    }
    ScoreListCollectionCell *cell = (ScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //检查之前的分数输入是否合法,确定是否加入分数
    if ([_scoreKeyboardTextView.text isEqualToString:cell.labelInfo.text]) {
        return;
    }
    if (!cell.point) {
        if (!_insertPoints) {
            _insertPoints = [NSMutableArray array];
        }
        CAPointModel *newPoint = [[CAPointModel alloc] init];
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        newPoint.classInfo_id = self.classInfo._id;
        newPoint.title_id = cell.title._id;
        newPoint.student_id = cell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        if (!_modifiedPoints) {
            _modifiedPoints = [NSMutableArray array];
        }
        CAPointModel *newPoint = cell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }

}
////高亮
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"进入高亮状态");
//
//    ScoreListCollectionCell *cell = (ScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [self createCommentsView];
//    [_scoreKeyboardTextView becomeFirstResponder];
//}
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    ScoreListCollectionCell *cell = (ScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [_scoreKeyboardTextView resignFirstResponder];
//    NSLog(@"取消高亮");
//}
- (void)createCommentsView {
    if (!_scoreKeyboardView) {
        _scoreKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kSCREEN_HEIGHT , kSCREEN_WIDTH, 44)];

        _scoreKeyboardView.backgroundColor = [UIColor whiteColor];
        
        _scoreKeyboardTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 2, kSCREEN_WIDTH-10*2-60, _scoreKeyboardView.height-4)];

        _scoreKeyboardTextView.layer.borderColor   = [kRGB(212.0, 212.0, 212.0) CGColor];
        _scoreKeyboardTextView.layer.borderWidth   = 1.0;
        _scoreKeyboardTextView.layer.cornerRadius  = 2.0;
        _scoreKeyboardTextView.layer.masksToBounds = YES;
        _scoreKeyboardTextView.keyboardType = UIKeyboardTypeNumberPad;
        _scoreKeyboardTextView.inputAccessoryView  = _scoreKeyboardView;
        _scoreKeyboardTextView.backgroundColor     = [UIColor clearColor];
//        _scoreKeyboardTextView.returnKeyType       = UIReturnKeySend;
        _scoreKeyboardTextView.delegate            = self;
        _scoreKeyboardTextView.font                = [UIFont systemFontOfSize:15.0];
        [_scoreKeyboardView addSubview:_scoreKeyboardTextView];
        
        _scoreKeyboardConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-60-5, 2, 60, _scoreKeyboardTextView.height)];
        [_scoreKeyboardConfirmButton setBackgroundImage:[UIImage imageNamed:@"send_comment_btn_bg"] forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton setBackgroundImage:[UIImage imageNamed:@"small_btn_disable_bg"] forState:UIControlStateDisabled];
        [_scoreKeyboardConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

        [_scoreKeyboardConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton addTarget:self action:@selector(confirmScore) forControlEvents:UIControlEventTouchUpInside];
        [_scoreKeyboardView addSubview:_scoreKeyboardConfirmButton];
        

    }
    if (!_editingStatus) {
        [self.view.window addSubview:_scoreKeyboardView];//添加到window上或者其他视图也行，只要在视图以外就好了
        _editingStatus = YES;
    }

    [_scoreKeyboardTextView becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}
//提交分数修改

- (void)confirmScore{
    _editingStatus = NO;
    [_scoreKeyboardTextView resignFirstResponder];
    if ([_scoreKeyboardTextView.text isEqualToString:_selectedCell.labelInfo.text]) {
        return;
    }
    if (!_selectedCell.point) {
        if (!_insertPoints) {
            _insertPoints = [NSMutableArray array];
        }
        CAPointModel *newPoint = [[CAPointModel alloc] init];
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        newPoint.classInfo_id = self.classInfo._id;
        newPoint.title_id = _selectedCell.title._id;
        newPoint.student_id = _selectedCell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        if (!_modifiedPoints) {
            _modifiedPoints = [NSMutableArray array];
        }
        CAPointModel *newPoint = _selectedCell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }
    
}
//重写此方法，解决了部分cell无法点击的问题
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"%f",targetContentOffset->y);
    currentOffsetY = targetContentOffset->y;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([NSString checkValidWithPointNumber:textView.text] ) {
        _scoreKeyboardConfirmButton.enabled = YES;
    }else{
        _scoreKeyboardConfirmButton.enabled = NO;
    }
}
#pragma mark --弹出键盘视图上移
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    const CGFloat INTERVAL_KEYBOARD = 60;
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    UIView * firstResponder = [UIResponder currentFirstResponder];
    UIView * firstResponder = _selectedCell;
    
//    UITextField *textField = (UITextField*)firstResponder;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (firstResponder.frame.origin.y-currentOffsetY +firstResponder.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


#pragma mark - delegete and datasource methods

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
//- (void)touchPointCell:(NSNotification*) noti{
//    NSArray *labels = noti.object;
//    CAStudentModel *currentStudent;
//    NSMutableArray *currentTitles = [NSMutableArray array];
//    for (UILabel *label in labels) {
//        if (label.tag == -1) {
//            continue;
//        }
//        currentStudent = self.students[label.tag/self.titles.count];
//        CATitleModel *title = self.titles[label.tag%self.titles.count];
//        [currentTitles addObject:title];
//        NSLog(@"%@ %@",currentStudent.name,title.name);
//
//    }
//    //跳转到更改分数控制器
//    CAChangeScoreViewController *changeScoreVC = [[CAChangeScoreViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changeScoreVC];
//    changeScoreVC.student = currentStudent;
//    changeScoreVC.titles = currentTitles;
//    changeScoreVC.hashMap = [_hashMap mutableDeepCopy];
//
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}

/**
 点击了标题列
 */
//- (void)headTextClicked:(NSNotification *)noti{
//    NSInteger headTextIndex = [noti.object integerValue];
//    //跳转到编辑分数列控制器
//    CAEditPointTitleViewController *editPointTitleVC = [[CAEditPointTitleViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editPointTitleVC];
//
//    editPointTitleVC.students = self.students;
//    editPointTitleVC.titles = self.titles;
//    editPointTitleVC.pointTitle = self.titles[headTextIndex];
//    editPointTitleVC.hashMap = [self.hashMap mutableDeepCopy];
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}
@end
