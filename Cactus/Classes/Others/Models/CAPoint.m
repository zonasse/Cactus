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
        self.p_id = (NSInteger)dict[@"p_id"];
        self.lessonID = (NSInteger)dict[@"lessonID"];
        self.studentID = (NSInteger)dict[@"studentID"];
        self.title = (NSInteger)dict[@"lessonID"];
        self.point = (NSInteger)dict[@"point"];
        self.date = dict[@"date"];
        self.notes = dict[@"notes"];
    }
    return self;
}

+ (instancetype) userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
