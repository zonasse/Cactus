//
//  CAClassModel.m
//  Cactus
//
//  Created by  zonasse on 2018/10/2.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLClassModel.h"

@implementation QLClassModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.lesson_id = [dict[@"lesson_id"] integerValue];
        self.classInfo_id = [dict[@"classInfo_id"] integerValue];
        self.teacher_id = [dict[@"teacher_id"] integerValue];
    }
    return self;
}

+ (instancetype) classWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
