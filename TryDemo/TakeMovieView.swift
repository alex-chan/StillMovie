//
//  TakeMovieView.swift
//  TryDemo
//
//  Created by Alex Chan on 14/12/3.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class TakeMovieView: UIView{
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        println("init in TakeMovieView")
//        
//
//        
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        println("init in TakeMovieView2")
//        var bounds: CGRect = self.bounds
//        self.layer.frame = self.frame
//        (self.layer as AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
//        self.layer.bounds = bounds
////        fatalError("init(coder:) has not been implemented")
//    }


    
    var session: AVCaptureSession? {
        get{
            return (self.layer as AVCaptureVideoPreviewLayer).session;
        }
        set(session){
            
            (self.layer as AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
//            var bounds: CGRect = self.bounds
//
//            (self.layer as AVCaptureVideoPreviewLayer).bounds = bounds
//
//            self.layer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            
            (self.layer as AVCaptureVideoPreviewLayer).session = session;
            
        }
    };
    
    
    
    override class func layerClass() ->AnyClass{
        return AVCaptureVideoPreviewLayer.self;
    }
    
    
    
    
    
    
    
    
    
}
