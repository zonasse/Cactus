//
//  CAStudentModel.m
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  

#import "QLStudentModel.h"
#import "QLMajorModel.h"
@implementation QLStudentModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.sid = dict[@"sid"];
        self.name = dict[@"name"];
        self.year = dict[@"year"];
        self.major_id = [dict[@"major_id"] integerValue];
        self.major = [[QLMajorModel alloc] initWithDict:dict[@"major_message"]];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
