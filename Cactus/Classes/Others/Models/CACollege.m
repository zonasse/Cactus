//
//  CACollege.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CACollege.h"

@implementation CACollege
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
        self.university_id = dict[@"university_id"];
    }
    return self;
}

+ (instancetype) collegeWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
