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

- (void)setTeacherProfileData:(NSDictionary *)profileDictionary;
- (void)setClassInfoData:(NSArray *)classInfoArray;
@end

NS_ASSUME_NONNULL_END
