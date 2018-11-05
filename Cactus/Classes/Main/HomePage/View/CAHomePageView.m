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
///教学班信息数组
@property (strong, nonatomic) NSMutableArray *classInfos;
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _classInfos.count;
}

- (CAClassInfoViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"classInfoCell";
    CAClassInfoViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[CAClassInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CAClassInfoModel *currentClassInfo = self.classInfos[indexPath.row];
        [cell setCellContentInformationWithClassInfoImage:@"" classInfoName:currentClassInfo.name classInfoRoom:currentClassInfo.room];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CAClassInfoModel *currentClassInfo = self.classInfos[indexPath.row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%ld", currentClassInfo._id] forKey:@"currentClassInfo_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CAJumpToClassManagementViewControllerNotification" object:currentClassInfo];
    
}

#pragma mark - getters and setters

- (NSMutableArray *)classInfos{
    if (!_classInfos) {
        _classInfos = [[NSMutableArray alloc] init];
    }
    return _classInfos;
}
#pragma mark - private

/**
 设置内部子控件
 */
- (void) setupSubViews{
    _teacherProfileView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.width-20, 230)];
    _classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10,_teacherProfileView.getMaxY + 10, _teacherProfileView.width, self.height - _teacherProfileView.height - 3*10) style:UITableViewStyleGrouped];
    _classInfoTableView.backgroundColor = [UIColor whiteColor];
    _classInfoTableView.delegate = self;
    _classInfoTableView.dataSource = self;
    
    
    _teacherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*0.5-60, 10, 120, 120)];
    _teacherImageView.layer.masksToBounds = YES;
    _teacherImageView.layer.cornerRadius =_teacherImageView.width / 2 ;
    
    _teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_teacherImageView.x, _teacherImageView.getMaxY+10, _teacherImageView.width, 30)];
    _teacherNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _teacherUniversityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _teacherProfileView.height-30, kSCREEN_WIDTH/3, 30)];
    _teacherUniversityLabel.textAlignment = NSTextAlignmentCenter;
    
    _teacherCollegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_teacherUniversityLabel.getMaxX, _teacherUniversityLabel.y, _teacherUniversityLabel.width, _teacherUniversityLabel.height)];
    _teacherCollegeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _teacherTidLabel = [[UILabel alloc] initWithFrame:CGRectMake(_teacherCollegeLabel.getMaxX, _teacherCollegeLabel.y, _teacherCollegeLabel.width, _teacherCollegeLabel.height)];
    _teacherTidLabel.textAlignment = NSTextAlignmentCenter;
    
    //    _isManagerPic = [[UIImageView alloc] initWithFrame:CGRectMake(_usernameLabel.x, _userCollegeLabel.getMaxY+10, 30, _usernameLabel.height)];
    
    
    [_teacherProfileView addSubview:_teacherImageView];
    [_teacherProfileView addSubview:_teacherNameLabel];
    [_teacherProfileView addSubview:_teacherUniversityLabel];
    [_teacherProfileView addSubview:_teacherTidLabel];
    [_teacherProfileView addSubview:_teacherCollegeLabel];
    //    [_teacherProfileView addSubview:_isManagerPic];
    
    [self addSubview:_teacherProfileView];
    [self addSubview:_classInfoTableView];
}

/**
 设置教师信息
 */
- (void)setTeacherProfileData:(NSDictionary *)profileDictionary{
    _teacher = [[CATeacherModel alloc] initWithDict:profileDictionary];
    
    [self setTeacherProfileViewData];
}
- (void)setTeacherProfileViewData{
    [_teacherImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像占位"]];
    _teacherNameLabel.text = _teacher.name;
    _teacherTidLabel.text = _teacher.tid;
    _teacherCollegeLabel.text = [NSString stringWithFormat:@"外国语学院"];
    _teacherUniversityLabel.text = [NSString stringWithFormat:@"北京邮电大学"];
    //    if (_teacher.is_manager) {
    //        _isManagerPic.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec1d", 34, [UIColor orangeColor])];
    //    }else{
    //        _isManagerPic.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec1d", 34, [UIColor grayColor])];
    //
    //    }
}

/**
 设置教学班信息
 */
- (void)setClassInfoData:(NSArray *)classInfoArray{
    for (NSDictionary *dict in classInfoArray) {
        CAClassInfoModel *classInfo = [CAClassInfoModel classInfoWithDict:dict];
        [self.classInfos addObject:classInfo];
    }
    [self.classInfoTableView reloadData];
}

#pragma mark - notification methods


@end
