//
//  CATitle.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CATitle.h"

@implementation CATitle
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.t_id = (NSInteger)dict[@"t_id"];
        self.name = dict[@"name"];
        self.type = dict[@"type"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end