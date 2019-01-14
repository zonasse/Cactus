//
//  NSDictionary+CADictionaryDeepCopy.h
//  Cactus
//
//  Created by 钟奇龙 on 2018/11/2.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (QLDictionaryDeepCopy)
-(NSMutableDictionary *)mutableDeepCopy;

@end

NS_ASSUME_NONNULL_END
