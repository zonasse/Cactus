//
//  CATeacher.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  教师模型

#import <Foundation/Foundation.h>
@class CACollege;
@interface CATeacher : NSObject
//教师职工号
@property (nonatomic,copy) NSString *t_id;
//教师姓名
@property (nonatomic,copy) NSString *name;
//教师密码，加密
@property (nonatomic,copy) NSString *password;
//教师所在院系
@property (nonatomic,weak) CACollege *college;
//教师是否为组长
@property (nonatomic,assign) BOOL is_manager;
//教师邮箱
@property (nonatomic,copy) NSString *email;
//教师电话
@property (nonatomic,copy) NSString *mobile;
//拥有教学班组
@property (nonatomic,strong) NSArray *classes;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
