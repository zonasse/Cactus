//
//  UIResponder+CAFirstResponder.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/24.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "UIResponder+CAFirstResponder.h"

@implementation UIResponder (CAFirstResponder)
static __weak id currentFirstResponder;

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
