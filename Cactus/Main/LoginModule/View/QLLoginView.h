//
//  QLLoginView.h
//  Cactus
//
//  Created by  zonasse on 2019/1/14.
//  Copyright © 2019  zonasse. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QLLoginViewDelegate <NSObject>

- (void)didClickLoginButtonWithTid:(NSString *)tid password:(NSString *)password;

@end

@interface QLLoginView : UIView
@property (nonatomic,weak) id<QLLoginViewDelegate> delegate;
- (void)setExistTid:(NSString *)tid password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
