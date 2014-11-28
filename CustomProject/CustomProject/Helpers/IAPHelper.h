//
//  IAPHelper.h
//  ICartoonIOS
//
//  Created by HY on 14-10-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//
/*
 1.用户从你的应用程序购买任何东西之前，必须向iTunesConnect发送一个查询请求从服务器上获取所有可用的产品列表
 */

#define kProductsLoadedNotification                     @"ProductsLoaded"
#define kProductPurchasedNotification                   @"ProductPurchased"              //购买成功
#define kProductPurchaseFailedNotification              @"ProductPurchaseFailed"        //购买失败
#define kProductsLoadedTimeOutNotification              @"ProductsLoadedTimeout"        //请求超时

#define kDataUploadSuccess                              @"datauploadsuccess"            //数据上报成功
#define kDatauploadFailed                               @"datauploadfailed"             //数据上报失败
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface IAPHelper : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver,UIApplicationDelegate>

@property(nonatomic,retain)NSSet * productIdentifiers ;
@property(nonatomic,retain)NSArray * products ;
@property(nonatomic,retain)NSMutableSet * purchasedProducts ;
@property(nonatomic,retain)SKProductsRequest * request ;
@property(nonatomic,assign)int postion ;                        //用户行为上报数据埋点
@property(nonatomic,retain)NSString * trackId ;
@property(nonatomic,assign)BOOL is_paymentState ;               //判断是否在支付状态
+(IAPHelper *)shareInstance ;
- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;


- (void)buyProductIdentifier:(SKProduct *)productIdentifier;

-(void)requestProductsWithidentifier:(NSString *)procuctId;

@end
