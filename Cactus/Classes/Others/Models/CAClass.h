//
//  CAClass.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  教学班

#import <Foundation/Foundation.h>
#import "CAClassInfo.h"
@class CALesson;
@class CATeacher;
@interface CAClass : NSObject
//教学班id
@property (nonatomic,copy) NSString *c_id;
//所属课程
@property (nonatomic,weak) CALesson *lesson;
//拥有学生组
@property (nonatomic,strong) NSArray *students;
//教学班信息
@property (nonatomic,strong) CAClassInfo *classInfo;
//拥有教师
@property (nonatomic,strong) CATeacher *teacher;//原为weak
//拥有分数组
@property (nonatomic,strong) NSArray *points;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;

@end
