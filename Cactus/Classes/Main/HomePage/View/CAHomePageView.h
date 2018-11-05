//
//  CAHomePageView.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/26.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAHomePageView : UIView

/**
 设置教师数据

 @param profileDictionary 教师数据字典
 */
- (void)setTeacherProfileData:(NSDictionary *)profileDictionary;

/**
 设施教学班数据

 @param classInfoArray 教学班数据数组
 */
- (void)setClassInfoData:(NSArray *)classInfoArray;
@end

NS_ASSUME_NONNULL_END
