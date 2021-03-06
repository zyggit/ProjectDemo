//
//  DeviceHelper.h
//  CustomProject
//
//  Created by 元爱轩 on 14-11-16.
//  Copyright (c) 2014年 元爱轩. All rights reserved.
//
#define MB (1024*1024)
#define GB (MB*1024)

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject
@property(nonatomic,strong)NSString * name ;
+(DeviceHelper *)shareInstance ;

/*
 得到设备的型号
 */
- (NSString *)getDeviceName ;
/*
 得到设备总空间的大小
 */
- (NSString *)totalDiskSpace ;
/*
 得到设备已使用空间的大小
 */
-(NSString *)usedDiskSpace ;
/*
 得到设备空闲空间的大小
 */
-(NSString *)freeDiskSpace ;



@end
