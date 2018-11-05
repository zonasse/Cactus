//
//  CAClassModel.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  教学班

#import <Foundation/Foundation.h>
@interface CAClassModel : NSObject
///所属课程
@property (nonatomic,assign) NSInteger lesson_id;
///教学班信息
@property (nonatomic,assign) NSInteger classInfo_id;
///拥有教师
@property (nonatomic,assign) NSInteger teacher_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return classModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) classWithDict:(NSDictionary *)dict;

@end
