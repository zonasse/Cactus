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
+ (BOOL)checkValidWithNormalString:(NSString *) normalString;
+ (BOOL)checkValidWithStrongPassword:(NSString *) password;
+ (BOOL)checkValidWithPointNumber:(NSString *) pointNumber;

@end

NS_ASSUME_NONNULL_END
