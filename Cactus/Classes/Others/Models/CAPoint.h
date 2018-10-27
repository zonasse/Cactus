//
//  CAPoint.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数

#import <Foundation/Foundation.h>

@interface CAPoint : NSObject
//分数所属教学班
@property (nonatomic,copy) NSString *classInfo_id;
//分数所属学生
@property (nonatomic,copy) NSString *student_id;
//分数
@property (nonatomic,assign) NSInteger pointNumber;
//时间戳
@property (nonatomic,copy) NSString *date;
//备注
@property (nonatomic,copy) NSString *note;
//所属分数列
@property (nonatomic,copy) NSString *title_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) pointWithDict:(NSDictionary *)dict;
@end
