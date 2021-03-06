//
//  CAHomePageView.m
//  Cactus
//
//  Created by  zonasse on 2018/10/26.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import "QLHomePageProfileCell.h"
#import "QLHomePageClassInfoCell.h"
#import "QLTeacherModel.h"
#import "QLClassInfoModel.h"
@interface QLHomePageProfileCell()
///教师视图
@property (strong, nonatomic) UIView *teacherProfileView;
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

@end

@implementation QLHomePageProfileCell
#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
#pragma mark - event response

#pragma mark - delegete and datasource methods


#pragma mark - getters and setters
/**
 设置教学班信息
 */
//- (void)setClassInfoArray:(NSArray *)classInfoArray{
//    _classInfoArray = classInfoArray;
//    [self.classInfoTableView reloadData];
//}
#pragma mark - private

/**
 设置内部子控件
 */
- (void) setupSubViews{
    __unsafe_unretained typeof(self) weakSelf = self;
    _teacherProfileView = [[UIView alloc] init];
//    _classInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
//
//    _classInfoTableView.estimatedRowHeight = 0;
//    _classInfoTableView.estimatedSectionHeaderHeight = 0;
//    _classInfoTableView.estimatedSectionFooterHeight = 0;

    
    _teacherImageView = [[UIImageView alloc] init];
    _teacherNameLabel = [[UILabel alloc] init];
    _teacherUniversityLabel = [[UILabel alloc] init];
    _teacherCollegeLabel = [[UILabel alloc] init];
    _teacherTidLabel = [[UILabel alloc] init];
    
    
    [self.contentView addSubview:_teacherProfileView];
    [_teacherProfileView addSubview:_teacherImageView];
    [_teacherProfileView addSubview:_teacherNameLabel];
    [_teacherProfileView addSubview:_teacherUniversityLabel];
    [_teacherProfileView addSubview:_teacherTidLabel];
    [_teacherProfileView addSubview:_teacherCollegeLabel];
    
    
    [_teacherProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.top.mas_equalTo(self).with.offset(10);
//        make.width.mas_equalTo(self.mas_width).with.offset(20);
//        make.height.mas_equalTo(@210);
        make.left.top.right.bottom.mas_equalTo(self);
    }];
//    [_classInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.top.mas_equalTo(weakSelf.teacherProfileView.mas_bottom).with.offset(0);
//        make.width.mas_equalTo(weakSelf.teacherProfileView);
//        make.bottom.mas_equalTo(self);
//    }];
    
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
    

    [_teacherImageView layoutIfNeeded];
    _teacherImageView.layer.masksToBounds = YES;
    _teacherImageView.layer.cornerRadius =_teacherImageView.width / 2 ;
    
    _teacherNameLabel.textAlignment = NSTextAlignmentCenter;
    _teacherNameLabel.font = [UIFont systemFontOfSize:16.0];
    
    _teacherUniversityLabel.textAlignment = NSTextAlignmentCenter;
    _teacherUniversityLabel.font = [UIFont systemFontOfSize:12.0];
    _teacherUniversityLabel.textColor = [UIColor grayColor];
    
    _teacherCollegeLabel.textAlignment = NSTextAlignmentCenter;
    _teacherCollegeLabel.font = [UIFont systemFontOfSize:12.0];
    _teacherCollegeLabel.textColor = [UIColor grayColor];

    _teacherTidLabel.textAlignment = NSTextAlignmentCenter;
    _teacherTidLabel.font = [UIFont systemFontOfSize:12.0];
    _teacherTidLabel.textColor = [UIColor grayColor];

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




@end
