//
//  CALessonModel.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  课程信息表

#import <Foundation/Foundation.h>

@interface QLLessonModel : NSObject
///课程名
@property (nonatomic,copy) NSString *name;
///学院
@property (nonatomic,assign) NSInteger college_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return lessonModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) lessonWithDict:(NSDictionary *)dict;
@end
