//
//  UIResponder+CAFirstResponder.h
//  Cactus
//
//  Created by  zonasse on 2018/10/24.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (QLFirstResponder)
+ (id)currentFirstResponder;
@end

NS_ASSUME_NONNULL_END
