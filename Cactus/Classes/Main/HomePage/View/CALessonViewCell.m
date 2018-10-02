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
@property(nonatomic,strong) UILabel *lessonLabel;
@property(nonatomic,strong) UILabel *lessonClassLabel;
@property(nonatomic,strong) UIImageView *lessonImage;
@property(nonatomic,strong) UILabel *lessonStudentNumberLabel;
@property(nonatomic,strong) UILabel *lessonTimeLabel;
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
        self.replaceContentView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:self.replaceContentView];
        //课程图片
        self.lessonImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cellHeight-10, cellHeight-10)];
        self.lessonImage.backgroundColor = [UIColor greenColor];
        [self.replaceContentView addSubview:self.lessonImage];
        //课程班名称
        self.lessonClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lessonImage.frame)+10, self.lessonImage.frame.origin.y, 100, 20)];
        [self.replaceContentView addSubview:self.lessonClassLabel];
        //课程名称
        self.lessonLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lessonClassLabel.frame)+10, self.lessonImage.frame.origin.y, 100, 20)];
        [self.replaceContentView addSubview:self.lessonClassLabel];
        //学生人数
        self.lessonStudentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lessonClassLabel.frame.origin.x, CGRectGetMaxY(self.lessonClassLabel.frame)+10, 50, 20)];
        self.lessonStudentNumberLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentView addSubview:self.lessonStudentNumberLabel];
        //开课时间
        self.lessonTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lessonLabel.frame.origin.x, self.lessonStudentNumberLabel.frame.origin.y, 50, 20)];
        self.lessonTimeLabel.textColor = [UIColor lightGrayColor];
        [self.replaceContentView addSubview:self.lessonTimeLabel];
    }
    return self;
}
#pragma mark --设置课程信息
-(void) setCellContentInformationWithLessonImage:(NSString *)lessonImage lessonClassName:(NSString*) lessonClassName lessonName:(NSString*)lessonName studentNumber:(NSInteger) studentNumber lessonTime:(NSString *)lessonTime{
    
    [self.lessonImage sd_setImageWithURL:[NSURL URLWithString:lessonImage] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    self.lessonClassLabel.text = lessonClassName;
    self.lessonLabel.text = lessonName;
    self.lessonStudentNumberLabel.text = [NSString stringWithFormat:@"学生人数: %ld",studentNumber];
    self.lessonTimeLabel.text = [NSString stringWithFormat:@"开课时间: %@",lessonTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
