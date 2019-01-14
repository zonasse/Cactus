//
//  CACollegeModel.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  学院

#import <Foundation/Foundation.h>
@interface QLCollegeModel : NSObject
///学院名
@property (nonatomic,copy) NSString *name;
///学院昵称
@property (nonatomic,copy) NSString *shortname;
///所在学校
@property (nonatomic,assign) NSInteger university_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return collegeModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) collegeWithDict:(NSDictionary *)dict;
@end
