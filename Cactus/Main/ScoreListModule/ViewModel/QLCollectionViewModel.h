//
//  QLCollectionViewModel.h
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/16.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLScoreListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLCollectionViewModel : NSObject
- (instancetype)initWithController:(UIViewController *)controller;

- (void)saveAllPointChanges;
- (void)addTitle;
- (void)closeKeyboard;
@end

NS_ASSUME_NONNULL_END
