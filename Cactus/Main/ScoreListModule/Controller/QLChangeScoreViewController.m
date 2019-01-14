//
//  CAChangeScoreViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/2.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "QLChangeScoreViewController.h"

@interface QLChangeScoreViewController ()
///更改过的分数值
@property (nonatomic,strong) NSMutableArray *modifiedPoints;
///新插入的分数值
@property (nonatomic,strong) NSMutableArray *insertPoints;

///提示框输入框
@property (nonatomic,strong) UITextField *pointTextField;
///保存按钮
@property (nonatomic,strong) UIAlertAction *saveAction;

@end

@implementation QLChangeScoreViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改成绩";
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
#pragma mark - event response

- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)save{
    if (self.modifiedPoints.count == 0 && self.insertPoints.count == 0) {
        [MBProgressHUD showError:@"没有待提交的修改"];
        return;
    }
    [MBProgressHUD showMessage:@"修改中..."];
    __block BOOL flag = NO;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [userDefaults valueForKey:@"userToken"];
    NSString *urlString = [kBASE_URL stringByAppendingString:@"point/format"];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (self.modifiedPoints.count != 0) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            params[@"token"] = token;
            
            NSMutableArray *subjects = [NSMutableArray array];
            for (QLPointModel *point in self.modifiedPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"id"] = [NSString stringWithFormat:@"%ld",point._id];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber ];
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            
            [ShareDefaultHttpTool PUTWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                [MBProgressHUD hideHUD];
                
                if([responseDict[@"code"] isEqualToString:@"1033"]){
                  
                }else{
                    flag = YES;
                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
            }];
        });
    }
    if (self.insertPoints.count != 0) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            params[@"token"] = token;
            
            NSMutableArray *subjects = [NSMutableArray array];
            for (QLPointModel *point in self.insertPoints) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber ];
                dict[@"student_id"] = [NSString stringWithFormat:@"%ld",point.student_id];
                dict[@"title_id"] = [NSString stringWithFormat:@"%ld",point.title_id];
                dict[@"classInfo_id"] = [NSString stringWithFormat:@"%ld",point.classInfo_id];
                
                [subjects addObject:dict];
            }
            params[@"subjects"] = subjects;
            
            [ShareDefaultHttpTool POSTWithCompleteURL:urlString parameters:params progress:^(id progress) {
                
            } success:^(id responseObject) {
                NSDictionary *responseDict = responseObject;
                [MBProgressHUD hideHUD];
                
                if([responseDict[@"code"] isEqualToString:@"1033"]){
                    
                }else{
                    flag = YES;
                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                dispatch_group_leave(group);

            }];
        });
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!flag) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"修改失败"];
                return;
            }
            [MBProgressHUD showSuccess:@"分数修改提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pointModifySuccessNotification" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    });
        
    
    
    
}
#pragma mark - delegete and datasource methods

#pragma mark -- table view delegate/datasource
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    return [super initWithStyle:UITableViewStyleGrouped];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return self.titles.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"changeScoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kRGB(51, 51, 51);
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"学生姓名";
            cell.detailTextLabel.text = self.student.name;
        }else{
            cell.textLabel.text = @"学号";
            cell.detailTextLabel.text = self.student.sid;
        }
    }else{
        QLTitleModel *title = self.titles[indexPath.row];
        NSString *student_id_str = [NSString stringWithFormat:@"%ld",_student._id];
        NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
        QLPointModel *point = _hashMap[student_id_str][title_id_str];
        cell.textLabel.text = title.name;
        if (point == nil) {
            cell.detailTextLabel.text = @"";
            for (QLPointModel *insertPoint in self.insertPoints) {
                if (insertPoint.title_id == title._id) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",insertPoint.pointNumber];
                }
            }
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",point.pointNumber];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        QLTitleModel *title = self.titles[indexPath.row];
        NSString *student_id_str = [NSString stringWithFormat:@"%ld",_student._id];
        NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
#warning point可能不存在
        BOOL pointExists = YES;
        QLPointModel *point = _hashMap[student_id_str][title_id_str];
        if (point == nil) {
            pointExists = NO;
        }
        /*
         * 弹出分数修改提示框
         */
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@的成绩",title.name] message: pointExists ? [NSString stringWithFormat: @"原成绩为%ld",point.pointNumber] : @"当前成绩为空" preferredStyle:UIAlertControllerStyleAlert];
        //创建提示按钮
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        _saveAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 检测输入是否合法或者相同
            UITextField *textField = alertController.textFields[0];
            if (pointExists) {
                point.pointNumber = [textField.text integerValue];
                [self.modifiedPoints addObject:point];
            }else{
                //检查是否为再次更改新分数
                BOOL insertNew = YES;
                for (QLPointModel *insertPoint in self.insertPoints) {
                    if (insertPoint.title_id == title._id) {
                        insertPoint.pointNumber = [textField.text integerValue];
                        insertNew = NO;
                        break;
                    }
                }
                if (insertNew) {
                    QLPointModel *newPoint = [[QLPointModel alloc] init];
                    newPoint.pointNumber = [textField.text integerValue];
                    newPoint.title_id = title._id;
                    newPoint.student_id = self.student._id;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    newPoint.classInfo_id = [[defaults valueForKey:@"currentClassInfo_id"] integerValue];
                    [self.insertPoints addObject:newPoint];
                }
            }
            [self.tableView reloadData];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:_saveAction];
        //添加文本框(只适合alertview类型的提示框)
        __unsafe_unretained typeof(self) weakSelf = self;
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"新成绩";
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            weakSelf.pointTextField = textField;
        }];
        if (_pointTextField.text.length > 0) {
            _saveAction.enabled = YES;
        } else {
            _saveAction.enabled = NO;
        }
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}
/**
 监听文字改变
 */
- (void)textFieldDidChange:(UITextField *)textField {
    
    if (_pointTextField.text.length > 0 && [NSString checkValidWithPointNumber:textField.text]) {
        _saveAction.enabled = YES;
    } else {
        _saveAction.enabled = NO;
    }
}


#pragma mark - getters and setters

- (NSMutableArray *)modifiedPoints{
    if (!_modifiedPoints) {
        _modifiedPoints = [NSMutableArray array];
    }
    return _modifiedPoints;
}
- (NSMutableArray *)insertPoints{
    if (!_insertPoints) {
        _insertPoints = [NSMutableArray array];
    }
    return _insertPoints;
}
#pragma mark - private

#pragma mark - notification methods
@end
