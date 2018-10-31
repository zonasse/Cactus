//
//  CATitleGroup.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CATitleGroup.h"

@implementation CATitleGroup
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.lesson_id = [dict[@"lesson_id"] integerValue];
        self.weight = [dict[@"weight"] integerValue];
    }
    return self;
}

+ (instancetype) titleGroupWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
