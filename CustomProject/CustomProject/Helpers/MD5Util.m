//
//  MD5Util.m
//  
//
//  Created by FSTI_QC on 14-1-29.
//  Copyright (c) 2014年 FSTI_QC. All rights reserved.
//

#import "MD5Util.h"

@implementation MD5Util

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char* cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

//16位md5常规加密
//想要实现16位加密？
//很简单，提取md5散列中的16位就行！（复制以下代码及上一段代码到当前类中）
- (NSString *)getMd5_16Bit_String:(NSString *)srcString{
    //提取32位MD5散列的中间16位
    NSString* md5_32Bit_String=[self getMd5_32Bit_String:srcString];
    NSString* result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    return result;
}
@end
