//
//  CAHomePageView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/26.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAHomePageView.h"
#import "CAClassInfoViewCell.h"
#import "CATeacher.h"
#import "CAClassInfo.h"
@interface CAHomePageView()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UIView *teacherProfileView;
@property(strong, nonatomic) UITableView *classInfoTableView;

@property(strong, nonatomic)  UIImageView *userPic;//用户头像
@property(strong, nonatomic)  UILabel *usernameLabel;//用户姓名
@property(strong, nonatomic)  UILabel *userTidLabel;//用户职工号
@property(strong, nonatomic)  UILabel *userUniversityLabel;//用户所在学校
@property(strong, nonatomic)  UILabel *userCollegeLabel;//用户所在学院
@property(strong, nonatomic)  UIImageView *isManagerPic;//管理员标志图

@property(strong, nonatomic) CATeacher *teacher;
@property(strong, nonatomic) NSMutableArray *classInfos;
@end

@implementation CAHomePageView
- (NSMutableArray *)classInfos{
    if (!_classInfos) {
        _classInfos = [[NSMutableArray alloc] init];
    }
    return _classInfos;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setupSubViews];
    
}
#pragma mark ----设置内部子控件
- (void) setupSubViews{
    _teacherProfileView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.width-20, 230)];
    _classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10,_teacherProfileView.getMaxY + 10, _teacherProfileView.width, self.height - _teacherProfileView.height - 3*10) style:UITableViewStyleGrouped];
    _classInfoTableView.backgroundColor = [UIColor whiteColor];
    _classInfoTableView.delegate = self;
    _classInfoTableView.dataSource = self;

    
    _userPic = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-60, 10, 120, 120)];
    _userPic.layer.masksToBounds = YES;
    _userPic.layer.cornerRadius =_userPic.width / 2 ;
    
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userPic.x, _userPic.getMaxY+10, _userPic.width, 30)];
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    _userUniversityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _teacherProfileView.height-30, SCREEN_WIDTH/3, 30)];
    _userUniversityLabel.textAlignment = NSTextAlignmentCenter;

    _userCollegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userUniversityLabel.getMaxX, _userUniversityLabel.y, _userUniversityLabel.width, _userUniversityLabel.height)];
    _userCollegeLabel.textAlignment = NSTextAlignmentCenter;

    
    _userTidLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userCollegeLabel.getMaxX, _userCollegeLabel.y, _userCollegeLabel.width, _userCollegeLabel.height)];
    _userTidLabel.textAlignment = NSTextAlignmentCenter;
    
//    _isManagerPic = [[UIImageView alloc] initWithFrame:CGRectMake(_usernameLabel.x, _userCollegeLabel.getMaxY+10, 30, _usernameLabel.height)];

    
    [_teacherProfileView addSubview:_userPic];
    [_teacherProfileView addSubview:_usernameLabel];
    [_teacherProfileView addSubview:_userUniversityLabel];
    [_teacherProfileView addSubview:_userTidLabel];
    [_teacherProfileView addSubview:_userCollegeLabel];
//    [_teacherProfileView addSubview:_isManagerPic];
    
    [self addSubview:_teacherProfileView];
    [self addSubview:_classInfoTableView];
}


#pragma mark ----- set teacherProfileView data
- (void)setTeacherProfileData:(NSDictionary *)profileDictionary{
    _teacher = [[CATeacher alloc] initWithDict:profileDictionary];

    [self setTeacherProfileViewData];
}
- (void)setTeacherProfileViewData{
    [_userPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像占位"]];
    _usernameLabel.text = _teacher.name;
    _userTidLabel.text = _teacher.tid;
    _userCollegeLabel.text = [NSString stringWithFormat:@"外国语学院"];
    _userUniversityLabel.text = [NSString stringWithFormat:@"北京邮电大学"];
//    if (_teacher.is_manager) {
//        _isManagerPic.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec1d", 34, [UIColor orangeColor])];
//    }else{
//        _isManagerPic.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000ec1d", 34, [UIColor grayColor])];
//
//    }
}
#pragma mark ----- set lessonTableView data
- (void)setClassInfoData:(NSArray *)classInfoArray{
    for (NSDictionary *dict in classInfoArray) {
        CAClassInfo *classInfo = [CAClassInfo classInfoWithDict:dict];
        [self.classInfos addObject:classInfo];
    }
    [self.classInfoTableView reloadData];
}


#pragma mark ----tableview delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return classInfoCellHeight;
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
        CAClassInfo *currentClassInfo = self.classInfos[indexPath.row];
        [cell setCellContentInformationWithClassInfoImage:@"" classInfoName:currentClassInfo.name classInfoRoom:currentClassInfo.room];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CAClassInfo *currentClassInfo = self.classInfos[indexPath.row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%ld", currentClassInfo._id] forKey:@"currentClassInfo_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CAJumpToClassManagementViewControllerNotification" object:currentClassInfo];
    
}

@end
