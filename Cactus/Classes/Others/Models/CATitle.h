//
//  CATitle.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数小项列名

#import <Foundation/Foundation.h>

@class CATitleGroup;

@interface CATitle : NSObject
//列名
@property (nonatomic,copy) NSString *name;
//列类别
@property (nonatomic,assign) NSInteger type;
//列权重
@property (nonatomic,assign) NSInteger weight;
//拥有分数组
@property (nonatomic,strong) NSArray *points;
//所属大项
@property (nonatomic,weak) CATitleGroup *titleGroup;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
