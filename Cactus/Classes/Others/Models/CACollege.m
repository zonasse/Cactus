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
        self.c_id = (NSInteger)dict[@"c_id"];
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
        self.university = dict[@"university"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
