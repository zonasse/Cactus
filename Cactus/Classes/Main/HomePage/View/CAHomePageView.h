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
 设置个人数据
 */
- (void) setTeacherName:(NSString *)teacherName tid:(NSString *)tid universityName:(NSString *)universityName collegeName:(NSString *) collegeName;


///教学班信息数组
@property (strong, nonatomic) NSArray *classInfoArray;

@end

NS_ASSUME_NONNULL_END
