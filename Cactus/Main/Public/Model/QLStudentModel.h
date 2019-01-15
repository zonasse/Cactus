//
//  CAStudentModel.h
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  学生模型

#import <Foundation/Foundation.h>
@class QLMajorModel;
@interface QLStudentModel : NSObject
///主键
@property (nonatomic,assign) NSInteger _id;
///学号
@property (nonatomic,copy) NSString *sid;
///学生姓名
@property (nonatomic,copy) NSString *name;
///学生学年
@property (nonatomic,copy) NSString *year;
///学生所在专业
@property (nonatomic,assign) NSInteger major_id;
@property (nonatomic,strong) QLMajorModel *major;
/**
 初始化方法
 
 @param dict 数据字典
 @return studentModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;

@end
