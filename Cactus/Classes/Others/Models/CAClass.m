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
        self.lesson_id = dict[@"lesson_id"];
        self.classInfo_id = dict[@"classInfo_id"];
        self.teacher_id = dict[@"teacher_id"];
    }
    return self;
}

+ (instancetype) classWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
