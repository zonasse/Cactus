//
//  CALessonViewCell.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALessonViewCell : UITableViewCell
-(void) setCellContentInformationWithLessonImage:(NSString *)lessonImage lessonClassName:(NSString*) lessonClassName lessonName:(NSString*)lessonName studentNumber:(NSInteger) studentNumber lessonTime:(NSString *)lessonTime;
@end
