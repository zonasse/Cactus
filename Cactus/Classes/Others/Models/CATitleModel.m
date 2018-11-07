//
//  CATitleModel.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CATitleModel.h"
@interface CATitleModel()<NSMutableCopying>
@end
@implementation CATitleModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.name = dict[@"name"];
        self.weight = [dict[@"weight"] integerValue];
        self.titleGroup_id = [dict[@"titleGroup_id"] integerValue];
    }
    return self;
}

+ (instancetype) titleWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    CATitleModel *copy = [[CATitleModel alloc] init];
    copy._id = self._id;
    copy.name = self.name;
    copy.weight = self.weight;
    copy.titleGroup_id = self.titleGroup_id;
    return copy;
}
@end