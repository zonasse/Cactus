//
//  NSString+CAExtension.m
//  Cactus
//
//  Created by  zonasse on 2018/11/22.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import "NSString+QLExtension.h"

@implementation NSString (QLExtension)
+ (BOOL)checkValidWithNormalString:(NSString *) str{
    NSString *regex = @"^[a-zA-Z0-9_-]{1,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}
+ (BOOL)checkValidWithStrongPassword:(NSString *)str{
    NSString *regex = @"^.*(?=.{6,})(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}
+ (BOOL)checkValidWithPointNumber:(NSString *)str{
//    NSString *regex = @"^[0-9]{1,3}[\\.[0-9]{0,2}]?$";
    NSString *regex = @"^\\d{1,3}(\\.\\d{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}
+ (BOOL)checkValidWithChineseWord:(NSString *)str{
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}
@end
