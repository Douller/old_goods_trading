//
//  YuansfetPayPlugin.m
//  Runner
//
//  Created by red on 2023/3/20.
//

#import "YuansfetPayPlugin.h"
#import "YSAliWechatPay.h"
#import <CommonCrypto/CommonDigest.h>
#import "BTAPIClient.h"
//#import <BraintreeDropIn/BraintreeDropIn.h>
#import "BraintreeCore.h"
//#import "BTDataCollector.h"
#import "URLConstant.h"


@implementation YuansfetPayPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"pay_plugin_channel" binaryMessenger:[registrar messenger]];
    
    YuansfetPayPlugin *instance = [[YuansfetPayPlugin alloc]init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    
    NSDictionary *dic = call.arguments;
    
    if ([call.method isEqualToString:@ "weChat_pay"]) {
       
        NSLog(@"ios_weixin_pay");

        NSNumberFormatter *formatter_ = [[NSNumberFormatter alloc] init];
        formatter_.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *amount_ = [formatter_ numberFromString:dic[@"amount"]];
        
        [self payOrder:dic[@"orderSN"]
                amount:amount_
              currency:@"USD"
           description:dic[@"description"]
                  note:dic[@"note"]
             notifyURL:dic[@"ipnUrl"]
               storeNo:dic[@"storeNo"]
            merchantNo:dic[@"merchantNo"]
                vendor:YSPayTypeWeChatPay
                 token:dic[@"token"]
                     block:^(NSDictionary * _Nullable results, NSError * _Nullable error) {
    //                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                         if (!error) {
                             NSLog(@"ios——-支付成功");
                         } else {
                             NSLog(@"%@",[NSString stringWithFormat:@"Error domain = %@, error code = %ld", error.domain, (long)error.code]);
                         }
                     }];
    }
    else if ([call.method isEqualToString:@ "alipay_pay"]){
        NSLog(@"ios_alipay_pay");
        
        NSNumberFormatter *formatter_ = [[NSNumberFormatter alloc] init];
        formatter_.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *amount_ = [formatter_ numberFromString:dic[@"amount"]];
        
        [self payOrder:dic[@"orderSN"]
                amount:amount_
              currency:@"USD"
           description:dic[@"description"]
                  note:dic[@"note"]
             notifyURL:dic[@"ipnUrl"]
               storeNo:dic[@"storeNo"]
            merchantNo:dic[@"merchantNo"]
                vendor:YSPayTypeAlipay
                 token:dic[@"token"]
                     block:^(NSDictionary * _Nullable results, NSError * _Nullable error) {
    //                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                         if (!error) {
                             NSLog(@"ios——-支付成功");
                         } else {
                             NSLog(@"%@",[NSString stringWithFormat:@"Error domain = %@, error code = %ld", error.domain, (long)error.code]);
                         }
                     }];
    }
//    else if ([call.method isEqualToString:@ "dropIn_ui"]){
//        NSLog(@"ios_payPal_pay");
//        
////        NSString *storeNo = @"303750";//dic[@"storeNo"]
////        NSString *token = @"b44386632c9a5ecd325e96fe8426884f";//dic[@"token"]
////        NSString *merchantNo = @"203807";//dic[@"merchantNo"]
//        
//        [self prepay:dic[@"orderSN"] amount:dic[@"amount"] description:dic[@"description"] note:dic[@"note"] notifyURL:dic[@"ipnUrl"] storeNo:dic[@"storeNo"] merchantNo:dic[@"merchantNo"] token:dic[@"token"] customerNo:dic[@"customerNo"] creditType:dic[@"creditType"] block:^(NSDictionary * _Nullable results, NSError * _Nullable error) {
//            if (!error) {
//                NSLog(@"ios——-支付成功");
//            } else {
//                NSLog(@"%@",[NSString stringWithFormat:@"Error domain = %@, error code = %ld", error.domain, (long)error.code]);
//            }
//        }];
//    }
  
}



