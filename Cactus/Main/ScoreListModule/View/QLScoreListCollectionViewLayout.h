//
//  ScoreListCollectionViewLayout.h
//  Cactus
//
//  Created by  zonasse on 2018/11/3.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLScoreListCollectionViewLayout : UICollectionViewLayout

@property (strong, nonatomic) NSMutableArray *itemAttributes; // 表格数据量发生变化时，需清空这个数组

@end
