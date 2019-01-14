//
//  CAEditPointTitleViewController.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/5.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTitleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLEditPointTitleViewController : UITableViewController

@property (nonatomic,strong)NSArray *students;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)QLTitleModel *pointTitle;
@property (nonatomic,strong)NSDictionary *hashMap;
@end

NS_ASSUME_NONNULL_END