- (void)payOrder:(NSString *)orderNo
          amount:(NSNumber *)amount
        currency:(NSString *)currency
     description:(nullable NSString *)description
            note:(nullable NSString *)note
       notifyURL:(NSString *)notifyURLStr
         storeNo:(NSString *)storeNo
      merchantNo:(NSString *)merchantNo
          vendor:(YSPayType)payType
           token:(NSString *)token
           block:(void (^)(NSDictionary * _Nullable results, NSError * _Nullable error))block {

    NSString *vendor = nil;

    // 1、检查参数。
    if (orderNo.length == 0 ||
        amount == nil || [amount isEqualToNumber:@0] ||
        currency.length == 0 ||
        notifyURLStr.length == 0 ||
        storeNo.length == 0 ||
        merchantNo.length == 0 ||
        payType == 0 ||
        token.length == 0) {
        !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1000 userInfo:@{NSLocalizedDescriptionKey: @"参数错误，请检查 API 参数。"}]);
        return;
    }

    if (payType == YSPayTypeAlipay) {
        vendor = @"alipay";
    } else if (payType == YSPayTypeWeChatPay) {
        vendor = @"wechatpay";
    }
    
    // 3、发送到后端，获取处理完的字符串。
    NSMutableString *sign = [NSMutableString string];
    [sign appendFormat:@"amount=%@", amount.description];
    [sign appendFormat:@"&currency=%@", currency];
    [sign appendFormat:@"&description=%@", description];
    [sign appendFormat:@"&ipnUrl=%@", notifyURLStr];
    [sign appendFormat:@"&merchantNo=%@", merchantNo];
    [sign appendFormat:@"&note=%@", note];
    [sign appendFormat:@"&reference=%@", orderNo];
    [sign appendFormat:@"&settleCurrency=%@", @"USD"];
    [sign appendFormat:@"&storeNo=%@", storeNo];
    [sign appendFormat:@"&terminal=%@", @"APP"];
    [sign appendFormat:@"&vendor=%@", vendor];
    [sign appendFormat:@"&%@", [self md5String:token]];

    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"amount=%@", amount.description];
    [body appendFormat:@"&currency=%@", currency];
    [body appendFormat:@"&description=%@", description];
    [body appendFormat:@"&ipnUrl=%@", notifyURLStr];
    [body appendFormat:@"&merchantNo=%@", merchantNo];
    [body appendFormat:@"&note=%@", note];
    [body appendFormat:@"&reference=%@", orderNo];
    [body appendFormat:@"&settleCurrency=%@", @"USD"];
    [body appendFormat:@"&storeNo=%@", storeNo];
    [body appendFormat:@"&terminal=%@", @"APP"];
    [body appendFormat:@"&vendor=%@", vendor];
    [body appendFormat:@"&verifySign=%@", [self md5String:[sign copy]]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,BASE_URL, @"micropay/v3/prepay"]]];
    request.timeoutInterval = 15.0f;
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[body copy] dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 是否出错
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !block ?: block(nil, error);

            });
             return;
        }

        // 验证 response 类型
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1001 userInfo:@{NSLocalizedDescriptionKey: @"Response is not a HTTP URL response."}]);

            });
             return;
        }

        // 验证 response code
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{

                !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1002 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"HTTP response status code error, statusCode = %ld.", (long)httpResponse.statusCode]}]);

            });
             return;
        }

        // 确保有 response data
        if (!data || data.length == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{

                !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1003 userInfo:@{NSLocalizedDescriptionKey: @"No response data."}]);

            });
             return;
        }

        // 确保 JSON 解析成功
        id responseObject = nil;
        NSError *serializationError = nil;
        @autoreleasepool {
            responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&serializationError];
        }
        if (serializationError) {
            dispatch_async(dispatch_get_main_queue(), ^{

                !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1004 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Deserialize JSON error, %@", serializationError.localizedDescription]}]);

            });
             return;
        }

        // 检查业务状态码
        if (![[responseObject objectForKey:@"ret_code"] isEqualToString:@"000100"]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1005 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Yuansfer error, %@.", [responseObject objectForKey:@"ret_msg"]]}]);

            });
             return;
        }

        if (payType == YSPayTypeAlipay) {
            // 支付宝支付
            // 检查 payInfo
            NSString *payInfo = [[responseObject objectForKey:@"result"] objectForKey:@"payInfo"];
            if (payInfo.length == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    !block ?: block(nil, [NSError errorWithDomain:YSErrDomain code:1006 userInfo:@{NSLocalizedDescriptionKey: @"Yuansfer error, payInfo is null."}]);

                });
                 return;
            }
            // 发起支付宝支付
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YSAliWechatPay sharedInstance] requestAliPayment:payInfo fromScheme:@"yuansfer4alipay" block:block];
            });
        } else if (payType == YSPayTypeWeChatPay) {
            // 微信支付
            NSDictionary *result = [responseObject objectForKey:@"result"];
            // 发起微信支付
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YSAliWechatPay sharedInstance]
                 requestWechatPayment:[result objectForKey:@"partnerid"]
                                prepayid:[result objectForKey:@"prepayid"] noncestr:[result objectForKey:@"noncestr"] timestamp:[result objectForKey:@"timestamp"] package:[result objectForKey:@"package"] sign:[result objectForKey:@"sign"]
                                    appId:[result objectForKey:@"appid"]
                                    uniLink:UNIVERSAL_LINKS block:block];
            });
        }
    }];
    [task resume];
}



