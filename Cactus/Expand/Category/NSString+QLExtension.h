//
//  NSString+CAExtension.h
//  Cactus
//
//  Created by  zonasse on 2018/11/22.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QLExtension)
+ (BOOL)checkValidWithNormalString:(NSString *) str;
+ (BOOL)checkValidWithStrongPassword:(NSString *) str;
+ (BOOL)checkValidWithPointNumber:(NSString *) str;
+ (BOOL)checkValidWithChineseWord:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
