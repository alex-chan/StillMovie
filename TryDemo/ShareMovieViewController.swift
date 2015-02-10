//
//  ShareMovieViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 15/2/4.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import UIKit


class ShareMovieViewController : UIViewController{
    
    
    @IBAction func share(sender: UIButton) {
        var imagePath = NSBundle.mainBundle().pathForResource("img1", ofType: "jpg")
        
        
//        var publishContent:ISSContent = ShareSDK.content("分享内容", defaultContent: "测试分享", image: ShareSDK.imageWithPath(imagePath), title: "Share", url: "http://test.com", description: "just a test message", mediaType: SSPublishContentMediaTypeNews)
        //        var container: ISSContainer = ShareSDK.container()
        //        container.setIPadContainerWithView(sender, arrowDirect: UIPopoverArrowDirection.Up)
        
        var publishContent : ISSContent = ShareSDK.content("分享文字", defaultContent:"默认分享内容，没内容时显示",image:nil, title:"提示",url:"http://icammov.geek-link.com",description:"这是一条测试信息",mediaType:SSPublishContentMediaTypeNews)

        
           ShareSDK.showShareActionSheet(nil,
                                shareList: nil,
                                content: publishContent,
                                statusBarTips: true,
                                authOptions: nil,
                                shareOptions: nil,
                                result: {
                                    (type:ShareType, state:SSResponseState , statusInfo:ISSPlatformShareInfo!, error:ICMErrorInfo!, end:Bool) in
                                        println(state.value)
                                    
                                    
                                    switch state.value {
                                    case SSResponseStateSuccess.value:
                                        println("分享成功")
                                    case SSResponseStateFail.value:
                                        println(error.errorCode())
                                        println(error.errorDescription())
                                    default:
                                        println("other")

                                    }
                                    
                
                                    
                                }
        )
    }

}