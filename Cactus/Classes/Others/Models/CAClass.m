//
//  CAClass.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAClass.h"

@implementation CAClass
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.c_id = dict[@"name"];
        self.lesson = dict[@"lesson"];
        self.students = dict[@"students"];
        self.classInfo = dict[@"classInfo"];
        self.teacher = dict[@"teacher"];
        self.points = dict[@"points"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
