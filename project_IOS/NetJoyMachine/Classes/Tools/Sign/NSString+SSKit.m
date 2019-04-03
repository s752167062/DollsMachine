//
//  NSString+SSKit.m
//  SSKit
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 SSKit. All rights reserved.
//

#import "NSString+SSKit.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (SSKit)

- (CGSize)stringSizeWithFont:(NSUInteger)font maxSize:(CGSize)maxSize {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute
                              context:nil].size;
}

- (BOOL)stringContains:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

- (NSString *)stringClearWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringClearWhiteSpaceWithEmptyLine {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringRandomly {
    return [NSString stringWithFormat:@"%c",arc4random_uniform(26) + 'a'];
}

- (NSDictionary *)stringConvertToDictionary {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if (error) {
        NSLog(@"JSON字符串解析出错:%@", error);
    }
    return dic;
}

- (NSString *)stringMD5Encode {
    NSData *crypto = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([crypto bytes], (CC_LONG)[crypto length], result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSData *)stringHMACSHA1Encode:(NSString *)key {
    NSData *crypto = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    void *buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, [keyData bytes], [keyData length], [crypto bytes], [crypto length], buffer);
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

- (NSString *)stringSHA1Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (unsigned int)strlen(cStr), result);
    NSString *encode = [NSString  stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4],
                        result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12],
                        result[13], result[14], result[15],
                        result[16], result[17], result[18], result[19]];
    return [encode lowercaseString];
}

- (NSString *)stringSHA224Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(cStr, (unsigned int)strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19], result[20],
                   result[21], result[22], result[23], result[24], result[25],
                   result[26], result[27]];
    return [s lowercaseString];
}

- (NSString *)stringSHA256Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (unsigned int)strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19], result[20],
                   result[21], result[22], result[23], result[24], result[25],
                   result[26], result[27], result[28], result[29], result[30],
                   result[31]];
    return [s lowercaseString];
}

- (NSString *)stringSHA384Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(cStr, (unsigned int)strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19], result[20],
                   result[21], result[22], result[23], result[24], result[25],
                   result[26], result[27], result[28], result[29], result[30],
                   result[31], result[32], result[33], result[34], result[35],
                   result[36], result[37], result[38], result[39], result[40],
                   result[41], result[42], result[43], result[44], result[45],
                   result[46], result[47]];
    return [s lowercaseString];
}

- (NSString *)stringSHA512Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(cStr, (unsigned int)strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19], result[20],
                   result[21], result[22], result[23], result[24], result[25],
                   result[26], result[27], result[28], result[29], result[30],
                   result[31], result[32], result[33], result[34], result[35],
                   result[36], result[37], result[38], result[39], result[40],
                   result[41], result[42], result[43], result[44], result[45],
                   result[46], result[47], result[48], result[49], result[50],
                   result[51], result[52], result[53], result[54], result[55],
                   result[56], result[57], result[58], result[59], result[60],
                   result[61], result[62], result[63]];
    return [s lowercaseString];
}

+ (BOOL)stringVersionCompare:(NSString *)version1 alsoVersion:(NSString *)version2 {
    NSArray *version1Compos = [version1 componentsSeparatedByString:@"."];
    NSArray *version2Compos = [version2 componentsSeparatedByString:@"."];
    NSInteger minCount = MIN(version1Compos.count, version2Compos.count);
    for (int i = 0;i < minCount;i ++) {
        NSInteger version1Integer = [version1Compos[i] integerValue];
        NSInteger version2Integer = [version2Compos[i] integerValue];
        if (version2Integer > version1Integer) {
            return YES;
        } else if (version2Integer < version1Integer) {
            return NO;
        }
    }
    return NO;
}

- (BOOL)isExist {
    if (self && self.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)stringIsMarkdown {
    if (![self isExist]) return NO;
    
    NSArray *markdownExtensions = @[ @".md", @".mkdn", @".mdwn", @".mdown", @".markdown", @".mkd", @".mkdown", @".ron" ];
    for (NSString *extension in markdownExtensions) {
        if ([self.lowercaseString hasSuffix:extension]) return YES;
    }
    
    return NO;
}


@end
