//
//  QLCollectionViewModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/16.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLCollectionViewModel.h"
#import "QLScoreListCollectionCell.h"
#import "QLScoreListCollectionViewLayout.h"

#import "SMAlert.h"
#import "QLTextView.h"

#import "QLPointModel.h"
#import "QLTitleModel.h"
#import "QLStudentModel.h"
#import "QLTitleGroupModel.h"
@interface QLCollectionViewModel()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    UICollectionView *_collectionView;
    QLScoreListCollectionViewLayout *_collectionViewLayout;
    QLScoreListCollectionCell *_selectedCell;

    
    
    UIView *_scoreKeyboardView;
    UITextView *_scoreKeyboardTextView;
    UIButton *_scoreKeyboardConfirmButton;
    CGFloat currentOffsetY;
    
    
    NSMutableArray *_modifiedPoints;
    NSMutableArray *_insertPoints;
    
    

    UIButton *titleGroupButton;
    QLTitleGroupModel *newTitleBelongToTitleGroup;
    SMButton *newTitleConfirmButton;
    UITextField *newTitleTextField;
}

///excel视图表头标题数组
@property (nonatomic,strong) NSMutableArray *headTextsArray;
///学生对象数组
@property (nonatomic,strong) NSMutableArray *students;
///分数对象数组
@property (nonatomic,strong) NSMutableArray *points;
///分数列对象数组
@property (nonatomic,strong) NSMutableArray *titles;
///分数大项数组
@property (nonatomic,strong) NSMutableArray *titleGroups;
///学生-分数-分数列字典
@property (nonatomic,strong) NSMutableDictionary *hashMap;
///全局编辑状态
@property (nonatomic,assign) BOOL editingStatus;

@property (nonatomic,weak) QLScoreListViewController *scoreListVC;

@end

@implementation QLCollectionViewModel
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.scoreListVC = (QLScoreListViewController *)controller;
        //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        //刷新数据
        [self refresh];
        
        self->_insertPoints = [NSMutableArray array];
        self->_modifiedPoints = [NSMutableArray array];
    }
    return self;
}

/**
 刷新表格数据
 */
- (void)refresh{
    
    
    //1.清空表格数据
    
    [self.students removeAllObjects];
    [self.points removeAllObjects];
    [self.titleGroups removeAllObjects];
    [self.titles removeAllObjects];
    
    [_collectionView removeFromSuperview];
    [self.headTextsArray removeAllObjects];
    [_insertPoints removeAllObjects];
    [_modifiedPoints removeAllObjects];
    
    //同时请求分数、学生、列名数据
    [MBProgressHUD showMessage:@"教学班信息获取中..."];
    __block BOOL tag = YES;
    __unsafe_unretained typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //2.1请求分数数据
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld", weakSelf.scoreListVC.classInfo._id];
    dispatch_group_async(group, queue, ^{
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_point_format parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
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
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_student_format parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
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
    //2.3请求分数列数据
    dispatch_group_async(group, queue, ^{
        
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_title_display parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
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
    //2.4请求分数大项数据
    dispatch_group_async(group, queue, ^{
        params[@"lesson_id"] = [NSString stringWithFormat:@"%ld", weakSelf.scoreListVC.classInfo.lesson_id];

        [ShareDefaultHttpTool GETWithCompleteURL:kURL_titleGroup_format parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
                tag = NO;
            }else{
                NSArray *subjects = responseObject[@"subjects"];
                
                for (NSDictionary *dict in subjects) {
                    QLTitleGroupModel *titleGroup = [[QLTitleGroupModel alloc] initWithDict:dict];
                    [weakSelf.titleGroups addObject:titleGroup];
                    
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
                    
                    [self setupCollectionView];
                }else{
                    [MBProgressHUD showError:@"教学信息获取失败"];
                }
            });
        });
    });
}

/**
 设置表格
 */

- (void)setupCollectionView{
    
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
    [self.scoreListVC.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreListVC.mas_topLayoutGuide);
        make.left.equalTo(self.scoreListVC.view);
        make.right.equalTo(self.scoreListVC.view);
        make.bottom.equalTo(self.scoreListVC.view);
    }];
    
    [_collectionView registerClass:[QLScoreListCollectionCell class] forCellWithReuseIdentifier:@"QuotationCell"];

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
        if (indexPath.row >= 2) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDeleteTitle:)];
            [cell addGestureRecognizer:longPress];
            cell.tag = indexPath.row-2;
        }
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
    //全选文字
    [_scoreKeyboardTextView performSelector:@selector(selectAll:) withObject:nil afterDelay:.0f];

}
//长按删除列
- (void)longPressToDeleteTitle:(UILongPressGestureRecognizer *)recognizer{
    self->_editingStatus = NO;
    __unsafe_unretained typeof(self) weakSelf = self;
    QLScoreListCollectionCell *currentCell = (QLScoreListCollectionCell*)recognizer.view;
    currentCell.labelInfo.textColor = kDefaultGreenColor;
    QLTitleModel *deleteTitle = self.titles[currentCell.tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"删除分数列 %@",deleteTitle.name] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showMessage:@"删除请求提交中"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSMutableArray *subjects = [NSMutableArray array];
            [subjects addObject:@{@"id":[NSString stringWithFormat:@"%ld",deleteTitle._id]}];
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool DELETEWithCompleteURL:kURL_title_format parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:k_status_delete_failed]) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"删除请求提交失败，请稍后重试"];
                }else{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [self.titles removeObject:deleteTitle];
                    [weakSelf->_headTextsArray removeAllObjects];
                    [weakSelf->_collectionView removeFromSuperview];
                    [self setupCollectionView];
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"分数列提交失败，请稍后重试"];
                
            }];
            
        });

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        currentCell.labelInfo.textColor = [UIColor blackColor];
    }]];
    [self.scoreListVC presentViewController:alert animated:YES completion:^{
        
    }];
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
        newPoint.classInfo_id = self.scoreListVC.classInfo._id;
        newPoint.title_id = cell.title._id;
        newPoint.student_id = cell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        QLPointModel *newPoint = cell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }
    if (_modifiedPoints.count || _insertPoints.count) {
        self.scoreListVC.saveButton.hidden = NO;
    }else{
        self.scoreListVC.saveButton.hidden = YES;
    }
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
- (NSMutableArray *)titleGroups{
    if (!_titleGroups) {
        _titleGroups = [NSMutableArray array];
    }
    return _titleGroups;
}
- (NSMutableArray *)headTextsArray{
    if (!_headTextsArray) {
        _headTextsArray = [NSMutableArray array];
    }
    return _headTextsArray;
}


