//
//  CAClassInfoModel.m
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLClassInfoModel.h"

@implementation QLClassInfoModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.cid = dict[@"cid"];
        self.name = dict[@"name"];
        self.teacher_id = [dict[@"teacher_id"] integerValue];
        self.week = dict[@"week"];
        self.room = dict[@"room"];
        self.student_count = [dict[@"student_count"] integerValue];
        self.semester = dict[@"semester"];
        self.currentSemester = dict[@"current_semester"];
        self.lesson_id = [dict[@"lesson_id"] integerValue];
    }
    return self;
}

+ (instancetype) classInfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
