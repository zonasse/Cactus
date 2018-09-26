//
//  CALessonInfo.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  课程信息表

#import <Foundation/Foundation.h>

@interface CALessonInfo : NSObject
//课程标识
@property (nonatomic,assign) NSInteger l_id;
//课程代号
@property (nonatomic,copy) NSString *code;
//课程名
@property (nonatomic,copy) NSString *name;
//教师id
@property (nonatomic,assign) NSInteger teacher;
//开课年
@property (nonatomic,copy) NSString *year;
//开课月
@property (nonatomic,copy) NSString *month;
//开课时间
@property (nonatomic,copy) NSString *date;
//教室
@property (nonatomic,copy) NSString *room;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
