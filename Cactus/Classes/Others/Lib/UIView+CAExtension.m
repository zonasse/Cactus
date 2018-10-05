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

@end
