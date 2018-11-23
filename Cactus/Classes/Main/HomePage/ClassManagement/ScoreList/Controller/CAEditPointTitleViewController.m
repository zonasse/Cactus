//
//  CAEditPointTitleViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAEditPointTitleViewController.h"
#import "CAAddPointTitleCell.h"
#import "CAStudentModel.h"
#import "CAPointModel.h"
@interface CAEditPointTitleViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *modifiedPoints;
@property (nonatomic,strong) NSMutableArray *textFields;
@end
@implementation CAEditPointTitleViewController

- (NSMutableArray *)modifiedPoints{
    if (!_modifiedPoints) {
        _modifiedPoints = [NSMutableArray array];
    }
    return _modifiedPoints;
}

- (NSMutableArray *)textFields{
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑分数列";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [rightButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb29", 28, [UIColor whiteColor])] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb29", 28, [UIColor lightGrayColor])] forState:UIControlStateDisabled];
    
    [rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_btn_icon"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}
- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)save{
    [self.view endEditing:YES];
    [self.modifiedPoints removeAllObjects];
    NSString *newTitleName = nil;
    for (int i=0; i<self.textFields.count; ++i) {
        UITextField *currentTextField = self.textFields[i];
        if (i == 0) {
            if ([currentTextField.text isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入合适的分数列名称"];
                return;
            }else if(![currentTextField.text isEqualToString:self.pointTitle.name]){
                //检查是否重复
                for (CATitleModel *title in self.titles) {
                    if ([title.name isEqualToString:self.pointTitle.name]) {
                        continue;
                    }
                    if ([currentTextField.text isEqualToString:title.name]) {
                        [MBProgressHUD showError:@"分数列标题重复"];
                        return;
                    }
                }
                newTitleName = currentTextField.text;
            }
        }else{
            if ([currentTextField.text isEqualToString:@""]) {
                continue;
            }
            //判断分数是否相同
            CAStudentModel *currentStudent = self.students[i-1];

            NSString *student_id_str = [NSString stringWithFormat:@"%ld",currentStudent._id];
            NSString *title_id_str = [NSString stringWithFormat:@"%ld",self.pointTitle._id];
            CAPointModel *point = _hashMap[student_id_str][title_id_str];
            if([currentTextField.text isEqualToString:[NSString stringWithFormat:@"%ld",point.pointNumber]]){
                continue;
            }
            
            CAPointModel *newPoint = [point mutableCopy];
            newPoint.pointNumber = [currentTextField.text integerValue];
            [self.modifiedPoints addObject:newPoint];
        }
        
    }
    
    if (newTitleName == nil && self.modifiedPoints.count == 0) {
        [MBProgressHUD showError:@"暂无可提交的修改"];
        return;
    }
    [MBProgressHUD showMessage:@"修改提交中..."];
    
    NSString *titleModifiedUrlString = [kBASE_URL stringByAppendingString:@"title/format"];
    NSString *pointModifiedUrlString = [kBASE_URL stringByAppendingString:@"point/format"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"userToken"];
    params[@"token"] = token;
    
    if (self.modifiedPoints.count == 0) {
        //只更改列标题
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *subjects = [NSMutableArray array];
            [subjects addObject:@{@"id": [NSString stringWithFormat:@"%ld", self.pointTitle._id], @"name":newTitleName}];
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool PUTWithCompleteURL:titleModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                [MBProgressHUD hideHUD];
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"1043"]) {
                    [MBProgressHUD showError:@"分数列修改提交失败，请检查输入"];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showSuccess:@"分数列修改提交成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointModifySuccessNotification" object:nil];
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
    
                        }];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
        });
    }else if(newTitleName == nil){
        //只更改分数值
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *subjects = [NSMutableArray array];
            for (CAPointModel *point in self.modifiedPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"id"] = [NSString stringWithFormat:@"%ld",point._id];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber];
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool PUTWithCompleteURL:pointModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                [MBProgressHUD hideHUD];
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"1043"]) {
                    [MBProgressHUD showError:@"分数修改提交失败，请检查输入"];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showSuccess:@"分数修改提交成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointModifySuccessNotification" object:nil];
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
        });
    }else{
        //同时修改分数列和分数
        __block BOOL tag = YES;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        //修改分数列
        dispatch_group_async(group, queue, ^{
            NSMutableArray *subjects = [NSMutableArray array];
            [subjects addObject:@{@"id": [NSString stringWithFormat:@"%ld", self.pointTitle._id], @"name":newTitleName}];
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool PUTWithCompleteURL:titleModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"1043"]) {
                    tag = NO;
                }
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                tag = NO;
                dispatch_semaphore_signal(semaphore);
            }];
        });
        //修改分数值
        dispatch_group_async(group, queue, ^{
            NSMutableArray *subjects = [NSMutableArray array];
            for (CAPointModel *point in self.modifiedPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"id"] = [NSString stringWithFormat:@"%ld",point._id];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber];
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            [ShareDefaultHttpTool PUTWithCompleteURL:pointModifiedUrlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                if ([responseDict[@"code"] isEqualToString:@"1043"]) {
                    tag = NO;
                }
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                tag = NO;
                dispatch_semaphore_signal(semaphore);
            }];
        });
        dispatch_group_notify(group, queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (tag == YES) {
                    [MBProgressHUD showSuccess:@"分数修改提交成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pointModifySuccessNotification" object:nil];
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }else{
                    [MBProgressHUD showError:@"修改提交失败，请检查输入"];
                }
            });
        });
    }
    
}

