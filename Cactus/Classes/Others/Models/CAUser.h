//
//  CAUser.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>

@interface CAUser : NSObject
//用户标识号
@property (nonatomic,assign) NSInteger u_id;
//用户姓名
@property (nonatomic,copy) NSString *name;
//用户密码，加密
@property (nonatomic,copy) NSString *password;
//用户所在院系
@property (nonatomic,copy) NSString *college;
//用户所在的学籍班
@property (nonatomic,copy) NSString *lesson_class;
//用户是否为组长
@property (nonatomic,assign) BOOL is_manager;
//用户邮箱
@property (nonatomic,copy) NSString *email;
//用户电话
@property (nonatomic,copy) NSString *mobile;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
