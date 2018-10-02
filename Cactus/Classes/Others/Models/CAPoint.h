//
//  CAPoint.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/26.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//  分数

#import <Foundation/Foundation.h>

@class CAClass;
@class CAStudent;
@class CATitle;

@interface CAPoint : NSObject
//分数所属课程
@property (nonatomic,weak) CAClass *b_class;
//分数所属学生
@property (nonatomic,weak) CAStudent *student;
//分数
@property (nonatomic,assign) NSInteger point;
//时间戳
@property (nonatomic,copy) NSString *date;
//备注
@property (nonatomic,copy) NSString *notes;
//所属分数列
@property (nonatomic,weak) CATitle *title;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