#pragma mark - Table view data source
- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.students.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"pointTitleCell";
    //    CAAddPointTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        if (indexPath.section == 0) {
        //            cell.studentSidLabel.text = @"设置新的分数列";
        //        }else{
        //            CAStudent *student = self.students[indexPath.row];
        //            cell.studentSidLabel.text = student.sid;
        //            cell.studentNameLabel.text = student.name;
        //        }
        if (indexPath.section == 0) {
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, cell.height-10)];
            inputTextField.borderStyle = UITextBorderStyleRoundedRect;
            inputTextField.delegate = self;
            inputTextField.text = self.pointTitle.name;
            [self.textFields addObject:inputTextField];
            //            inputTextField.tag = -10;
            //            inputTextField.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:inputTextField];
        }else{
            UILabel *studentSidLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, cell.height-10)];
            UILabel *studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(studentSidLabel.getMaxX + 5, studentSidLabel.y, studentSidLabel.width, studentSidLabel.height)];
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-100-10, 5, 100, cell.height-10)];
            //            inputTextField.backgroundColor = [UIColor lightGrayColor];
            inputTextField.borderStyle = UITextBorderStyleRoundedRect;
            inputTextField.delegate = self;
            [self.textFields addObject:inputTextField];
            
            
            //            inputTextField.tag = indexPath.row;
            [cell.contentView addSubview:inputTextField];
            [cell.contentView addSubview:studentSidLabel];
            [cell.contentView addSubview:studentNameLabel];
            CAStudentModel *student = self.students[indexPath.row];
            studentSidLabel.text = student.sid;
            studentNameLabel.text = student.name;
            
            NSString *student_id_str = [NSString stringWithFormat:@"%ld",student._id];
            NSString *title_id_str = [NSString stringWithFormat:@"%ld",self.pointTitle._id];
            CAPointModel *point = _hashMap[student_id_str][title_id_str];
            inputTextField.text = [NSString stringWithFormat:@"%ld",point.pointNumber];
        }
    }
    
    return cell;
}


//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"输入新的分数列名";
    }else{
        return @"输入分数值";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark --textfield点击事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark --弹出键盘视图上移
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    const CGFloat INTERVAL_KEYBOARD = 60;
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIView * firstResponder = [UIResponder currentFirstResponder];
    UITextField *textField = (UITextField*)firstResponder;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (textField.frame.origin.y+textField.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset-20, self.view.frame.size.width, self.view.frame.size.height);
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

@end
