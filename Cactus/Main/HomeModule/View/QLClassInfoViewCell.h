//
//  CAClassInfoViewCell.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLClassInfoViewCell : UITableViewCell
-(void) setCellContentInformationWithClassInfoImage:(NSString *)classInfoImage classInfoName:(NSString*) classInfoName classInfoRoom:(NSString *)classInfoRoom
                                      classInfoTime:(NSString *)classInfoTime classInfoStudentCount:(NSInteger) studentCount;
@end
