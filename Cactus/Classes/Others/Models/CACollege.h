//
//  CACollege.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  学院

#import <Foundation/Foundation.h>
@interface CACollege : NSObject
//学院名
@property (nonatomic,copy) NSString *name;
//学院昵称
@property (nonatomic,copy) NSString *shortname;
//所在学校
@property (nonatomic,assign) NSInteger university_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) collegeWithDict:(NSDictionary *)dict;
@end
