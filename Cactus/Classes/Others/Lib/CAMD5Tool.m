//
//  CAMD5Tool.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/24.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAMD5Tool.h"
#import "CommonCrypto/CommonDigest.h"
@implementation CAMD5Tool
+ (NSString *)md5:(NSString *)text{
    const char *cStr = [text UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
@end
