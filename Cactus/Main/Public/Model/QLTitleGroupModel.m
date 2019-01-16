//
//  CATitleGroupModel.m
//  Cactus
//
//  Created by  zonasse on 2018/10/2.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLTitleGroupModel.h"

@implementation QLTitleGroupModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
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
