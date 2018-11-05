//
//  CAChangeScoreViewController.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/2.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAStudentModel.h"
#import "CATitleModel.h"
#import "CAPointModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAChangeScoreViewController : UITableViewController
@property (nonatomic,strong)CAStudentModel *student;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSDictionary *hashMap;
@end

NS_ASSUME_NONNULL_END
