//
//  UIView+CAExtension.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/5.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CAExtension)

- (CGFloat) x;
- (CGFloat) y;
- (CGFloat) width;
- (CGFloat) height;
- (CGFloat) getMaxX;
- (CGFloat) getMaxY;
- (void)setX:(CGFloat) x;
- (void)setY:(CGFloat) y;
- (void)setWidth:(CGFloat) width;
- (void)setHeight:(CGFloat) height;
@end

NS_ASSUME_NONNULL_END
