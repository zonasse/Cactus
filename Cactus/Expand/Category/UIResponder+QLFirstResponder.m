//
//  UIResponder+CAFirstResponder.m
//  Cactus
//
//  Created by  zonasse on 2018/10/24.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import "UIResponder+QLFirstResponder.h"

@implementation UIResponder (QLFirstResponder)
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
