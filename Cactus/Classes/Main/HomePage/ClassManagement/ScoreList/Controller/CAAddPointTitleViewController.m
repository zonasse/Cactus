//
//  CAAddPointTitleViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAAddPointTitleViewController.h"
#import "CAAddPointTitleCell.h"
#import "CAStudent.h"
@interface CAAddPointTitleViewController ()
@property (nonatomic,strong) NSMutableArray *modifiedPoints;
@end

@implementation CAAddPointTitleViewController

- (NSMutableArray *)modifiedPoints{
    if (!_modifiedPoints) {
        _modifiedPoints = [NSMutableArray array];
    }
    return _modifiedPoints;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑分数列";
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
    
}

#pragma mark - Table view data source

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
        cell.backgroundColor = [UIColor lightGrayColor];
//        if (indexPath.section == 0) {
//            cell.studentSidLabel.text = @"设置新的分数列";
//        }else{
//            CAStudent *student = self.students[indexPath.row];
//            cell.studentSidLabel.text = student.sid;
//            cell.studentNameLabel.text = student.name;
//        }
        if (indexPath.section == 0) {
            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, cell.height-10)];
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(cell.width-100-10, 5, 100, cell.height-10)];
            [cell.contentView addSubview:inputTextField];
            [cell.contentView addSubview:descLabel];
                descLabel.text = @"输入新的分数列名:";
        }else{
            UILabel *studentSidLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, cell.height-10)];
            UILabel *studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(studentSidLabel.getMaxX + 5, studentSidLabel.y, studentSidLabel.width, studentSidLabel.height)];
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(cell.width-100-10, 5, 100, cell.height-10)];
            [cell.contentView addSubview:inputTextField];
            [cell.contentView addSubview:studentSidLabel];
            [cell.contentView addSubview:studentNameLabel];
            CAStudent *student = self.students[indexPath.row];
            studentSidLabel.text = student.sid;
            studentNameLabel.text = student.name;
        }
    }
    
    return cell;
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
