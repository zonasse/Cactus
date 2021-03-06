//
//  CAMajorModel.m
//  Cactus
//
//  Created by  zonasse on 2018/10/2.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLMajorModel.h"

@implementation QLMajorModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
        self.college_id = [dict[@"college_id"] integerValue];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
