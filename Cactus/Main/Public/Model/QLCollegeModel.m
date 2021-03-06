//
//  CACollegeModel.m
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLCollegeModel.h"

@implementation QLCollegeModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
        self.university_id = [dict[@"university_id"] integerValue];
    }
    return self;
}

+ (instancetype) collegeWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