- (void)createCommentsView {
    if (!_scoreKeyboardView) {
        _scoreKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kSCREEN_HEIGHT , kSCREEN_WIDTH, 48)];
        
        _scoreKeyboardView.backgroundColor = kRGB(212, 212, 212);
        
        _scoreKeyboardTextView = [[QLTextView alloc] initWithFrame:CGRectMake(5, 4, kSCREEN_WIDTH-10*2-60, _scoreKeyboardView.height-8)];
        
        _scoreKeyboardTextView.layer.borderColor   = [[UIColor whiteColor] CGColor];
        _scoreKeyboardTextView.layer.borderWidth   = 1.0;
        _scoreKeyboardTextView.layer.cornerRadius  = 2.0;
        _scoreKeyboardTextView.layer.masksToBounds = YES;
        _scoreKeyboardTextView.keyboardType = UIKeyboardTypeDecimalPad;
        _scoreKeyboardTextView.inputAccessoryView  = _scoreKeyboardView;
        _scoreKeyboardTextView.backgroundColor     = [UIColor whiteColor];
        _scoreKeyboardTextView.delegate            = self;
        _scoreKeyboardTextView.font                = [UIFont systemFontOfSize:15.0];
        [_scoreKeyboardView addSubview:_scoreKeyboardTextView];
        
        _scoreKeyboardConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-60-5, 4, 60, _scoreKeyboardTextView.height)];
        [_scoreKeyboardConfirmButton setBackgroundImage:[UIImage imageNamed:@"send_comment_btn_bg"] forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton setBackgroundImage:[UIImage imageNamed:@"small_btn_disable_bg"] forState:UIControlStateDisabled];
        [_scoreKeyboardConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_scoreKeyboardConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_scoreKeyboardConfirmButton addTarget:self action:@selector(confirmScore) forControlEvents:UIControlEventTouchUpInside];
        [_scoreKeyboardView addSubview:_scoreKeyboardConfirmButton];
        
        
    }
    if (!_editingStatus) {
        [self.scoreListVC.view.window addSubview:_scoreKeyboardView];//添加到window上或者其他视图也行，只要在视图以外就好了
        _editingStatus = YES;
    }
    
    [_scoreKeyboardTextView becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
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
    CGFloat offset = (firstResponder.frame.origin.y-currentOffsetY +firstResponder.frame.size.height+INTERVAL_KEYBOARD) - (self.scoreListVC.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.scoreListVC.view.frame = CGRectMake(0.0f, -offset, self.scoreListVC.view.frame.size.width, self.scoreListVC.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.scoreListVC.view.frame = CGRectMake(0, 64, self.scoreListVC.view.frame.size.width, self.scoreListVC.view.frame.size.height);
    }];
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
            self.scoreListVC.saveButton.hidden = YES;
            [MBProgressHUD showSuccess:@"分数修改提交成功"];
            [self refresh];
            
        });
        
    });
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
        newPoint.classInfo_id = self.scoreListVC.classInfo._id;
        newPoint.title_id = _selectedCell.title._id;
        newPoint.student_id = _selectedCell.student._id;
        [_insertPoints addObject:newPoint];
    }else{
        
        QLPointModel *newPoint = _selectedCell.point;
        newPoint.pointNumber = [_scoreKeyboardTextView.text integerValue];
        [_modifiedPoints addObject:newPoint];
    }
    if (_modifiedPoints.count || _insertPoints.count) {
        self.scoreListVC.saveButton.hidden = NO;
    }else{
        self.scoreListVC.saveButton.hidden = YES;
    }
}

/**
 增加分数列
 */
