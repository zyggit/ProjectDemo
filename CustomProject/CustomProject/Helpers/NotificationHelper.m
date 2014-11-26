//
//  NotificationHelper.m
//  CustomProject
//
//  Created by 元爱轩 on 14-11-16.
//  Copyright (c) 2014年 元爱轩. All rights reserved.
//

#import "NotificationHelper.h"

@implementation NotificationHelper
+(NotificationHelper *)shareInstance
{
    static NotificationHelper * helper = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NotificationHelper alloc]init];
    });
    return helper ;
}
#pragma mark -- 第一步:注册消息推送的类型
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert ];
    //用户点击推送消息，应用程序还没启动
    NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (pushInfo)
    {
        NSDictionary *apsInfo = [pushInfo objectForKey:@"aps"];
        if(apsInfo)
        {
            //your code here
        }
    }
    return  YES ;
}
#pragma mark -- 第二步:注册通知成功,上传token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}
#pragma mark -- 第三步:注册通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}
#pragma mark -- 处理消息推送
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
       //程序处于前台
    }else if (application.applicationState == UIApplicationStateInactive)
    {
        //程序处于后台
    }
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"1222");
}




@end
