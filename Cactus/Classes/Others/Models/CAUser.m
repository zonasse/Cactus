//
//  CAUser.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAUser.h"

@implementation CAUser
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.u_id = (NSInteger)dict[@"u_id"];
        self.name = dict[@"name"];
        self.password = dict[@"password"];
        self.college = dict[@"college"];
        self.lesson_class = dict[@"lesson_class"];
        self.is_manager = (BOOL)dict[@"is_manager"];
        self.email = dict[@"email"];
        self.mobile = dict[@"mobile"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
