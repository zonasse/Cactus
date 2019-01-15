//
//  CAClassInfoModel.h
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  教学班信息

#import <Foundation/Foundation.h>
@interface QLClassInfoModel : NSObject
///主键
@property (nonatomic,assign) NSInteger _id;
///课程代号
@property (nonatomic,copy) NSString *cid;
///教学班名称
@property (nonatomic,copy) NSString *name;
///教师
@property (nonatomic,assign) NSInteger teacher_id;
///周
@property (nonatomic,copy) NSString *week;
///教室
@property (nonatomic,copy) NSString *room;
///学生人数
@property (nonatomic,assign) NSInteger student_count;
///学期
@property (nonatomic,copy) NSString *semester;
///当前学期
@property (nonatomic,copy) NSString *currentSemester;
/**
 初始化方法
 
 @param dict 数据字典
 @return classInfoModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) classInfoWithDict:(NSDictionary *)dict;
@end
