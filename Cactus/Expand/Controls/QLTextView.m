//
//  QLTextView.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/17.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLTextView.h"

@implementation QLTextView
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.size.height = self.font.lineHeight + 5;
    originalRect.size.width = 2;
    
    return originalRect;
}
@end
