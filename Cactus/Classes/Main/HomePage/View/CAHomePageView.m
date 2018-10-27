//
//  CAHomePageView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/26.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAHomePageView.h"
#import "CATeacher.h"
@interface CAHomePageView()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UIView *teacherProfileView;
@property(strong, nonatomic) UITableView *classInfoTableView;

@property(strong, nonatomic)  UIImageView *userPic;//用户头像
@property(strong, nonatomic)  UILabel *usernameLabel;//用户姓名
@property(strong, nonatomic)  UILabel *userTidLabel;//用户职工号
@property(strong, nonatomic)  UILabel *userCollegeLabel;//用户所在学院
@property(strong, nonatomic)  UIImageView *isManagerPic;//管理员标志图

@property(strong, nonatomic) CATeacher *teacher;
@property(strong, nonatomic) NSMutableArray *classInfos;
@end

@implementation CAHomePageView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setupSubViews];
    
}
#pragma mark ----设置内部子控件
- (void) setupSubViews{
    _teacherProfileView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 200)];
    _classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10,_teacherProfileView.getMaxY + 10, _teacherProfileView.width, self.height - _teacherProfileView.height - 3*10)];
    _teacherProfileView.backgroundColor = [UIColor redColor];
    _classInfoTableView.backgroundColor = [UIColor greenColor];
    
    _userPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 150, _teacherProfileView.height - 2*10)];
    
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userPic.getMaxX + 10, 10, _teacherProfileView.width - 10*3 - _userPic.width, 30)];
    
    _userTidLabel = [[UILabel alloc] initWithFrame:CGRectMake(_usernameLabel.x, _usernameLabel.getMaxY+10, _usernameLabel.width, _usernameLabel.height)];
    
    _userCollegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_usernameLabel.x, _userTidLabel.getMaxY+10, _usernameLabel.width, _usernameLabel.height)];
    
    _isManagerPic = [[UIImageView alloc] initWithFrame:CGRectMake(_usernameLabel.x, _userCollegeLabel.getMaxY+10, 30, _usernameLabel.height)];

    
    [_teacherProfileView addSubview:_userPic];
    [_teacherProfileView addSubview:_usernameLabel];
    [_teacherProfileView addSubview:_userTidLabel];
    [_teacherProfileView addSubview:_userCollegeLabel];
    [_teacherProfileView addSubview:_isManagerPic];
    
    [self addSubview:_teacherProfileView];
    [self addSubview:_classInfoTableView];
}
#pragma mark ----tableview delegate and datasource


#pragma mark ----- set teacherProfileView data
- (void)setTeacherProfileData:(NSDictionary *)profileDictionary{
    _teacher = [[CATeacher alloc] initWithDict:profileDictionary];
}
#pragma mark ----- set lessonTableView data
- (void)setClassInfoData:(NSArray *)classInfoArray{
    
}






@end
