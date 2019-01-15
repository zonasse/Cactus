//
//  NSString+CAExtension.m
//  Cactus
//
//  Created by  zonasse on 2018/11/22.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import "NSString+QLExtension.h"

@implementation NSString (QLExtension)
+ (BOOL)checkValidWithNormalString:(NSString *) normalString{
    NSString *regex = @"^[a-zA-Z0-9_-]{1,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:normalString];
}
+ (BOOL)checkValidWithStrongPassword:(NSString *)password{
    NSString *regex = @"^.*(?=.{6,})(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:password];
}
+ (BOOL)checkValidWithPointNumber:(NSString *)pointNumber{
//    NSString *regex = @"^[0-9]{1,3}[\\.[0-9]{0,2}]?$";
    NSString *regex = @"^\\d{1,3}(\\.\\d{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:pointNumber];
}

@end
