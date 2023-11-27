//
//  YuansfetPayPluginRegistrant.m
//  Runner
//
//  Created by red on 2023/3/20.
//

#import "YuansfetPayPluginRegistrant.h"

@implementation YuansfetPayPluginRegistrant


+(void)registerWithRegistry:(NSObject<FlutterPluginRegistry> *)registry {
    [YuansfetPayPlugin registerWithRegistrar:[registry registrarForPlugin:@"YuansfetPayPlugin"]];
}
@end
