//
//  CAStudent.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  

#import "CAStudent.h"

@implementation CAStudent
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self._id = [dict[@"id"] integerValue];
        self.sid = dict[@"sid"];
        self.name = dict[@"name"];
        self.year = dict[@"year"];
#warning 此处属性记得更改为major_id
        self.major_id = [dict[@"college_id"] integerValue];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
