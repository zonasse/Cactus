//
//  CATeacher.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CATeacher.h"

@implementation CATeacher
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.t_id = dict[@"t_id"];
        self.name = dict[@"name"];
        self.password = dict[@"password"];
        self.college = dict[@"college"];
        self.is_manager = (BOOL)dict[@"is_manager"];
        self.email = dict[@"email"];
        self.mobile = dict[@"mobile"];
        self.classes = dict[@"classes"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
