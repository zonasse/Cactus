//
//  ScoreListCollectionCell.h
//  Cactus
//
//  Created by  zonasse on 2018/11/3.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLStudentModel.h"
#import "QLTitleModel.h"
#import "QLPointModel.h"
@interface QLScoreListCollectionCell : UICollectionViewCell
@property (nonatomic, strong) QLPointModel *point;
@property (nonatomic, strong) QLStudentModel *student;
@property (nonatomic, strong) QLTitleModel *title;
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;

@end
