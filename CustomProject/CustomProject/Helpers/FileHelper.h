//
//  FileHelper.h
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//
/********************文件操作帮助类**********************************/
#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(FileHelper *)shareInstance ;

-(long long)fileSizeAtPath:(NSString *)path ;
- (float ) folderSizeAtPath:(NSString*) folderPath;


@end
