//
//  UserInfoObject.m
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//
#define kUserInfoFile       @"utest.archiver"
#define kUsername           @"username"
#define kPassword           @"password"
#define kSavePassword       @"savePassword"


#import "UserInfoObject.h"

@implementation UserInfoObject
+(UserInfoObject *)shareInstance
{
    static UserInfoObject * infoObject = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoObject = [[UserInfoObject alloc]init];
    });
    return infoObject;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:kUsername];
    [aCoder encodeObject:self.password forKey:kPassword];
    [aCoder encodeBool:self.savePassword forKey:kSavePassword];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.username = [aDecoder decodeObjectForKey:kUsername];
        self.password = [aDecoder decodeObjectForKey:kPassword];
        self.savePassword = [aDecoder decodeBoolForKey:kSavePassword];
    }
    return self;
}
// Document存放的绝对路径
- (NSString *)absoluteDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
-(void)backupData
{
    // 将userInfo数据保存到kUserInfoFile文件中
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSString *dataFile = [NSString stringWithFormat:@"%@/%@", [self absoluteDocumentPath], kUserInfoFile];
    [data writeToFile:dataFile atomically:YES];
}
-(void)restoreData
{
    // 从kUserInfoFile文件中回复userInfo的数据
    NSString *dataFile = [NSString stringWithFormat:@"%@/%@", [self absoluteDocumentPath], kUserInfoFile];
    UserInfoObject *tmpUserInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFile];
    [UserInfoObject shareInstance].username = tmpUserInfo.username;
    [UserInfoObject shareInstance].password = tmpUserInfo.password;
    [UserInfoObject shareInstance].savePassword = tmpUserInfo.savePassword;
}
@end
