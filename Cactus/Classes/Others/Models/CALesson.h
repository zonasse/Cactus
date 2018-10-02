//
//  CALesson.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  课程信息表

#import <Foundation/Foundation.h>

@interface CALesson : NSObject
//课程名
@property (nonatomic,copy) NSString *name;
//拥有教学班组
@property (nonatomic,strong) NSArray *classes;
//拥有分数大项组
@property (nonatomic,strong) NSArray *titleGroups;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
