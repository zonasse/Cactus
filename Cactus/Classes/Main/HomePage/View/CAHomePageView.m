//
//  CAHomePageView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/26.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAHomePageView.h"
#import "CAClassInfoViewCell.h"
#import "CATeacherModel.h"
#import "CAClassInfoModel.h"
@interface CAHomePageView()<UITableViewDelegate,UITableViewDataSource>
///教师视图
@property (strong, nonatomic) UIView *teacherProfileView;
///教学班列表
@property (strong, nonatomic) UITableView *classInfoTableView;
///教师头像
@property (strong, nonatomic)  UIImageView *teacherImageView;
///教师姓名文本
@property (strong, nonatomic)  UILabel *teacherNameLabel;//
///教师工号文本
@property (strong, nonatomic)  UILabel *teacherTidLabel;
///教师学校文本
@property (strong, nonatomic)  UILabel *teacherUniversityLabel;
///教师学院文本
@property (strong, nonatomic)  UILabel *teacherCollegeLabel;
///管理员图像
@property (strong, nonatomic)  UIImageView *isManagerImageView;
///教师对象
@property (strong, nonatomic) CATeacherModel *teacher;

@end

@implementation CAHomePageView
#pragma mark - life cycle

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setupSubViews];
    
}
#pragma mark - event response

#pragma mark - delegete and datasource methods

#pragma mark ----tableview delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _classInfoArray.count;
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    return view;
}

- (CAClassInfoViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"classInfoCell";
    CAClassInfoViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[CAClassInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dict = self.classInfoArray[indexPath.row];
        NSDictionary *dict = self.classInfoArray[0];

        [cell setCellContentInformationWithClassInfoImage:@"" classInfoName:dict[@"name"] classInfoRoom:dict[@"room"] classInfoTime:dict[@"date"] classInfoStudentCount:[dict[@"student_count"] integerValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 选中cell后立马取消选中，达到点击cell的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.classInfoArray[indexPath.row];
    CAClassInfoModel *classInfo = [[CAClassInfoModel alloc] initWithDict:dict];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%ld", classInfo._id] forKey:@"currentClassInfo_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CAJumpToClassManagementViewControllerNotification" object:classInfo];
    
}

#pragma mark - getters and setters
/**
 设置教学班信息
 */
- (void)setClassInfoArray:(NSArray *)classInfoArray{
    _classInfoArray = classInfoArray;
    [self.classInfoTableView reloadData];
}
#pragma mark - private

/**
 设置内部子控件
 */
- (void) setupSubViews{
    __unsafe_unretained typeof(self) weakSelf = self;
    _teacherProfileView = [[UIView alloc] init];
    _classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    _classInfoTableView.estimatedRowHeight = 0;
    _classInfoTableView.estimatedSectionHeaderHeight = 0;
    _classInfoTableView.estimatedSectionFooterHeight = 0;

    
    _teacherImageView = [[UIImageView alloc] init];
    _teacherNameLabel = [[UILabel alloc] init];
    _teacherUniversityLabel = [[UILabel alloc] init];
    _teacherCollegeLabel = [[UILabel alloc] init];
    _teacherTidLabel = [[UILabel alloc] init];
    
    
    [self addSubview:_teacherProfileView];
    [self addSubview:_classInfoTableView];
    [_teacherProfileView addSubview:_teacherImageView];
    [_teacherProfileView addSubview:_teacherNameLabel];
    [_teacherProfileView addSubview:_teacherUniversityLabel];
    [_teacherProfileView addSubview:_teacherTidLabel];
    [_teacherProfileView addSubview:_teacherCollegeLabel];
    //    [_teacherProfileView addSubview:_isManagerPic];
    
    
    [_teacherProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).with.offset(10);
        make.width.mas_equalTo(self.mas_width).with.offset(20);
        make.height.mas_equalTo(@210);
    }];
    [_classInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(weakSelf.teacherProfileView.mas_bottom).with.offset(0);
        make.width.mas_equalTo(weakSelf.teacherProfileView);
        make.bottom.mas_equalTo(self);
    }];
    
    [_teacherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(weakSelf.teacherProfileView).with.offset(10);
        make.width.height.mas_equalTo(120);
    }];
    
    [_teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(weakSelf.teacherImageView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@30);
    }];
    
     NSMutableArray *horizontalArray = [NSMutableArray array];
    [horizontalArray addObject:_teacherUniversityLabel];
    [horizontalArray addObject:_teacherCollegeLabel];
    [horizontalArray addObject:_teacherTidLabel];
    
    [horizontalArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2.0 leadSpacing:10 tailSpacing:10];
    [horizontalArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.teacherNameLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(30);
    }];
    
    _classInfoTableView.delegate = self;
    _classInfoTableView.dataSource = self;
    _classInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 5)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _classInfoTableView.tableHeaderView = tableHeaderView;

    [_teacherImageView layoutIfNeeded];
    _teacherImageView.layer.masksToBounds = YES;
    _teacherImageView.layer.cornerRadius =_teacherImageView.width / 2 ;
    
    _teacherNameLabel.textAlignment = NSTextAlignmentCenter;
    _teacherUniversityLabel.textAlignment = NSTextAlignmentCenter;
    _teacherCollegeLabel.textAlignment = NSTextAlignmentCenter;
    _teacherTidLabel.textAlignment = NSTextAlignmentCenter;
    
}

/**
 设置教师信息
 */
- (void) setTeacherName:(NSString *)teacherName tid:(NSString *)tid universityName:(NSString *)universityName collegeName:(NSString *) collegeName{
    
    [_teacherImageView sd_setImageWithURL:[NSURL URLWithString:@"https://source.unsplash.com/300x300/?program"] placeholderImage:[UIImage imageNamed:@"头像占位"]];
    _teacherNameLabel.text = teacherName;
    _teacherTidLabel.text = tid;
    _teacherCollegeLabel.text = collegeName;
    _teacherUniversityLabel.text = universityName;

}




#pragma mark - notification methods


@end
