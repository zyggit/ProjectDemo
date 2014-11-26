//
//  DeviceHelper.m
//  CustomProject
//
//  Created by 元爱轩 on 14-11-16.
//  Copyright (c) 2014年 元爱轩. All rights reserved.
//

#import "DeviceHelper.h"
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation DeviceHelper
@synthesize name ;
-(void)setName:(NSString *)aname
{
    name = aname;
}
-(NSString *)name
{
    return name ;
}

+(DeviceHelper *)shareInstance
{
    static DeviceHelper * deviceHelper = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceHelper = [[DeviceHelper alloc]init];
    });
    return deviceHelper ;
}
- (NSString *)getDeviceName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return platform;
    return [[UIDevice currentDevice] model];
}

- (NSString *)memoryFormatter:(long long)diskSpace
{
    NSString *formatted;
    double bytes = 1.0 * diskSpace;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    if (gigabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f GB", gigabytes];
    else if (megabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f MB", megabytes];
    else
        formatted = [NSString stringWithFormat:@"%.2f bytes", bytes];
    
    return formatted;
}
#pragma mark -- 设备空间的大小
- (NSString *)totalDiskSpace
{
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return [self memoryFormatter:space];
}
#pragma maark -- 设备空闲空间
-(NSString *)freeDiskSpace
{
    long long freeSpace = [[[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:nil]objectForKey:NSFileSystemFreeSize]longLongValue];
    return [self memoryFormatter:freeSpace];
}
-(NSString *)usedDiskSpace
{
    return [self memoryFormatter:[self usedDiskSpaceInBytes]];
}
-(CGFloat)totalDiskSpaceInBytes
{
    long long space = [[[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:nil]objectForKey:NSFileSystemSize]longLongValue];
    return space ;
}
-(CGFloat)freeDiskSpaceInBytes
{
    long long space = [[[[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:nil]objectForKey:NSFileSystemFreeSize]longLongValue];
    return space ;

}
-(CGFloat)usedDiskSpaceInBytes
{
    long long usedSpace = [self totalDiskSpaceInBytes] - [self freeDiskSpaceInBytes];
    return usedSpace ;
}

@end
