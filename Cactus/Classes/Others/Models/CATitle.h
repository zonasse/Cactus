//
//  CATitle.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  列名

#import <Foundation/Foundation.h>

@interface CATitle : NSObject
//列名标识号
@property (nonatomic,assign) NSInteger t_id;
//列名
@property (nonatomic,copy) NSString *name;
//列类别
@property (nonatomic,copy) NSString *type;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
