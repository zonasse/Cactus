//
//  UIView+CAExtension.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/5.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "UIView+CAExtension.h"

@implementation UIView (CAExtension)
- (CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (CGFloat)getMaxX{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)getMaxY{
    return CGRectGetMaxY(self.frame);
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
@end
