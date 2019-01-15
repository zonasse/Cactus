//
//  CAMajorModel.h
//  Cactus
//
//  Created by  zonasse on 2018/10/2.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QLMajorModel : NSObject
///学院名
@property (nonatomic,copy) NSString *name;
///学院昵称
@property (nonatomic,copy) NSString *shortname;
///所在学院
@property (nonatomic,assign) NSInteger college_id;
/**
 初始化方法
 
 @param dict 数据字典
 @return majorModel实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