#pragma mark - private method

- (NSString *)md5String:(NSString *)string {
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5Value = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15]];

    return md5Value;
}
@end




//#pragma mark - DropInUI
//
//- (void)prepay:(NSString *)orderNo
//        amount:(NSString*)amount
//   description:(nullable NSString *)description
//          note:(nullable NSString *)note
//     notifyURL:(NSString *)notifyURLStr
//       storeNo:(NSString *)storeNo
//    merchantNo:(NSString *)merchantNo
//         token:(NSString *)token
//    customerNo:(NSString *)customerNo
//    creditType:(NSString *)creditType
//         block:(void (^)(NSDictionary * _Nullable results, NSError * _Nullable error))block {
//     __weak __typeof(self)weakSelf = self;
//
//    [weakSelf callBraintreePrepay:amount merchantNo:merchantNo storeNo:storeNo token:token creditType:creditType customerNo:customerNo description:description notifyURL:notifyURLStr note:note
//               completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        // 是否出错
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = error.localizedDescription;
//            });
//             return;
//        }
//
//        // 验证 response 类型
//        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = @"Response is not a HTTP URL response.";
//            });
//             return;
//        }
//
//        // 验证 response code
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        if (httpResponse.statusCode != 200) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"HTTP response status code error, statusCode = %ld.", (long)httpResponse.statusCode];
//            });
//             return;
//        }
//
//        // 确保有 response data
//        if (data == nil || !data || data.length == 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = @"No response data.";
//            });
//             return;
//        }
//
//        // 确保 JSON 解析成功
//        id responseObject = nil;
//        NSError *serializationError = nil;
//        @autoreleasepool {
//            responseObject = [NSJSONSerialization JSONObjectWithData:data
//                                                             options:kNilOptions
//                                                               error:&serializationError];
//        }
//        if (serializationError) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"Deserialize JSON error, %@", serializationError.localizedDescription];
//            });
//             return;
//        }
//
//        // 检查业务状态码
//        if (![[responseObject objectForKey:@"ret_code"] isEqualToString:@"000100"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@",responseObject);
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"Yuansfer error, %@.", [responseObject objectForKey:@"ret_msg"]];
//            });
//             return;
//        }
//
//        NSString *transactionNo = [[responseObject objectForKey:@"result"] objectForKey:@"transactionNo"];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            strongSelf.payButton.hidden = NO;
////            strongSelf.resultLabel.text = @"prepay接口调用成功,可选择支付方式";
//             NSString *authToken = [[responseObject objectForKey:@"result"] objectForKey:@"authorization"];
////            //采集deviceData
//
//            BTDataCollector *dataCollector = [[BTDataCollector alloc] initWithAPIClient:[[BTAPIClient alloc] initWithAuthorization:authToken]];
//            [dataCollector collectDeviceData:^(NSString * _Nonnull deviceData) {
//              // Send deviceData to your server
//                NSLog(@"DataCollectUIViewController deviceData=%@", deviceData);
//                [strongSelf chooseDroInUITypeWithAuthToken:authToken transactionNo:transactionNo merchantNo:merchantNo storeNo:storeNo token:token customerNo:customerNo deviceData:deviceData];
//            }];
//
//        });
//    }];
//}

