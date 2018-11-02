//
//  CAChangeScoreViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/2.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAChangeScoreViewController.h"

@interface CAChangeScoreViewController ()
@property (nonatomic,strong) NSMutableArray *modifiedPoints;
@property (nonatomic,strong) UITextField *pointTextField;
@property (nonatomic,strong) UIAlertAction *saveAction;
@end

@implementation CAChangeScoreViewController

- (NSMutableArray *)modifiedPoints{
    if (!_modifiedPoints) {
        _modifiedPoints = [NSMutableArray array];
    }
    return _modifiedPoints;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改成绩";
    NSLog(@"%@",self.hashMap);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [rightButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb29", 34, [UIColor orangeColor])] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [leftButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb2c", 34, [UIColor orangeColor])] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)save{
    if (self.modifiedPoints.count == 0) {
        [MBProgressHUD showError:@"没有待提交的修改"];
        return;
    }
    [MBProgressHUD showMessage:@"修改中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"userToken"];
        params[@"token"] = token;
        
        NSString *urlString = [baseURL stringByAppendingString:@"point/format"];
        NSMutableArray *subjects = [NSMutableArray array];
        for (CAPoint *point in self.modifiedPoints) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"pointNumber"] = [NSString stringWithFormat:@"%ld",point.pointNumber ];
            dict[@"student_id"] = [NSString stringWithFormat:@"%ld",point.student_id];
            dict[@"title_id"] = [NSString stringWithFormat:@"%ld",point.title_id];
            [subjects addObject:dict];
        }
        params[@"subjects"] = subjects;

        [ShareDefaultHttpTool PUTWithCompleteURL:urlString parameters:params progress:^(id progress) {
            
        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            [MBProgressHUD hideHUD];

            if([responseDict[@"code"] isEqualToString:@"1033"]){
                [MBProgressHUD showSuccess:@"修改成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pointModefySuccessNotification" object:nil];

                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
            }else{
                [MBProgressHUD showError:@"修改失败，请稍后重试"];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];

        }];
    });

}
#pragma mark - Table view data source

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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"学生姓名";
            cell.detailTextLabel.text = self.student.name;
        }else{
            cell.textLabel.text = @"学号";
            cell.detailTextLabel.text = self.student.sid;
        }
    }else{
        CATitle *title = self.titles[indexPath.row];
        NSString *student_id_str = [NSString stringWithFormat:@"%ld",_student._id];
        NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
        CAPoint *point = _hashMap[student_id_str][title_id_str];
        cell.textLabel.text = title.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",point.pointNumber];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        CATitle *title = self.titles[indexPath.row];
        NSString *student_id_str = [NSString stringWithFormat:@"%ld",_student._id];
        NSString *title_id_str = [NSString stringWithFormat:@"%ld",title._id];
        CAPoint *point = _hashMap[student_id_str][title_id_str];
        /*
         * 弹出分数修改提示框
         */
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@的成绩",title.name] message:[NSString stringWithFormat:@"原成绩为%ld",point.pointNumber] preferredStyle:UIAlertControllerStyleAlert];
        //创建提示按钮
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        _saveAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 检测输入是否合法或者相同
            UITextField *textField = alertController.textFields[0];
            point.pointNumber = [textField.text integerValue];
            [self.modifiedPoints addObject:point];
            
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
// 监听文字改变的方法
- (void)textFieldDidChange:(UITextField *)textField {
    
    if (_pointTextField.text.length > 0) {
        _saveAction.enabled = YES;
    } else {
        _saveAction.enabled = NO;
    }
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

@end
