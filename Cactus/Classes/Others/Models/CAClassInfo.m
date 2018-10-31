//
//  CAClassInfo.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAClassInfo.h"

@implementation CAClassInfo
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.cid = dict[@"cid"];
        self.name = dict[@"name"];
        self.teacher_id = [dict[@"teacher_id"] integerValue];
        self.year = dict[@"year"];
        self.month = dict[@"month"];
        self.date = dict[@"date"];
        self.room = dict[@"room"];

    }
    return self;
}

+ (instancetype) classInfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
