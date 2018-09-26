//
//  CAPoint.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数

#import <Foundation/Foundation.h>

@interface CAPoint : NSObject
//课程班级标识号
@property (nonatomic,assign) NSInteger p_id;
//分数的课程ID
@property (nonatomic,assign) NSInteger lessonID;
//分数所属学生ID
@property (nonatomic,assign) NSInteger studentID;
//分数
@property (nonatomic,assign) NSInteger point;
//列名
@property (nonatomic,assign) NSInteger title;
//时间戳
@property (nonatomic,copy) NSString *date;
//备注
@property (nonatomic,copy) NSString *notes;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
