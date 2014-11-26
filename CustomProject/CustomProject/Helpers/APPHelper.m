//
//  APPHelper.m
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//

#import "APPHelper.h"
@implementation APPHelper

+(APPHelper *)shareInstance
{
    static APPHelper * apphelper = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apphelper = [[APPHelper alloc]init];
    });
    return apphelper ;
}
-(CGFloat)screenWidth
{
    UIScreen* mainScreen = [UIScreen mainScreen];
    CGSize size = [mainScreen bounds].size;
    return size.width ;
}
-(CGFloat)screenHeight
{
    UIScreen* mainScreen = [UIScreen mainScreen];
    CGSize size = [mainScreen bounds].size;
    return size.height ;
}


@end
