//
//  CAClassInfoViewCell.h
//  Cactus
//
//  Created by  zonasse on 2018/9/22.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLHomePageClassInfoCell : UITableViewCell
-(void) setCellContentInformationWithClassInfoImage:(NSString *)classInfoImage classInfoName:(NSString*) classInfoName classInfoRoom:(NSString *)classInfoRoom
                                      classInfoTime:(NSString *)classInfoTime classInfoStudentCount:(NSInteger) studentCount;
@end
