//
//  CAAddPointTitleViewController.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/3.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATitle.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAAddPointTitleViewController : UITableViewController

@property (nonatomic,strong)NSArray *students;
@property (nonatomic,strong)CATitle *pointTitle;
@property (nonatomic,strong)NSDictionary *hashMap;
@end

NS_ASSUME_NONNULL_END
