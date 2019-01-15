//
//  CATeacherModel.m
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  

#import "QLTeacherModel.h"

@implementation QLTeacherModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.tid = dict[@"tid"];
        self.name = dict[@"name"];
        self.password = dict[@"password"];
        self.college_id = [dict[@"college_id"] integerValue];
        self.is_manager = (BOOL)dict[@"isManager"];
        self.email = dict[@"email"];
        self.mobile = dict[@"mobile"];
        self.avatar = dict[@"avatar"];
    } 
    return self;
}

+ (instancetype) teacherWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
