//
//  MD5Util.h
//  
//
//  Created by FSTI_QC on 14-1-29.
//  Copyright (c) 2014年 FSTI_QC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

@interface MD5Util : NSObject

- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
- (NSString *)getMd5_16Bit_String:(NSString *)srcString;

@end
