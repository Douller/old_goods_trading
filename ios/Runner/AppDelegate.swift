import UIKit
import Flutter
import Guard


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        //注册 Authing 登录
        Authing.setHost(host: "us.authing.co")
        Authing.start("63e48a630a821b6ef2e93b24")
        Authing.setLanguage(language:Language.Chinese.rawValue)
        
        
        let messenger :FlutterBinaryMessenger = window?.rootViewController as! FlutterBinaryMessenger
        AuthingLoginPlugin.registerWithRegistry(messenger: messenger)
        
        //设置PayPal URL Scheme
        BTAppSwitch.setReturnURLScheme("com.douller.app.braintree")
        YuansfetPayPluginRegistrant.register(with: self)
        
        if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let  aliWechatUrl: Bool =  YSAliWechatPay.sharedInstance().handleOpen(url)
        
        if(!aliWechatUrl){
            let  ppUrl: Bool =  YSPayPalPay.handleOpen(url, sourceApplication: sourceApplication)
            
            if(!ppUrl){
                //VenmoPay
            }
        }
        return false
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let  aliWechatUrl: Bool =  YSAliWechatPay.sharedInstance().handleOpen(url)
        
        if(!aliWechatUrl){
            let  ppUrl: Bool =  YSPayPalPay.handleOpen(url,options: options)
            
            if(!ppUrl){
                //VenmoPay
            }
        }
        return false
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return YSAliWechatPay.sharedInstance().handleUniversalLink(userActivity)
    }
}

