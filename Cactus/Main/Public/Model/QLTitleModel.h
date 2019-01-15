//
//  CATitleModel.h
//  Cactus
//
//  Created by  zonasse on 2018/9/26.
//  Copyright © 2018年  zonasse. All rights reserved.
//  分数小项列名

#import <Foundation/Foundation.h>


@interface QLTitleModel : NSObject
///主键
@property (nonatomic,assign) NSInteger _id;
///列名
@property (nonatomic,copy) NSString *name;
///列权重
@property (nonatomic,assign) NSInteger weight;
///所属大项
@property (nonatomic,assign) NSInteger titleGroup_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return titleModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) titleWithDict:(NSDictionary *)dict;
@end
