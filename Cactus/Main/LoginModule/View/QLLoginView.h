//
//  QLLoginView.h
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/14.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QLLoginViewDelegate <NSObject>

- (void)didClickLoginButtonWithTid:(NSString *)tid password:(NSString *)password;

@end

@interface QLLoginView : UIView
@property (nonatomic,weak) id<QLLoginViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
