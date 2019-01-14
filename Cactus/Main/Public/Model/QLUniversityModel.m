//
//  CAUniversityModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "QLUniversityModel.h"

@implementation QLUniversityModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
    }
    return self;
}

+ (instancetype) universityWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
