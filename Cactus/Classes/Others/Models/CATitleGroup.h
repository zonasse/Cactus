//
//  CATitleGroup.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数大项

#import <Foundation/Foundation.h>

@interface CATitleGroup : NSObject
//大项名
@property(nonatomic,copy) NSString *name;
//所属课程
@property(nonatomic,copy) NSString *lesson_id;
//大项权重
@property(nonatomic,assign) NSInteger weight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) titleGroupWithDict:(NSDictionary *)dict;
@end
