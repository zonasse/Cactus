//
//  CALessonModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "QLLessonModel.h"

@implementation QLLessonModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.college_id = [dict[@"college_id"] integerValue];
    }
    return self;
}

+ (instancetype) lessonWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end