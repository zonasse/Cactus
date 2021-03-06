//
//  CAUniversityModel.h
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  学校

#import <Foundation/Foundation.h>
@interface QLUniversityModel : NSObject
///校名
@property (nonatomic,copy) NSString *name;
///校昵称
@property (nonatomic,copy) NSString *shortname;

/**
 初始化方法

 @param dict 数据字典
 @return universityModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype) universityWithDict:(NSDictionary *)dict;
@end
