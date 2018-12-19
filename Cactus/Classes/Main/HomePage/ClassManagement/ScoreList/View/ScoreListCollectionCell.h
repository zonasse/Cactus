//
//  ScoreListCollectionCell.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAStudentModel.h"
#import "CATitleModel.h"
#import "CAPointModel.h"
@interface ScoreListCollectionCell : UICollectionViewCell
@property (nonatomic, strong) CAPointModel *point;
@property (nonatomic, strong) CAStudentModel *student;
@property (nonatomic, strong) CATitleModel *title;
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;

@end
