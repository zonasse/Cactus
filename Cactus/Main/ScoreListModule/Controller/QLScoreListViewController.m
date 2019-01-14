//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "QLScoreListViewController.h"
#import "QLChangeScoreViewController.h"
#import "QLAddPointTitleViewController.h"
#import "QLDeletePointTitleViewController.h"
#import "QLEditPointTitleViewController.h"

#import "YCXMenu.h"
#import "QLPointModel.h"
#import "QLTitleModel.h"
#import "QLStudentModel.h"
#import "NSDictionary+QLDictionaryDeepCopy.h"
#import "NSString+QLExtension.h"
#import "QLScoreListCollectionCell.h"
#import "QLScoreListCollectionViewLayout.h"
@interface QLScoreListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UICollectionView *_collectionView;
    QLScoreListCollectionViewLayout *_collectionViewLayout;
    
    UIView *_scoreKeyboardView;
    UITextView *_scoreKeyboardTextView;
    UIButton *_scoreKeyboardConfirmButton;
    UIButton *_saveButton;
    QLScoreListCollectionCell *_selectedCell;
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

@implementation QLScoreListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //0.设置导航栏返回按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_btn_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //1.设置导航栏右上角button
    UIButton *crucifixButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [crucifixButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb31", 34, [UIColor whiteColor])] forState:UIControlStateNormal];
    [crucifixButton addTarget:self action:@selector(rightNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *crucifixItem = [[UIBarButtonItem alloc] initWithCustomView:crucifixButton];
    
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.hidden = YES;
    [_saveButton addTarget:self action:@selector(saveAllPointChanges) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:crucifixItem, saveItem, nil];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pointModifySuccessNotification" object:nil];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    _insertPoints = [NSMutableArray array];
    _modifiedPoints = [NSMutableArray array];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRightItemNotification" object:nil];

    if (!_firstAppear) {
        _firstAppear = YES;
        [self refresh];
    }
}
/**
 点击了导航栏左上角按钮
 */
- (void)leftNavigationItemClicked{
    [_scoreKeyboardTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftNavigationItemClickedNotification" object:nil];
}
#pragma mark - event response


/**
 设置表格
 */
- (void)setupExcelView{
    [_collectionView removeFromSuperview];
    [self.headTextsArray removeAllObjects];
    [_insertPoints removeAllObjects];
    [_modifiedPoints removeAllObjects];
    //1.设置表格表头标题
    [self.headTextsArray addObject:@"学号"];
    [self.headTextsArray addObject:@"姓名"];
    for (QLTitleModel *title in self.titles) {
        [_headTextsArray addObject:title.name];
    }
    
    _collectionViewLayout = [[QLScoreListCollectionViewLayout alloc] init];
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
    
    [_collectionView registerClass:[QLScoreListCollectionCell class] forCellWithReuseIdentifier:@"QuotationCell"];

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
- (void)saveAllPointChanges{
    _editingStatus = NO;
    [_scoreKeyboardTextView resignFirstResponder];
    [MBProgressHUD showMessage:@"分数修改提交中..."];

    __block BOOL flag = NO;
    NSString *pointModifiedUrlString = [kBASE_URL stringByAppendingString:@"point/format"];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    int semaphoreCount = (_modifiedPoints.count? 1:0)+(_insertPoints.count? 1:0);
    
    //更改分数
    if (_modifiedPoints.count != 0) {

        dispatch_group_async(group, queue, ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];

            NSMutableArray *subjects = [NSMutableArray array];
            for (QLPointModel *point in self->_modifiedPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"id"] = [NSString stringWithFormat:@"%ld",point._id];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber];
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool PUTWithCompleteURL:pointModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"2004"]) {

                }else{
                    flag = YES;
                    
                }

                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);

            }];
        });
    }
    
    //插入新分数
    if (_insertPoints.count != 0) {

        dispatch_group_async(group, queue, ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];

            
            NSMutableArray *subjects = [NSMutableArray array];
            for (QLPointModel *point in self->_insertPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber];
                dict[@"title_id"] = [NSString stringWithFormat:@"%ld",point.title_id];
                dict[@"student_id"] = [NSString stringWithFormat:@"%ld",point.student_id];
                dict[@"classInfo_id"] = [NSString stringWithFormat:@"%ld",point.classInfo_id];
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool POSTWithCompleteURL:pointModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"2004"]) {

                }else{
                    flag = YES;
                    
                }
                dispatch_semaphore_signal(semaphore);

            } failure:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);

            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        
        //两个请求对应两次信号等待
        for (int i=0; i<semaphoreCount; ++i) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if (!flag) {
                [MBProgressHUD showError:@"修改失败,请稍后重试"];
                return;
            }
            self->_saveButton.hidden = YES;
            [MBProgressHUD showSuccess:@"分数修改提交成功"];
            [self refresh];
            
        });
        
    });
}
/**
 增加分数列
 */
