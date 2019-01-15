//
//  CAPointModel.m
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLPointModel.h"
@implementation QLPointModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.classInfo_id = [dict[@"classInfo_id"] integerValue];
        self.student_id = [dict[@"student_id"] integerValue];
        self.pointNumber = [dict[@"pointNumber"] integerValue];
        self.date = dict[@"date"];
        self.note = dict[@"note"];
        self.title_id = [dict[@"title_id"] integerValue];
    }
    return self;
}

+ (instancetype) pointWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
#pragma mark 重写父类的方法

- (id)copyWithZone:(NSZone *)zone{
    QLPointModel *copy = [[self class] allocWithZone:zone];
    copy._id = self._id;
    copy.classInfo_id = self.classInfo_id;
    copy.student_id = self.student_id;
    copy.pointNumber = self.pointNumber;
    copy.date = self.date;
    copy.note = self.note;
    copy.title_id = self.title_id;
    return copy;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    QLPointModel *copy = [[QLPointModel alloc] init];
    copy._id = self._id;
    copy.classInfo_id = self.classInfo_id;
    copy.student_id = self.student_id;
    copy.pointNumber = self.pointNumber;
    copy.date = self.date;
    copy.note = self.note;
    copy.title_id = self.title_id;
    return copy;
}
@end
