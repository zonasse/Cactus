//
//  CAStudent.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  学生模型

#import <Foundation/Foundation.h>
@interface CAStudent : NSObject
//学号
@property (nonatomic,copy) NSString *sid;
//学生姓名
@property (nonatomic,copy) NSString *name;
//学生学年
@property (nonatomic,copy) NSString *year;
//学生所在专业
@property (nonatomic,assign) NSInteger major_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;

@end