//
//-(void)chooseDroInUITypeWithAuthToken:(NSString *)authToken
//                        transactionNo:(NSString *) transactionNo
//                           merchantNo:(NSString *) merchantNo
//                              storeNo:(NSString *) storeNo
//                                token:(NSString *) token
//                           customerNo:(NSString *) customerNo
//                           deviceData:(NSString *)deviceData
//{
//
//    __weak __typeof(self)weakSelf = self;
//    BTDropInRequest *request = [[BTDropInRequest alloc] init];
//    request.applePayDisabled = YES;
//    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:authToken request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [controller dismissViewControllerAnimated:YES completion:nil];
//        if (error != nil) {
//            NSLog(@"ERROR:%@", error);
////            strongSelf.resultLabel.text = [NSString stringWithFormat:@"错误:%@", error];
//        } else if (result.cancelled) {
//            NSLog(@"CANCELLED");
////            strongSelf.resultLabel.text = @"用户取消";
//        } else {
//            NSString *nonce = result.paymentMethod.nonce;
//            BTUIKPaymentOptionType type = result.paymentOptionType;
//            NSLog(@"Drop-in result type:%ld, nonce:%@, icon:%@", (long)type, nonce, result.paymentIcon);
//            if (nonce) {
////                @"正在发起支付处理...";
//
//                [strongSelf payProcess:type reqNonce:nonce transactionNo:transactionNo merchantNo:merchantNo storeNo:storeNo token:token customerNo:customerNo deviceData:deviceData];
//            }
//
//        }
//    }];
////    [self presentViewController:dropIn animated:YES completion:nil];
//}


//- (void) payProcess:(BTUIKPaymentOptionType) type
//                reqNonce:(NSString *) nonce
//      transactionNo:(NSString *) transactionNo
//         merchantNo:(NSString *) merchantNo
//            storeNo:(NSString *) storeNo
//              token:(NSString *) token
//         customerNo:(NSString *) customerNo
//         deviceData:(NSString *)deviceData {
//    // 1、根据支付方式传值
//    NSString *paymentMethod;
//    if (type == BTUIKPaymentOptionTypePayPal) {
//        paymentMethod = @"paypal_account";
//    } else if (type == BTUIKPaymentOptionTypeVenmo) {
//        paymentMethod = @"venmo_account";
//    } else if (type == BTUIKPaymentOptionTypeApplePay) {
//        paymentMethod = @"apple_pay_card";
//    } else {
//        paymentMethod = @"credit_card";
//    }
//     __weak __typeof(self)weakSelf = self;
//
//    [weakSelf callBraintreeProcess:transactionNo paymentMethod:paymentMethod nonce:nonce deviceData:deviceData merchantNo:merchantNo storeNo:storeNo token:token customerNo:customerNo
//         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//        // 是否出错
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = error.localizedDescription;
//            });
//             return;
//        }
//
//        // 验证 response 类型
//        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = @"Response is not a HTTP URL response.";
//            });
//             return;
//        }
//
//        // 验证 response code
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        if (httpResponse.statusCode != 200) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"HTTP response status code error, statusCode = %ld.", (long)httpResponse.statusCode];
//            });
//             return;
//        }
//
//        // 确保有 response data
//        if (!data || data.length == 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = @"No response data.";
//            });
//             return;
//        }
//
//        // 确保 JSON 解析成功
//        id responseObject = nil;
//        NSError *serializationError = nil;
//        @autoreleasepool {
//            responseObject = [NSJSONSerialization JSONObjectWithData:data
//                                                             options:kNilOptions
//                                                               error:&serializationError];
//        }
//        if (serializationError) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"Deserialize JSON error, %@", serializationError.localizedDescription];
//            });
//             return;
//        }
//
//        // 检查业务状态码
//        if (![[responseObject objectForKey:@"ret_code"] isEqualToString:@"000100"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                strongSelf.resultLabel.text = [NSString stringWithFormat:@"Yuansfer error, %@.", [responseObject objectForKey:@"ret_msg"]];
//            });
//             return;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //显示支付成功
////            self.resultLabel.text = @"Drop-In Pay支付成功";
////            if (self.authorizationResultBlock) {
////                //通知ApplePay支付成功
////                self.authorizationResultBlock([[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil]);
////                self.authorizationResultBlock = nil;
////            }
//        });
//    }];
//}


