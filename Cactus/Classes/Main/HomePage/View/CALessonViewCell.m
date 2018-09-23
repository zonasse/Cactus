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
@property(nonatomic,strong) UILabel *lessonName;
@property(nonatomic,strong) UIImageView *lessonImage;
@end
@implementation CALessonViewCell

#define cellHeight 64
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark -- set lesson data
-(void)setLessonData:(NSString *)lessonData{
    
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
        
        self.lessonImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, cellHeight-10)];
        self.lessonImage.backgroundColor = [UIColor greenColor];
        [self.replaceContentView addSubview:self.lessonImage];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