- (void)addTitle{
    
}


/**
 删除分数列
 */
- (void)deleteTitle{
    //跳转到删除分数列控制器
    QLDeletePointTitleViewController *deletePointTitleVC = [[QLDeletePointTitleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deletePointTitleVC];
    deletePointTitleVC.titles = [self.titles mutableCopy];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}




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
    params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", weakSelf.classInfo._id];
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
                    QLPointModel *point = [[QLPointModel alloc] initWithDict:dict];
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
                    QLStudentModel *student = [[QLStudentModel alloc] initWithDict:dict];
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
                    QLTitleModel *title = [[QLTitleModel alloc] initWithDict:dict];
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
                    for (QLStudentModel *student in self.students) {
                        NSMutableDictionary *inner = [NSMutableDictionary dictionary];
                        for (QLTitleModel *title in self.titles) {
                            for (QLPointModel *point in self.points) {
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
    
    QLScoreListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuotationCell" forIndexPath:indexPath];
 
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

        QLStudentModel *student = _students[indexPath.section-1];
        
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
                QLTitleModel *title = _titles[indexPath.row-2];

                NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];
                NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];

                QLPointModel *point = _hashMap[student_id_str][title_id_str];
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
    
    if(indexPath.section < 1 || indexPath.row < 2) return;
    if (_selectedCell) {
        _selectedCell.labelInfo.text = _scoreKeyboardTextView.text;
    }
    QLScoreListCollectionCell *cell = (QLScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _selectedCell = cell;
    [self createCommentsView];
    _scoreKeyboardTextView.text = cell.labelInfo.text;
    [_scoreKeyboardTextView becomeFirstResponder];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < 1 || indexPath.row < 2) return;

    if (!_editingStatus) {
        return;
    }
    QLScoreListCollectionCell *cell = (QLScoreListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //检查之前的分数输入是否合法,确定是否加入分数
    if ([_scoreKeyboardTextView.text isEqualToString:cell.labelInfo.text]) {
        return;
    }
    if (![NSString checkValidWithPointNumber:_scoreKeyboardTextView.text]) {
        return;
    }
    if (!cell.point) {
        QLPointModel *newPoint = [[QLPointModel alloc] init];
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        newPoint.classInfo_id = self.classInfo._id;
        newPoint.title_id = cell.title._id;
        newPoint.student_id = cell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        QLPointModel *newPoint = cell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }
    if (_modifiedPoints.count || _insertPoints.count) {
        _saveButton.hidden = NO;
    }else{
        _saveButton.hidden = YES;
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
//键盘确定按钮点击
- (void)confirmScore{
    _editingStatus = NO;
    [_scoreKeyboardTextView resignFirstResponder];
    if ([_scoreKeyboardTextView.text isEqualToString:_selectedCell.labelInfo.text]) {
        return;
    }
    _selectedCell.labelInfo.text = _scoreKeyboardTextView.text;
    if (!_selectedCell.point) {
        
        QLPointModel *newPoint = [[QLPointModel alloc] init];
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        newPoint.classInfo_id = self.classInfo._id;
        newPoint.title_id = _selectedCell.title._id;
        newPoint.student_id = _selectedCell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        
        QLPointModel *newPoint = _selectedCell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }
    if (_modifiedPoints.count || _insertPoints.count) {
        _saveButton.hidden = NO;
    }else{
        _saveButton.hidden = YES;
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
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
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
