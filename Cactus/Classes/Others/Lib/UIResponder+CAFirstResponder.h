//
//  UIResponder+CAFirstResponder.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/24.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (CAFirstResponder)
+ (id)currentFirstResponder;
@end

NS_ASSUME_NONNULL_END
