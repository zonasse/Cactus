//
//  CAClassInfoViewCell.m
//  Cactus
//
//  Created by  zonasse on 2018/9/22.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLHomePageClassInfoCell.h"
@interface QLHomePageClassInfoCell()
///替换视图
@property (nonatomic,strong) UIImageView *replaceContentImageView;
///教学班图片
@property (nonatomic,strong) UIImageView *classInfoImageView;
///教学班名称文本
@property (nonatomic,strong) UILabel *classInfoNameLabel;
///教学班学生数量文本
@property (nonatomic,strong) UILabel *classInfoStudentNumberLabel;
///教学班上课时间文本
@property (nonatomic,strong) UILabel *classInfoTimeLabel;
///教学班上课地点文本
@property (nonatomic,strong) UILabel *classInfoRoomLabel;

@end

@implementation QLHomePageClassInfoCell

#pragma mark -- rebuild cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        __unsafe_unretained typeof(self) weakSelf = self;
        self.replaceContentImageView = [[UIImageView alloc] init];
        self.classInfoImageView = [[UIImageView alloc] init];
        self.classInfoNameLabel = [[UILabel alloc] init];
        self.classInfoStudentNumberLabel = [[UILabel alloc] init];
        self.classInfoTimeLabel = [[UILabel alloc] init];
        self.classInfoRoomLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.replaceContentImageView];
        [self.replaceContentImageView addSubview:_classInfoImageView];
        [self.replaceContentImageView addSubview:_classInfoNameLabel];
        [self.replaceContentImageView addSubview:_classInfoStudentNumberLabel];
        [self.replaceContentImageView addSubview:_classInfoTimeLabel];
        [self.replaceContentImageView addSubview:_classInfoRoomLabel];
        
        [self.replaceContentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
        //1.左边图片
        [self.classInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.replaceContentImageView.mas_left).with.offset(0);
            make.centerY.mas_equalTo(weakSelf.replaceContentImageView);
            make.height.width.mas_equalTo(weakSelf.replaceContentImageView.mas_height);
            
        }];
        
        
        //2.右边label
        [self.classInfoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.replaceContentImageView).offset(5);
            make.left.mas_equalTo(weakSelf.classInfoImageView.mas_right).with.offset(10);
            make.right.mas_equalTo(weakSelf.replaceContentImageView.mas_right).offset(-20);
            make.height.mas_equalTo(@34);
        }];
        
        [self.classInfoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.classInfoNameLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(weakSelf.classInfoNameLabel);
            make.right.mas_equalTo(weakSelf.classInfoRoomLabel.mas_left).offset(-10);
            make.height.mas_equalTo(@22);
        }];
        [self.classInfoRoomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.replaceContentImageView.mas_right).offset(-20);
            make.top.height.mas_equalTo(weakSelf.classInfoTimeLabel);
            make.width.mas_equalTo(@80);
        }];
        
        [self.classInfoStudentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.classInfoNameLabel);
            make.top.mas_equalTo(weakSelf.classInfoTimeLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(@22);
            make.width.mas_equalTo(@80);
        }];

        //3.设置控件属性
        self.classInfoNameLabel.font = [UIFont systemFontOfSize:16.0];
        self.classInfoStudentNumberLabel.font = [UIFont systemFontOfSize:12.0];
        self.classInfoRoomLabel.font = [UIFont systemFontOfSize:12.0];
        self.classInfoTimeLabel.font = [UIFont systemFontOfSize:12.0];
        
        self.classInfoNameLabel.textColor = kRGB(51, 51, 51);
        self.classInfoRoomLabel.textColor = kRGB(128, 128, 128);
        self.classInfoTimeLabel.textColor = kRGB(128, 128, 128);
        self.classInfoStudentNumberLabel.textColor = kRGB(128, 128, 128);

    }
    return self;
}
#pragma mark --设置课程信息
-(void) setCellContentInformationWithClassInfoImage:(NSString *)classInfoImage classInfoName:(NSString*) classInfoName classInfoRoom:(NSString *)classInfoRoom
                                      classInfoTime:(NSString *)classInfoTime classInfoStudentCount:(NSInteger) studentCount{
    [self.classInfoImageView sd_setImageWithURL:[NSURL URLWithString:@"https://source.unsplash.com/60x60/?art"] placeholderImage:[UIImage imageNamed:@"课程占位"]];
    self.classInfoNameLabel.text = classInfoName;
    self.classInfoRoomLabel.text = [NSString stringWithFormat:@"地点:%@" ,classInfoRoom];
//    self.classInfoTimeLabel.text = classInfoTime;
    self.classInfoTimeLabel.text = @"2018秋季4-18双周";

    self.classInfoStudentNumberLabel.text = [NSString stringWithFormat:@"学生人数：%ld",studentCount];
}

//- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 5;
//    frame.origin.y += 5;
//    frame.size.height -= 10;
//    frame.size.width -= 10;
//    [super setFrame:frame];
//}

@end
