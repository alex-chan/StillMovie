//
//  MoviePreview.swift
//  TryDemo
//
//  Created by Alex Chan on 14/12/5.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class MoviePreviewView: UIView{
    
    
    override class func layerClass() -> AnyClass{
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer {
        get {
            
//            self.layer.bounds = self.bounds
//            var bounds = self.bounds
//            self.layer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            return (self.layer as AVPlayerLayer).player
        }
        set(player) {
            (self.layer as AVPlayerLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
            (self.layer as AVPlayerLayer).player = player
        }
    }
}