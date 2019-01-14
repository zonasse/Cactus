//
//  CAAddPointTitleCell.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "QLAddPointTitleCell.h"
@interface QLAddPointTitleCell()

@end

@implementation QLAddPointTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark -- rebuild cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //学号
        self.studentSidLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,80,self.height-10)];
        [self.contentView addSubview:self.studentSidLabel];
        
        //姓名
        self.studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.studentSidLabel.getMaxX + 5,self.studentSidLabel.y,self.studentSidLabel.width,_studentSidLabel.height)];
        [self.contentView addSubview:self.studentNameLabel];
        
        //输入框
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.width-110, self.studentNameLabel.y, 100, self.studentNameLabel.height)];
        [self.contentView addSubview:self.inputTextField];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
