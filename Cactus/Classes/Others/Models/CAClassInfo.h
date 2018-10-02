//
//  CAClassInfo.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  教学班信息

#import <Foundation/Foundation.h>
@class CAClass;
@interface CAClassInfo : NSObject
//所属班级
@property (nonatomic,weak) CAClass *b_class;
//教学班名称
@property (nonatomic,copy) NSString *name;
//学年
@property (nonatomic,copy) NSString *year;
//月
@property (nonatomic,copy) NSString *month;
//日
@property (nonatomic,copy) NSString *date;
//教室
@property (nonatomic,copy) NSString *room;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
