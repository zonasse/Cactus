//
//  CAMajor.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/2.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CAMajor : NSObject
//学院名
@property (nonatomic,copy) NSString *name;
//学院昵称
@property (nonatomic,copy) NSString *shortname;
//所在学院
@property (nonatomic,copy) NSString *college_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype) userWithDict:(NSDictionary *)dict;
@end
