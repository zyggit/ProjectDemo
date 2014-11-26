//
//  APPHelper.h
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//

#define kCFBundleName                       [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleName"]
#define kCFBundleShortVersionString         [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleShortVersionString"]
#define kCFBundleVersion                    [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleVersion"];

#define kSystemName                         [[UIDevice currentDevice] systemName]
#define kSystemVersion                      [[UIDevice currentDevice] systemVersion]

#define kScreenWidth                        [[APPHelper shareInstance] screenWidth]
#define kScreenHeight                       [[APPHelper shareInstance] screenHeight]

#define kUINavigationBarHeight              44
#define kUITabBarHeight                     49

#import <Foundation/Foundation.h>

@interface APPHelper : NSObject

+(APPHelper *)shareInstance ;


@end
