//
//  LoginViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 15/3/7.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController{
    
    @IBAction func sinaweibologin(sender: UIButton) {
        

        
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil, result: {
            (result: Bool, userInfo: ISSPlatformUser!, error: ICMErrorInfo!) in
            if result {
                println("ok")
                
                var uid = userInfo.uid()
                var accessToken = userInfo.credential().token()
                
                

                
//                  self.upsertUser(userInfo)
//                    PFUser.becomeInBackground(token, block: nil)
                
                PFCloud.callFunctionInBackground("getSessionToken", withParameters: ["uid":uid, "accessToken": accessToken], block: {
                    (result: AnyObject!, error: NSError!) in
                    println(result)

                    if error == nil {
                        PFUser.becomeInBackground(result as String, block: nil)
                    }
                    
                });
                

                                            if self.presentingViewController  != nil{
                                                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                                            }

                
            }else{
                println("no ok")
                var alertView = UIAlertView(title: "错误", message: error.errorDescription(), delegate: nil, cancelButtonTitle: "知道了", otherButtonTitles: "")
                alertView.show()
            }
            
        })
    }
    
    
    func upsertUser(userInfo: ISSPlatformUser!){
        
        
        var query = PFQuery(className: "TokenStorage")
        query.whereKey("wb_uid", equalTo: userInfo.uid())
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) in
            
            println(objects)
            
            if( objects.count == 0 ){
                println("this account not register ")
                
                self.newUser(userInfo)
            }else{
                
                println("already register")
                
                var tokenData = objects[0] as PFObject
                var user = tokenData.objectForKey("user") as PFUser
                var accessToken = userInfo.credential().token()
                
                println("accessToken:" + accessToken)
                println("user:")
                println(user)

                
                if  accessToken != tokenData.objectForKey("accessToken") as NSString {
                    tokenData.setObject(accessToken, forKey: "accessToken")
                }
                tokenData.saveInBackgroundWithBlock({
                    (succeed: Bool!, error: NSError!) in
                    if succeed! {
                        var sessionToken = user.sessionToken
                        
                        println("sessionToken:")
                        println(sessionToken)
                        
                        println("currentUser:")
                        println(PFUser.currentUser() )
                        
                        PFUser.becomeInBackground(sessionToken, block: nil)
//                        
//                        PFUser.becomeInBackground(sessionToken, block: {
//                            (user: PFUser!, error: NSError!) in
//                            if error == nil {
//                                println("pfuser:")
//                                println(user)
//                                println("currentUser:")
//                                 println(PFUser.currentUser() )
//                            }else{
//                                println("error:")
//                                println(error.localizedDescription)
//                            }
//                            
//                            if self.presentingViewController  != nil{
//                                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
//                            }
//                            
//                        })
                        

                    }
                    
                })
                
                
                
            }
        })
        
    }
    
    func newUser(userInfo: ISSPlatformUser!){
        println("new user ")
        var user = PFUser()

        var s = NSMutableData(length: 24)!
        SecRandomCopyBytes(kSecRandomDefault, UInt(s.length), UnsafeMutablePointer<UInt8>(s.mutableBytes))
        let base64str = s.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        user.username = "wb_" + userInfo.uid()
        user.password = base64str
        user.signUpInBackgroundWithBlock({
            (succeed: Bool!, error: NSError!) in
            if succeed! {
                var ts = PFObject(className: "TokenStorage")
                ts.setObject(userInfo.uid(), forKey: "wb_uid")
                ts.setObject(userInfo.credential().token(), forKey: "accessToken")
                ts.setObject(user, forKey: "user")
                var acl = PFACL()
                acl.setPublicReadAccess(true)
                acl.setPublicWriteAccess(false)
                
                ts.ACL = acl
                
//                ts.setObject(acl, forKey: "ACL")
                
                ts.saveInBackgroundWithBlock(nil)
            }
        })
        
        
    }
}