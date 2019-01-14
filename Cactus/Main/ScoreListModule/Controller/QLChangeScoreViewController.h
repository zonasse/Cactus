//
//  CAChangeScoreViewController.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/2.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLStudentModel.h"
#import "QLTitleModel.h"
#import "QLPointModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLChangeScoreViewController : UITableViewController
///学生对象
@property (nonatomic,strong) QLStudentModel *student;
///分数列数组
@property (nonatomic,strong) NSArray *titles;
///学生-分数列-分数字典
@property (nonatomic,strong) NSDictionary *hashMap;
@end

NS_ASSUME_NONNULL_END
