//
//  StillMovieProcessor.swift
//  TryDemo
//
//  Created by Alex Chan on 15/2/3.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import AssetsLibrary
import MobileCoreServices




class StillMovieEffect: Effect{
    



    
    
    // MARK: Properties
    var sourceURL : NSURL
    
    
    
    // MARK: Override methods
    
    required init(sourceURL: NSURL){
        self.sourceURL = sourceURL
    }
    
    
    func previewEffect(handler: PreviewEffectComplectionBlock) {
        
        extractStillImageFromMovie()
        generateStillMovieFromImage()
        
        
        var mainURL:NSURL =  NSBundle.mainBundle().URLForResource("main", withExtension: "mov")!

        handler([sourceURL, mainURL])
    }
    
    func implementEffect() {
        
    }
    
    
    // MARK: Custom methods
    
    func extractStillImageFromMovie(){
        
    }
    
    func generateStillMovieFromImage(){
        
    }
    
    

    
    typealias ConcatToSingleMovieComplectionBlock = (NSURL) -> Void
    
    func concatToSingleMovie(movie1: NSURL, with movie2: NSURL, completionBlock handler: ConcatToSingleMovieComplectionBlock) {
        
        // Creating the Composition
        
        var mutableComposition: AVMutableComposition = AVMutableComposition()
        var videoCompositionTrack:AVMutableCompositionTrack = mutableComposition.addMutableTrackWithMediaType(AVMediaTypeVideo as String, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)  )
        
        
        // Adding the Assets
        
        var avasset1: AVAsset = AVAsset.assetWithURL(movie1) as AVAsset
        var avasset2: AVAsset = AVAsset.assetWithURL(movie2) as AVAsset
        
        
        //        avasset1.preferredTransform =  avasset2.preferredTransform
        
        
        var videoAssetTrack1: AVAssetTrack = avasset1.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
        var videoAssetTrack2: AVAssetTrack = avasset2.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
        
        videoCompositionTrack.insertTimeRange(
            CMTimeRangeMake(kCMTimeZero, videoAssetTrack1.timeRange.duration),
            ofTrack: videoAssetTrack1, atTime: kCMTimeZero, error: nil)
        
        videoCompositionTrack.insertTimeRange(
            CMTimeRangeMake(kCMTimeZero, videoAssetTrack2.timeRange.duration),
            ofTrack: videoAssetTrack2, atTime: videoAssetTrack1.timeRange.duration, error: nil)
        
        //        videoCompositionTrack.preferredTransform =       videoAssetTrack2.preferredTransform
        //        CGAffineTransformMakeRotation(CGFloat(M_PI_2) )//
        
        // Checking the Video Orientations
        
        var isFirstVideoPortrait = false;
        var transform1  = videoAssetTrack1.preferredTransform
        // Check the first video track's preferred transform to determine if it was recorded in portrait mode.
        if (transform1.a == 0 && transform1.d == 0 && (transform1.b == 1.0 || transform1.b == -1.0) && (transform1.c == 1.0 || transform1.c == -1.0)) {
            println("first video portrait")
            isFirstVideoPortrait = true;
        }
        var isSecondVideoPortrait = false;
        var transform2 = videoAssetTrack2.preferredTransform;
        // Check the second video track's preferred transform to determine if it was recorded in portrait mode.
        if (transform2.a == 0 && transform2.d == 0 && (transform2.b == 1.0 || transform2.b == -1.0) && (transform2.c == 1.0 || transform2.c == -1.0)) {
            println("second video portrait")
            isSecondVideoPortrait = true;
        }
        if ((isFirstVideoPortrait && !isSecondVideoPortrait) || (!isFirstVideoPortrait && isSecondVideoPortrait)) {
            //            UIAlertView(title: "Error!", message: "Cannot combine a video shot in portrait mode with landscape mode", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles: nil).show()
            
            println("Cannot combine a video shot in portrait mode with landscape mode")
            //            return;
        }
        //
        //        println("transform1 a:\(transform1.a) b:\(transform1.b) c:\(transform1.c) d:\(transform1.d)" )
        //        println("transform2 a:\(transform2.a) b:\(transform2.b) c:\(transform2.c) d:\(transform2.d)" )
        
        
        
