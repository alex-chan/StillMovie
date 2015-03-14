////
////  GenerateMovieFromImage.swift
////  TryDemo
////
////  Created by Alex Chan on 14/12/8.
////  Copyright (c) 2014年 sunset. All rights reserved.
////
//
//import Foundation
//import AssetsLibrary
//import AVFoundation
//
//
//class GenerateMovieFromImage{
//    
//    // ref: http://stackoverflow.com/questions/3741323/how-do-i-export-uiimage-array-as-a-movie/3742212#3742212
//    
//    var imageBp : CGImage!
//    var outputVideoTmpPath: NSURL!
//    
//    init(image: CGImage){
//        self.imageBp = image
//        var videoPath: String = NSTemporaryDirectory().stringByAppendingPathComponent( "tmpgen".stringByAppendingPathExtension("mov")!)
//        self.outputVideoTmpPath =  NSURL.fileURLWithPath(videoPath)
//    }
//    
//    
//    func wireWriter(){
//        var error: NSError? = nil
//        var videoWriter: AVAssetWriter = AVAssetWriter(URL: self.outputVideoTmpPath,
//            fileType: AVFileTypeQuickTimeMovie, error: &error)
//        
//        if error != nil{
//            println(error)
//        }
//        
//        var videoSettings = [
//            AVVideoCodecKey: AVVideoCodecH264,
//            AVVideoWidthKey: 640,
//            AVVideoHeightKey: 480
//        ]
//        
//        
//        
//        var writerInput: AVAssetWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
//        
//        if videoWriter.canAddInput(writerInput) {
//            videoWriter.addInput(writerInput)
//        }
//        
//        
//        videoWriter.startWriting()
//        videoWriter.startSessionAtSourceTime(kCMTimeZero)
//        
//        
//        
//        writerInput.markAsFinished()
//        videoWriter.endSessionAtSourceTime(CMTimeMakeWithSeconds(5.0, 30))
//        
//        videoWriter.finishWritingWithCompletionHandler({
//            
//        })
//        
//        
//        
//    }
//    
//    
//    func getPixelBufferFromCGImage(image:CGImage) -> CVPixelBufferRef{
//        
//        var options = [
////            kCVPixelBufferCGImageCompatibilityKey: NSNumber(bool: true),
////            kCVPixelBufferCGBitmapContextCompatibilityKey: NSNumber(bool: true)
//            
//            kCVPixelBufferCGImageCompatibilityKey as String: NSNumber(bool: true),
//            kCVPixelBufferCGBitmapContextCompatibilityKey as String : NSNumber(bool: true)
//        ]
//        
//        let h = CGImageGetHeight(image)
//        let w = CGImageGetWidth(image)
//        
//        
//        
//        var pxbuffer: Unmanaged<CVPixelBuffer>? = nil
//        
//        var status: CVReturn = CVPixelBufferCreate(kCFAllocatorDefault, w, h,
//            OSType(kCVPixelFormatType_32ARGB),  options, &pxbuffer )
//
//        if (status  != kCVReturnSuccess.value || pxbuffer == nil ){
//            println("error in CVPixelBufferCreate")
//        }
//        
//        CVPixelBufferLockBaseAddress(pxbuffer, 0 )
//        var pxdata:UnsafeMutablePointer<Void> =  CVPixelBufferGetBaseAddress(pxbuffer)
//        if pxdata == nil{
//            println("error in CVPixelBufferCreate")
//        }
//        
//        var rgbColorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
//        var context: CGContextRef   = CGBitmapContextCreate(pxdata, w, h, 8, 4*w, rgbColorSpace, kCGImage)
//        
//        var frameTransform: CGAffineTransform  = CGAffineTransform()
//        CGContextConcatCTM(context, frameTransform)
//        
//
//        CGContextDrawImage(context, CGRectMake(0.0, 0.0, CGFloat(w), CGFloat(h) ), image)
////        CGColorSpaceRelease(rgbColorSpace)
////        CGContextRelease(context)
//        
//        CVPixelBufferUnlockBaseAddress(pxbuffer, 0)
//        
//        return pxbuffer!
//        
//    }
//    
//    func startGenerate(){
//        
//    }
//}