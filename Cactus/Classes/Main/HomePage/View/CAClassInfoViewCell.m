//
//  CAClassInfoViewCell.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAClassInfoViewCell.h"
@interface CAClassInfoViewCell()
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

@implementation CAClassInfoViewCell

#pragma mark -- rebuild cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //设置替换视图
        static int classInfoCellHeight = 88;
        self.replaceContentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, classInfoCellHeight)];
        self.replaceContentImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.replaceContentImageView];
        //教学班图片
        self.classInfoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, classInfoCellHeight-20, classInfoCellHeight-20)];
        [self.replaceContentImageView addSubview:self.classInfoImageView];
        //教学班班名称
        self.classInfoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.classInfoImageView.getMaxX+5, self.classInfoImageView.y, 120, 34)];
        self.classInfoNameLabel.font = [UIFont systemFontOfSize:12];
        [self.replaceContentImageView addSubview:self.classInfoNameLabel];

        //学生人数
        self.classInfoStudentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-120, self.classInfoNameLabel.y, 120, 34)];
        self.classInfoStudentNumberLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentImageView addSubview:self.classInfoStudentNumberLabel];
        self.classInfoStudentNumberLabel.font = [UIFont systemFontOfSize:12];

        //开课时间
        self.classInfoTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.classInfoNameLabel.x, self.classInfoNameLabel.getMaxY, 120, 34)];
        self.classInfoTimeLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentImageView addSubview:self.classInfoTimeLabel];
        self.classInfoTimeLabel.font = [UIFont systemFontOfSize:12];

        //上课地点
        self.classInfoRoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.classInfoStudentNumberLabel.x, self.classInfoTimeLabel.y, 120, 34)];
        self.classInfoRoomLabel.font = [UIFont systemFontOfSize:12];

        [self.replaceContentImageView addSubview:self.classInfoRoomLabel];
    }
    return self;
}
#pragma mark --设置课程信息
-(void) setCellContentInformationWithClassInfoImage:(NSString *)classInfoImage classInfoName:(NSString*) classInfoName classInfoRoom:(NSString *)classInfoRoom{
    [self.classInfoImageView sd_setImageWithURL:[NSURL URLWithString:classInfoImage] placeholderImage:[UIImage imageNamed:@"课程占位"]];
    self.classInfoNameLabel.text = classInfoName;
    self.classInfoRoomLabel.text = classInfoRoom;
    self.classInfoStudentNumberLabel.text = @"学生人数：55";
}


@end
