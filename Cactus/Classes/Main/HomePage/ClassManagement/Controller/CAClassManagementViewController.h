//
//  CAClassManagementViewController.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  课程管理主页

#import <UIKit/UIKit.h>
#import "CAClassInfo.h"
@interface CAClassManagementViewController : UITabBarController
@property(nonatomic,strong) CAClassInfo *classInfo;
@end
