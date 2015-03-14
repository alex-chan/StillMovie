//
//  EditMovieViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 14/12/5.
//  Copyright (c) 2014年 sunset. All rights reserved.
//


import Foundation
import AVFoundation
import UIKit
import AssetsLibrary
import MobileCoreServices


var AVLoopPlayerCurrentItemObservationContext = "AVLoopPlayerCurrentItemObservationContext"





class EditMovieViewController: UIViewController{
    
    var tmpMovieURL: NSURL?
    


    var queuePlayer: AVQueuePlayer?
    var stillMovie: StillMovieEffect?

    
    @IBOutlet weak var playerView: MoviePreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("viewDidLoad")
        

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        
        var mainURL:NSURL =  NSBundle.mainBundle().URLForResource("prefix", withExtension: "mov")!
        tmpMovieURL = mainURL
        
        self.stillMovie = StillMovieEffect(sourceURL: tmpMovieURL!)
        self.stillMovie!.previewEffect({
            (urls) -> Void in
            self.loadMovieItems(urls)
            
        })
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        println("viewWillDisappear")
        
        if let player = self.queuePlayer {
            player.removeObserver(self, forKeyPath: "currentItem", context: &AVLoopPlayerCurrentItemObservationContext)
            player.pause()
            player.removeAllItems()
            self.queuePlayer = nil
        }

        
        super.viewWillDisappear(animated)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {


        if context == &AVLoopPlayerCurrentItemObservationContext{

            var player:AVQueuePlayer = object as AVQueuePlayer
            var itemRemoved = change[NSKeyValueChangeOldKey] as MyAVPlayerItem
            if itemRemoved.isKindOfClass(MyAVPlayerItem){

                itemRemoved.seekToTime(kCMTimeZero)
                player.insertItem(itemRemoved, afterItem: nil)
                

            }
            
        }else{
            return super.observeValueForKeyPath(keyPath, ofObject: object , change: change, context: context)
        }
        
        
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    // MARK: selectors
    func playerItemDidReachEnd(notification: NSNotification) {
        
        
        println("playerItemDidReachEnd \(self.queuePlayer!.items()) ")
        
//        self.queuePlayer!.items()[0].seekToTime(kCMTimeZero)
//        var p: AVPlayerItem = notification.object as AVPlayerItem
//        p.seekToTime(kCMTimeZero)
//        self.playMovies()

    }
    
    // MARK: actions
    
    @IBAction func previewMovie(sender: UIButton) {
        println("preview btn clicked")
        

        if (self.queuePlayer != nil && self.queuePlayer!.status == AVPlayerStatus.ReadyToPlay){
            
            println("ready to play")
            self.queuePlayer!.seekToTime(kCMTimeZero)
            
            self.queuePlayer!.play()
        }
    }
    
    @IBAction func finishEditing(sender: UIButton) {
        
    }
    
    
    @IBAction func unwindToEditMovie(segue: UIStoryboardSegue) {
        
    }
    

    
    // MARK: Image generate related functions
    
    func loadMovieItems(movieURLs: [NSURL]){
        // Assert the movieURLs' length is 2
        
        var tracksKey = "tracks"
        
        
        
        var asset1: AVURLAsset = AVURLAsset(URL: movieURLs[0], options: nil)
        
        asset1.loadValuesAsynchronouslyForKeys([tracksKey], completionHandler: {
            
            var error: NSError? = nil
            var status: AVKeyValueStatus = asset1.statusOfValueForKey(tracksKey, error: &error)
            
            if status == AVKeyValueStatus.Loaded{
                var item1 = MyAVPlayerItem(asset: asset1, itemType: MyAVPlayerItemType.PREFIX_ITEM)
                
                var asset2: AVURLAsset = AVURLAsset(URL: movieURLs[1], options: nil)
                
                asset2.loadValuesAsynchronouslyForKeys([tracksKey], completionHandler: {
                    
                    var error2: NSError? = nil
                    var status2: AVKeyValueStatus = asset2.statusOfValueForKey(tracksKey, error: &error)
                    
                    if status2 == AVKeyValueStatus.Loaded{
                        var item2 = MyAVPlayerItem(asset: asset2, itemType: MyAVPlayerItemType.MAIN_ITEM)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.constructQueyPlayerAndPlay(item1, item2: item2)
                        })
                        
                        
                        
                    }else{
                        println(error2)
                    }
                })
                
                
            }else{
                println(error)
            }
            
        })
        
    }
    
    
    
    func playMovies(){
        
        self.queuePlayer!.play()
    }
    
    
    func constructQueyPlayerAndPlay(item1: MyAVPlayerItem, item2: MyAVPlayerItem){
        if self.queuePlayer == nil{
 
            
            self.queuePlayer = AVQueuePlayer( items: [item1, item2])
            
            self.playerView.player =  self.queuePlayer!
            
        }
        
        self.queuePlayer!.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.Old, context: &AVLoopPlayerCurrentItemObservationContext)
        
        self.queuePlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.Advance
        
        println("items ready to play :\(self.queuePlayer!.items() ) ")
        self.queuePlayer!.play()
        
        
    }
    


}