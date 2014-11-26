//
//  UserInfoObject.h
//  控件创建
//
//  Created by HY on 14-11-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoObject : NSObject<NSCoding>

@property(nonatomic,retain)NSString * username ;            //用户名
@property(nonatomic,retain)NSString * password ;            //密码
@property(nonatomic,assign)BOOL savePassword   ;            //是否保存密码

+(UserInfoObject *)shareInstance ;
//写数据
-(void)backupData;
//读数据
-(void)restoreData;

@end
