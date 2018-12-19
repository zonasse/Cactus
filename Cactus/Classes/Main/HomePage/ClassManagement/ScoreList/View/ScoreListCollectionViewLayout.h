//
//  ScoreListCollectionViewLayout.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreListCollectionViewLayout : UICollectionViewLayout

@property (strong, nonatomic) NSMutableArray *itemAttributes; // 表格数据量发生变化时，需清空这个数组

@end
