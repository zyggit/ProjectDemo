//
//  IAPHelper.m
//  ICartoonIOS
//
//  Created by HY on 14-10-14.
//  Copyright (c) 2014年 HY. All rights reserved.
//

#import "IAPHelper.h"

@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

+(IAPHelper *)shareInstance
{
    static IAPHelper * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      shareInstance = [[self alloc] init];
                  });
    return  shareInstance;
}
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//  在我们使用这些代码之前，我们还需要在App Delegate里面添加一些东西，这样的话，当产品支付事务完成的时候，IAPHelper类就会得到相应的通知。所以，打开IAPHelper.m并作如下修改,如果没有这句代码的话，那么 paymentQueue:updatedTransactions 这个函数将不会被调用，所以，造成记得要加上去！
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPHelper shareInstance]];
    return YES ;
}
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init]))
    {
        _productIdentifiers = productIdentifiers;
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        self.purchasedProducts = purchasedProducts;
    }
    return self;

}
//- (void)requestProducts {
//    
//    //判断用户是否有权限购买
//    if ([SKPaymentQueue canMakePayments])
//    {
//        self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] ;
//        _request.delegate = self;
//        [_request start];
//    }
//}
#pragma mark -- 请求某一个单独的产品
-(void)requestProductsWithidentifier:(NSString *)procuctId
{
    //判断用户是否有权限购买
    NSMutableSet * purchasedProducts = [NSMutableSet set];
    [purchasedProducts addObject:procuctId];
    NSLog(@"---------------count = %d",[purchasedProducts count]);
    if ([SKPaymentQueue canMakePayments])
    {
        if (!_request)
        {
            self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:purchasedProducts] ;
            NSLog(@"request ＝＝＝＝ = %@",self.request);
            _request.delegate = self;
            [_request start];
            [self performSelector:@selector(timeOut) withObject:nil afterDelay:30];
        }
        else
        {
            [_request cancel];
            _request = nil;
        }
    }
}
#pragma mark -- 超时处理
-(void)timeOut
{
//    NSLog(@"超时");
//    [_request cancel];
//    _request = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedTimeOutNotification object:_products];
}
#pragma mark -- SKProductsRequestDelegate_required
/*************************************************************************************************
 创建了一个SKProductsRequest实例，那是苹果公司写的一个类，它里面包含从iTunes Connect里面提取信息的代码。使用此类灰常easy，你只需要给它一个delegate（它必须符合SKProductsRequestDelegate 协议），然后就可以调用start方法了
  我们设置IAPHelper类本身作为delegate，那就意味着此类会收到一个回调函数，此函数(productsRequest:didReceiveResponse)会返回产品列表。
 Update: Jerry 在论坛里面指出，SKProductsRequestDelegate 协议是从SKRequestDelegate派生而来滴，而SKRequestDelegate协议有一个方法，叫做 request:didFailWithError:。此方法会在失败的时候调用，如果你喜欢的话，你可以使用此方法来代码后面的timeout方法。
 invalidProductIdentifiers-- 错误的产品标识符
 ***************************************************************************************************/
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    [self.request cancel];
    self.request = nil;
    //产品列表请求完毕发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}
#pragma mark -- 获取产品列表失败
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Received products faild...%@",[error localizedDescription]);
    [request cancel];
    request = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}

#pragma mark -- 向服务器发送一个消息，让服务器来保存一些记录
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    // Optional: Record the transaction on the server side...
    
}

#pragma mark -- 支付成功或者失败调用
- (void)provideContent:(NSString *)productIdentifier {
    NSString * code = [NSString stringWithFormat:@"120201%d",self.postion];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
}

#pragma mark -- 完成交易,数据上报
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString * code = [NSString stringWithFormat:@"120201%d",self.postion];
    self.is_paymentState = NO;
    //APPStore购买成功
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction.payment.productIdentifier];
    NSString* jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    NSString* sendString = [[NSString alloc] initWithFormat:@"{\"receipt-data\":\"%@\"}",jsonObjectString ];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

#pragma mark -- 购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    self.is_paymentState = NO;
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

#pragma mark -- appDelegate加入代码 [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageHelpIAPHelper sharedHelper]];此方法才会被正常调用
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"正在支付...  %d",[[SKPaymentQueue defaultQueue].transactions  count]);
    self.is_paymentState = YES;
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

#pragma mark -- 点击购买触发的函数
- (void)buyProductIdentifier:(SKProduct *)productIdentifier {
    
    NSLog(@"正在购买＝%@", productIdentifier);
    SKPayment *payment = [SKPayment paymentWithProduct:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"111111111111...  %d",[[SKPaymentQueue defaultQueue].transactions  count]);

}



- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}
- (void)dealloc
{
    self.productIdentifiers = nil;
    self.products = nil;
    self.purchasedProducts = nil;
    self.request = nil;
}


@end