- (void)addTitle{
    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setConfirmBtTitleColor:kDefaultGreenColor];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor blackColor]];
    [SMAlert setAlertBackgroundColor:[UIColor blackColor]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 200)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(customView).offset(15);
        make.right.mas_equalTo(customView).offset(-15);
        make.top.mas_equalTo(customView).offset(20);
        make.height.mas_equalTo(@30);
    }];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [titleLabel setTextColor:[UIColor blackColor]];
    titleLabel.text = @"请输入分属列名:";
    
    UILabel *weightMessageLabel = [[UILabel alloc] init];
    [customView addSubview:weightMessageLabel];
    [weightMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
    }];
    weightMessageLabel.text = @"权重请在web端进行设置，此处默认为1";
    weightMessageLabel.textColor = [UIColor lightGrayColor];
    [weightMessageLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    newTitleTextField = [[UITextField alloc]init];
    [customView addSubview:newTitleTextField];
    [newTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(titleLabel);
        make.top.mas_equalTo(weightMessageLabel.mas_bottom).offset(10);
    }];
    newTitleTextField.layer.borderWidth = 1;
    newTitleTextField.layer.borderColor = kDefaultGreenColor.CGColor;
    newTitleTextField.font = [UIFont systemFontOfSize:16.0];
    [newTitleTextField setReturnKeyType:UIReturnKeyDone];
    newTitleTextField.delegate = self;
    newTitleTextField.tintColor = [UIColor blackColor];
    

    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,5,30)];
    leftView.backgroundColor = [UIColor clearColor];
    newTitleTextField.leftView = leftView;
    newTitleTextField.leftViewMode = UITextFieldViewModeAlways;
    newTitleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    UILabel *titleGroupLabel = [[UILabel alloc] init];
    [customView addSubview:titleGroupLabel];
    [titleGroupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self->newTitleTextField);
        make.width.mas_equalTo(@50);
        make.top.mas_equalTo(self->newTitleTextField.mas_bottom).offset(20);
    }];
    titleGroupLabel.text = @"大项:";
    [titleGroupLabel setFont:[UIFont systemFontOfSize:16.0]];

    titleGroupButton = [[UIButton alloc] init];
    [customView addSubview:titleGroupButton];
    [titleGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleGroupLabel.mas_right).offset(20);
        make.right.mas_equalTo(self->newTitleTextField);
        make.height.top.mas_equalTo(titleGroupLabel);
    }];
    [titleGroupButton setTitle:@"选择" forState:UIControlStateNormal];
    [titleGroupButton setBackgroundImage:[UIImage imageNamed:@"btn_enable_bg"] forState: UIControlStateNormal];
    [titleGroupButton.currentBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [titleGroupButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleGroupButton addTarget:self action:@selector(chooseTitleGroup) forControlEvents:UIControlEventTouchUpInside];

    newTitleConfirmButton = [SMButton initWithTitle:@"确定" clickAction:^{

        [MBProgressHUD showMessage:@"提交中..."];
        NSString *titleName = self->newTitleTextField.text;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //1.插入分数列
            NSString *urlString = [kBASE_URL stringByAppendingString:@"title/format"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *classInfo_id = [userDefaults valueForKey:k_classInfo_id_key];
            params[@"subjects"] = @[@{@"name":titleName,@"titleGroup_id":[NSString stringWithFormat:@"%ld",self->newTitleBelongToTitleGroup._id] ,@"classInfo_id":classInfo_id}];
            self->newTitleBelongToTitleGroup = nil;

            [ShareDefaultHttpTool POSTWithCompleteURL:urlString parameters:params progress:^(id progress) {

            } success:^(id responseObject) {
                [MBProgressHUD hideHUD];
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:k_status_post_failed]) {
                    [MBProgressHUD showError:@"分数列插入失败"];
                }else{
                    [self refresh];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"分数列插入失败"];
            }];
        });


    }];
    newTitleConfirmButton.enabled = NO;
    [newTitleConfirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [SMAlert showCustomView:customView confirmButton:newTitleConfirmButton cancleButton:[SMButton initWithTitle:@"取消" clickAction:^{
        self->newTitleBelongToTitleGroup = nil;
    }]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString checkValidWithChineseWord: textField.text] && self->newTitleBelongToTitleGroup) {
        self->newTitleConfirmButton.enabled = YES;
    }else{
        self->newTitleConfirmButton.enabled = NO;

    }
}
- (void)chooseTitleGroup{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择大项" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (QLTitleGroupModel *titleGroup in self.titleGroups) {
        [alert addAction:[UIAlertAction actionWithTitle:titleGroup.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->titleGroupButton setTitle:titleGroup.name forState:UIControlStateNormal];
            self->newTitleBelongToTitleGroup = titleGroup;
            if ([NSString checkValidWithNormalString: self->newTitleTextField.text] && self->newTitleBelongToTitleGroup) {
                self->newTitleConfirmButton.enabled = YES;
            }else{
                self->newTitleConfirmButton.enabled = NO;

            }
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [self.scoreListVC presentViewController:alert animated:YES completion:^{

    }];
}

- (void)closeKeyboard{
    [_scoreKeyboardTextView resignFirstResponder];
}
@end
