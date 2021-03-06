//
//  CATitleGroupModel.h
//  Cactus
//
//  Created by  zonasse on 2018/10/2.
//  Copyright © 2018年  zonasse. All rights reserved.
//  分数大项

#import <Foundation/Foundation.h>

@interface QLTitleGroupModel : NSObject
@property (nonatomic,assign) NSInteger _id;
///大项名
@property (nonatomic,copy) NSString *name;
///所属课程
@property (nonatomic,assign) NSInteger lesson_id;
///大项权重
@property (nonatomic,assign) NSInteger weight;
/**
 初始化方法
 
 @param dict 数据字典
 @return titleGroupModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) titleGroupWithDict:(NSDictionary *)dict;
@end
