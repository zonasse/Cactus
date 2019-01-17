//
//  QLStudentListViewModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/17.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLStudentListViewModel.h"
#import "QLStudentListViewController.h"

#import "QLScoreListCollectionCell.h"
#import "QLScoreListCollectionViewLayout.h"

#import "QLStudentModel.h"
#import "QLMajorModel.h"
@interface QLStudentListViewModel()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    UICollectionView *_collectionView;
    QLScoreListCollectionViewLayout *_collectionViewLayout;
}
@property (nonatomic,weak) QLStudentListViewController *studentListVC;
@property (nonatomic,strong) NSMutableArray *students;
@property (nonatomic,strong) NSMutableArray *headTextsArray;

@end

@implementation QLStudentListViewModel
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.studentListVC = (QLStudentListViewController*) controller;
        //刷新数据
        [self refresh];
    }
    return self;
}
- (void)refresh{
    /*
     * 请求学生列表数据
     */
    [self.students removeAllObjects];
    [MBProgressHUD showMessage:@"学生信息获取中..."];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"classInfo_id"] = [NSString stringWithFormat:@"%ld",self.studentListVC.classInfo._id];

    __unsafe_unretained typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ShareDefaultHttpTool GETWithCompleteURL:kURL_student_display parameters:params progress:^(id progress) {

        } success:^(id responseObject) {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"code"] isEqualToString:k_status_get_failed]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"学生数据为空"];
            }else{
                [MBProgressHUD hideHUD];
                NSArray *subjects = responseDict[@"subjects"];
                NSLog(@"%@",subjects);
                for (NSDictionary *dict in subjects) {
                    QLStudentModel *student = [[QLStudentModel alloc] initWithDict:dict];
                    [weakSelf.students addObject:student];
                }
                [self setupCollectionView];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误"];

        }];
    });


}

/**
 设置表格
 */

- (void)setupCollectionView{
    
    //1.设置表格表头标题
    
    [self.headTextsArray addObject:@"学号"];
    [_headTextsArray addObject:@"姓名"];
    [_headTextsArray addObject:@"学年"];
    [_headTextsArray addObject:@"专业"];


    
    _collectionViewLayout = [[QLScoreListCollectionViewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.bounces = NO;
    _collectionView.directionalLockEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.studentListVC.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentListVC.mas_topLayoutGuide);
        make.left.equalTo(self.studentListVC.view);
        make.right.equalTo(self.studentListVC.view);
        make.bottom.equalTo(self.studentListVC.view);
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
            case 2:{
                cell.labelInfo.text = student.year;
            }
                break;
            case 3:{
                cell.labelInfo.text = student.major.name;
            }
                break;
            default:{
               
            }
                break;
        }
    }
    return cell;
}

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

@end