//-(void)callBraintreePrepay:(NSString *)amount
//                merchantNo:(NSString *)merchantNo
//                   storeNo:(NSString *)storeNo
//                     token:(NSString *)token
//                creditType:(NSString *)creditType
//                customerNo:(NSString *)customerNo
//               description:(nullable NSString *)description
//                 notifyURL:(NSString *)notifyURLStr
//                      note:(nullable NSString *)note
//
//         completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
//
//    NSString* refNo = [NSString stringWithFormat:@"%.0f", [NSDate date].timeIntervalSince1970];
//    NSDictionary* dict = @{
//        @"merchantNo": merchantNo,
//        @"storeNo": storeNo,
//        @"amount": amount,
//        @"creditType": creditType,
//        @"customerNo": customerNo,
//        @"currency":@"USD",
//        @"description":description,
//        @"ipnUrl": notifyURLStr,
//        @"note": note,
//        @"reference": refNo,
//        @"settleCurrency":@"USD",
//        @"terminal": @"YIP",
//        @"timeout": @"120",
//        @"vendor": @"creditcard"//creditcard 银行卡  paypal
//    };
//    [self execHttpRequest:@"online/v4/secure-pay" data:dict token:token completion:completionHandler];
//}


//-(void)callBraintreeProcess:(NSString *)transactionNo
//               paymentMethod:(NSString *)paymentMethod
//                      nonce:(NSString *)nonce
//                  deviceData:(NSString *)deviceData
//                  merchantNo:(NSString *)merchantNo
//                     storeNo:(NSString *)storeNo
//                       token:(NSString *)token
//                  customerNo:(NSString *)customerNo
//          completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
//            // 写死的一些接口数据和token，生产环境要替换为真实数据
//
//            NSDictionary* dict = @{
//                @"merchantNo":merchantNo,
//                @"storeNo": storeNo,
//                @"addressLine1": @"addressLine1",
//                @"addressLine2": @"addressLine2",
//                @"city":@"city",
//                @"countryCode":@"countryCode",
//                @"customerNo": customerNo,
//                @"deviceData": deviceData,
//                @"email": @"",
//                @"paymentMethod":paymentMethod,
//                @"paymentMethodNonce": nonce,
//                @"phone": @"",
//                @"postalCode": @"111",
//                @"transactionNo": transactionNo,
//                @"recipientName":@"recipientName",
//                @"state":@"state"
//            };
//            [self execHttpRequest:@"creditpay/v3/process" data:dict token:token completion:completionHandler];
//        }

//-(void)execHttpRequest:(NSString *) path data:(NSDictionary *) dict token:(NSString *)token
//         completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
//    NSString *params = [self sortedDictionary:dict];
//    NSMutableString *sign = [NSMutableString string];
//    [sign appendString:params];
//    [sign appendFormat:@"&%@", [self md5String:token]];
//
//    NSMutableString *body = [NSMutableString string];
//    [body appendString:params];
//    [body appendFormat:@"&%@=%@", @"verifySign", [self md5String:[sign copy]]];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, path]]];
//    request.timeoutInterval = 15.0f;
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [[body copy] dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:completionHandler];
//    [task resume];
//}


//-(NSString *)sortedDictionary:(NSDictionary *)dict{
//    //将所有的key放进数组
//    NSArray *allKeyArray = [dict allKeys];
//    //序列化器对数组进行排序的block 返回值为排序后的数组
//    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id
//                                                                                           _Nonnull obj2) {
//        //排序操作
//        NSComparisonResult resuest = [obj1 compare:obj2];
//        return resuest;
//    }];
//    //排序好的字典
//    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
//    NSString *tempStr = @"";
//    //通过排列的key值获取value
//    NSMutableArray *valueArray = [NSMutableArray array];
//    for (NSString *sortsing in afterSortKeyArray) {
//      //格式化一下 防止有些value不是string
//      NSString *valueString = [NSString stringWithFormat:@"%@",[dict objectForKey:sortsing]];
//      if(valueString.length>0){
//          [valueArray addObject:valueString];
//          tempStr=[NSString stringWithFormat:@"%@%@=%@&",tempStr,sortsing,valueString];
//      }
//    }
//    //去除最后一个&符号
//    if(tempStr.length>0){
//        tempStr=[tempStr substringToIndex:([tempStr length]-1)];
//    }
//    //最终参数
//    NSLog(@"tempStr:%@",tempStr);
//    return tempStr;
//}
