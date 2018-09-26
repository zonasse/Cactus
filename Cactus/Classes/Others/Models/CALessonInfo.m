//
//  CALessonInfo.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CALessonInfo.h"

@implementation CALessonInfo
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.l_id = (NSInteger)dict[@"l_id"];
        self.code = dict[@"code"];
        self.name = dict[@"name"];
        self.teacher = (NSInteger)dict[@"teacher"];
        self.year = dict[@"year"];
        self.month = dict[@"month"];
        self.date = dict[@"date"];
        self.room = dict[@"room"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
