//
//  CALessonViewCell.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CALessonViewCell.h"
@interface CALessonViewCell()
@property(nonatomic,strong) UIImageView *replaceContentView;
@property(nonatomic,strong) UILabel *lessonNameLabel;
@property(nonatomic,strong) UILabel *lessonClassLabel;
@property(nonatomic,strong) UIImageView *lessonImage;
@property(nonatomic,strong) UILabel *lessonStudentNumberLabel;
@property(nonatomic,strong) UILabel *lessonTimeLabel;
@property(nonatomic,strong) UILabel *lessonClassRoomLabel;
@end
@implementation CALessonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -- rebuild cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        /*
          * 设置替换视图
         */
        self.replaceContentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cellHeight)];
        self.replaceContentView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.replaceContentView];
        //课程图片
        self.lessonImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cellHeight-10, cellHeight-10)];
        [self.replaceContentView addSubview:self.lessonImage];
        //课程班名称
        self.lessonClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lessonImage.frame)+10, self.lessonImage.frame.origin.y, 120, 20)];
        self.lessonClassLabel.font = [UIFont systemFontOfSize:14];
        [self.replaceContentView addSubview:self.lessonClassLabel];
        //课程名称
        self.lessonNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lessonClassLabel.frame)+10, self.lessonImage.frame.origin.y, 100, 20)];
        [self.replaceContentView addSubview:self.lessonNameLabel];
        self.lessonNameLabel.font = [UIFont systemFontOfSize:12];

        //学生人数
        self.lessonStudentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lessonClassLabel.frame.origin.x, CGRectGetMaxY(self.lessonClassLabel.frame)+10, 100, 20)];
        self.lessonStudentNumberLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentView addSubview:self.lessonStudentNumberLabel];
        self.lessonStudentNumberLabel.font = [UIFont systemFontOfSize:12];

        //开课时间
        self.lessonTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lessonNameLabel.frame.origin.x, self.lessonStudentNumberLabel.frame.origin.y, 150, 20)];
        self.lessonTimeLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentView addSubview:self.lessonTimeLabel];
        self.lessonTimeLabel.font = [UIFont systemFontOfSize:12];

        //上课地点
        self.lessonClassRoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lessonClassLabel.frame.origin.x, CGRectGetMaxY(self.lessonStudentNumberLabel.frame)+5, 150, 34)];
        self.lessonClassRoomLabel.font = [UIFont systemFontOfSize:12];

        [self.replaceContentView addSubview:self.lessonClassRoomLabel];
    }
    return self;
}
#pragma mark --设置课程信息
-(void) setCellContentInformationWithLessonImage:(NSString *)lessonImage lessonClassName:(NSString*) lessonClassName lessonName:(NSString*)lessonName studentNumber:(NSInteger) studentNumber lessonTime:(NSString *)lessonTime classRoom:(NSString *)classRoom{
    
    [self.lessonImage sd_setImageWithURL:[NSURL URLWithString:lessonImage] placeholderImage:[UIImage imageNamed:@"课程占位"]];
    self.lessonClassLabel.text = lessonClassName;
    self.lessonNameLabel.text = lessonName;
    self.lessonStudentNumberLabel.text = [NSString stringWithFormat:@"学生人数: %ld",studentNumber];
    self.lessonTimeLabel.text = [NSString stringWithFormat:@"时间: %@",lessonTime];
    self.lessonClassRoomLabel.text = [NSString stringWithFormat:@"上课地点: %@",classRoom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
