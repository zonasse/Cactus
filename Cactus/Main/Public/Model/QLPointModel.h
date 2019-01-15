//
//  CAPointModel.h
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  分数

#import <Foundation/Foundation.h>

@interface QLPointModel : NSObject<NSCopying,NSMutableCopying>
//主键
@property (nonatomic,assign) NSInteger _id;
///分数所属教学班
@property (nonatomic,assign) NSInteger classInfo_id;
///分数所属学生
@property (nonatomic,assign) NSInteger student_id;
///分数
@property (nonatomic,assign) NSInteger pointNumber;
///时间戳
@property (nonatomic,copy) NSString *date;
///备注
@property (nonatomic,copy) NSString *note;
///所属分数列
@property (nonatomic,assign) NSInteger title_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return pointModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) pointWithDict:(NSDictionary *)dict;
@end
