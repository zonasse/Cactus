//
//  CAUniversity.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  学校

#import <Foundation/Foundation.h>

@interface CAUniversity : NSObject
//学校标识号
@property (nonatomic,assign) NSInteger uni_id;
//校名
@property (nonatomic,copy) NSString *name;
//校昵称
@property (nonatomic,copy) NSString *shortname;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
