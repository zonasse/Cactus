//
//  CATitle.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数小项列名

#import <Foundation/Foundation.h>


@interface CATitle : NSObject
//列名
@property (nonatomic,copy) NSString *name;
//列权重
@property (nonatomic,assign) NSInteger weight;
//所属大项
@property (nonatomic,weak) NSString *titleGroup_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) titleWithDict:(NSDictionary *)dict;
@end
