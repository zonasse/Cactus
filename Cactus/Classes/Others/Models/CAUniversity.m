//
//  CAUniversity.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAUniversity.h"

@implementation CAUniversity
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.uni_id = (NSInteger)dict[@"uni_id"];
        self.name = dict[@"name"];
        self.shortname = dict[@"shortname"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end