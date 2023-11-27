//
//  YuansfetPayPluginRegistrant.h
//  Runner
//
//  Created by red on 2023/3/20.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "YuansfetPayPlugin.h"


NS_ASSUME_NONNULL_BEGIN

@interface YuansfetPayPluginRegistrant : NSObject


+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry;

@end

NS_ASSUME_NONNULL_END
