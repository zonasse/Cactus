//
//  CALessonClass.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CALessonClass.h"

@implementation CALessonClass
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.lc_id = (NSInteger)dict[@"lc_id"];
        self.students = dict[@"students"];
        self.lessonInfo = (NSInteger)dict[@"lessonInfo"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
