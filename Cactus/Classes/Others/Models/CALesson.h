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
//学院
@property (nonatomic,assign) NSInteger college_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) lessonWithDict:(NSDictionary *)dict;
@end
