//
//  CAPoint.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAPoint.h"

@implementation CAPoint
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.classInfo_id = [dict[@"classInfo_id"] integerValue];
        self.student_id = [dict[@"student_id"] integerValue];
        self.pointNumber = [dict[@"pointNumber"] integerValue];
        self.date = dict[@"date"];
        self.note = dict[@"note"];
        self.title_id = [dict[@"title_id"] integerValue];
    }
    return self;
}

+ (instancetype) pointWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
