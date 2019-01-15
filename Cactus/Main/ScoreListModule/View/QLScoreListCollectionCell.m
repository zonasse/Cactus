//
//  ScoreListCollectionCell.m
//  Cactus
//
//  Created by  zonasse on 2018/11/3.
//  Copyright © 2018  zonasse. All rights reserved.
//
#import "QLScoreListCollectionCell.h"
#import <Masonry.h>

@implementation QLScoreListCollectionCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
//        UIView *selectedView = [[UIView alloc] initWithFrame:self.bounds];
//        selectedView.backgroundColor = kDefaultGreenColor;
//        self.selectedBackgroundView = selectedView;
        
    }
    return self;
}

- (void)setup {
    _labelInfo = [[UILabel alloc] init];
    _labelInfo.font = [UIFont systemFontOfSize:15];
    _labelInfo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelInfo];
    [_labelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _rightLine = [[UIView alloc] init];
    _rightLine.backgroundColor = [UIColor redColor];
    [self addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.width.mas_equalTo(.5);
        make.right.mas_equalTo(-1);
        make.bottom.mas_equalTo(-7);
    }];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor greenColor];
    [self addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(.5);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.labelInfo.textColor = kDefaultGreenColor;
    }else{
        self.labelInfo.textColor = [UIColor blackColor];
    }
}
@end
