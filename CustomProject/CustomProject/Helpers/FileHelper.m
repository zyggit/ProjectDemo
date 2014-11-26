//
//  FileHelper.m
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper
+(FileHelper *)shareInstance
{
    static FileHelper * fileHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileHelper = [[FileHelper alloc]init];
    });
    return fileHelper ;
}

-(void)createFileWithName:(NSString *)name type:(NSString *)type
{

}

#pragma mark --  计算单个文件的大小
-(long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path])
    {
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}
#pragma mark --  遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
@end