        // Applying the Video Composition Layer Instructions
        
        
        var videoCompositionInstruction1: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        videoCompositionInstruction1.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack1.timeRange.duration)
        
        
        var videoCompositionInstruction2: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        videoCompositionInstruction2.timeRange = CMTimeRangeMake(videoAssetTrack1.timeRange.duration,
            CMTimeAdd(videoAssetTrack1.timeRange.duration, videoAssetTrack2.timeRange.duration) )
        
        
        var videoLayerInstruction1: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)
        videoLayerInstruction1.setTransform( videoAssetTrack2.preferredTransform, atTime: kCMTimeZero)
        
        
        var videoLayerInstruction2: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)
        videoLayerInstruction2.setTransform( videoAssetTrack2.preferredTransform, atTime: videoAssetTrack1.timeRange.duration)
        
        videoCompositionInstruction1.layerInstructions = [videoLayerInstruction1]
        videoCompositionInstruction2.layerInstructions = [videoLayerInstruction2]
        
        
        var mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.instructions = [videoCompositionInstruction1, videoCompositionInstruction2]
        
        
        
        //  Setting the Render Size and Frame Duration
        
        var natureSize:CGSize = CGSizeMake(videoAssetTrack1.naturalSize.height, videoAssetTrack1.naturalSize.width)
        
        mutableVideoComposition.renderSize = natureSize
        
        mutableVideoComposition.frameDuration = CMTimeMake(1, 30)
        
        
        
        var  kDateFormatter: NSDateFormatter?
        kDateFormatter = NSDateFormatter()
        kDateFormatter!.dateStyle = NSDateFormatterStyle.MediumStyle
        kDateFormatter!.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        
        var exporter: AVAssetExportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)
        
        
        
        exporter.outputURL = NSFileManager.defaultManager()
            .URLForDirectory(
                NSSearchPathDirectory.DocumentDirectory ,
                inDomain: NSSearchPathDomainMask.UserDomainMask,
                appropriateForURL: nil,
                create: true,
                error: nil)!
            .URLByAppendingPathComponent(kDateFormatter!.stringFromDate( NSDate() ) )
            .URLByAppendingPathExtension( UTTypeCopyPreferredTagWithClass( AVFileTypeQuickTimeMovie , kUTTagClassFilenameExtension).takeRetainedValue() )
        
        if NSFileManager.defaultManager().fileExistsAtPath(exporter.outputURL.path!) {
            var error: NSError? = nil
            if NSFileManager.defaultManager().removeItemAtPath(exporter.outputURL.path!, error: &error) == false{
                println("remove item at path \(exporter.outputURL) error: \(error) ")
            }
        }
        
        
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        exporter.shouldOptimizeForNetworkUse = true
        
        
        
        exporter.videoComposition = mutableVideoComposition;
        
        
        
        // Asynchronously export the composition to a video file and save this file to the camera roll once export completes.
        exporter.exportAsynchronouslyWithCompletionHandler({
            //            dispatch_async(dispatch_get_main_queue(), {
            if (exporter.status == AVAssetExportSessionStatus.Completed) {
                
                var assetLibrary: ALAssetsLibrary = ALAssetsLibrary()
                if (assetLibrary.videoAtPathIsCompatibleWithSavedPhotosAlbum(exporter.outputURL) ){
                    assetLibrary.writeVideoAtPathToSavedPhotosAlbum(exporter.outputURL, completionBlock:{
                        (url, error) in
                        handler(url)
                    })
                    
                }
            }
            //            })
        })
        
        
        
        
    }
    
    
    
    typealias GenerateStillMovieCompletionBlok = (NSURL) -> Void
    func generateStillMovie(movieURL: NSURL, completionBlock handler: GenerateStillMovieCompletionBlok){
        
        var asset: AVAsset  = AVAsset.assetWithURL(movieURL) as AVAsset
        var imageGen: AVAssetImageGenerator =  AVAssetImageGenerator(asset: asset)
        var time: CMTime = CMTimeMake(0, 60)
        //        imageGen.appliesPreferredTrackTransform = true
        imageGen.generateCGImagesAsynchronouslyForTimes( [ NSValue(CMTime:time) ], completionHandler: {
            
            (requestTime, image111, actualTime, result, error) -> Void in
            if result == AVAssetImageGeneratorResult.Succeeded {
                
                
                ALAssetsLibrary().writeImageToSavedPhotosAlbum(image111, metadata: nil, completionBlock: {
                    (nsurl, error) in
                })
                
                GenerateMovieFromImage.generateMovieWithImage(image111, completionBlock:{
                    (genMovieURL) in
                    //                        CGImageRelease(image2)
                    handler(genMovieURL)
                })
                
                
                
                //
                
                
                //                                        ALAssetsLibrary().writeImageToSavedPhotosAlbum(image, orientation: ALAssetOrientation., completionBlock: {
                //                                            (nsurl, error) -> Void in
                //                                        })
                
                
                
                
                
                println("gen still pic success");
                
                
            }else{
                println(error)
            }
        })
        
    }
    
    
    
}

