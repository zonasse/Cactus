//
//  CAMD5Tool.h
//  Cactus
//
//  Created by  zonasse on 2018/10/24.
//  Copyright © 2018  zonasse. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMD5Tool : NSObject
+ (NSString *)md5:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
