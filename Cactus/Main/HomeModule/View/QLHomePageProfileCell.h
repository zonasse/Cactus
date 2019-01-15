//
//  CAHomePageView.h
//  Cactus
//
//  Created by  zonasse on 2018/10/26.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLHomePageProfileCell : UITableViewCell

/**
 设置个人数据
 */
- (void) setTeacherName:(NSString *)teacherName tid:(NSString *)tid universityName:(NSString *)universityName collegeName:(NSString *) collegeName;

@end

NS_ASSUME_NONNULL_END
