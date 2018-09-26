//
//  CACollege.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  学院

#import <Foundation/Foundation.h>

@interface CACollege : NSObject
//学院标识号
@property (nonatomic,assign) NSInteger c_id;
//学院名
@property (nonatomic,copy) NSString *name;
//学院昵称
@property (nonatomic,copy) NSString *shortname;
//所在学校名称
@property (nonatomic,copy) NSString *university;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
