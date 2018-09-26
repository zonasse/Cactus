//
//  CALessonClass.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  课程班级

#import <Foundation/Foundation.h>

@interface CALessonClass : NSObject
//课程班级标识号
@property (nonatomic,assign) NSInteger lc_id;
//班级学生
@property (nonatomic,strong) NSArray *students;
//课程信息标识id
@property (nonatomic,assign) NSInteger lessonInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
