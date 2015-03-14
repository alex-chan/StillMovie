//
//  AppDelegate.swift
//  TryDemo
//
//  Created by sunset on 14-11-26.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        ShareSDK.registerApp("5b09c977b07c")
        
        ShareSDK.connectSinaWeiboWithAppKey("1646769844", appSecret: "057deedfe77f7bea1a7c19f345e3318e", redirectUri: "https://icammov.parseapp.com/wb_oauthcallback", weiboSDKCls: WeiboSDK.self)
        
        ShareSDK.connectWeChatSessionWithAppId("wx9c1cecdd1a83f239", appSecret: "68f9a0608ccaaac148c9a5456989c2d4", wechatCls: WXApi.self)
        ShareSDK.connectWeChatTimelineWithAppId("wx9c1cecdd1a83f239", appSecret: "68f9a0608ccaaac148c9a5456989c2d4", wechatCls: WXApi.self)
        
        ShareSDK.connectFacebookWithAppKey("807885779284398", appSecret:"608ab53ce421ec08bbba09ccbba6e831");
        
//        Parse.enableLocalDatastore()
        Parse.setApplicationId("maKwViH1gwzGts0vJ1IuY2shAv31GIL7Wbgf78aA", clientKey: "J0gAaULaI7jmikzyS8e2A7s4Nqf7kzi9L6zaY1gQ")

        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return ShareSDK.handleOpenURL(url, wxDelegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication,
            annotation: annotation, wxDelegate: self)
    }


}

