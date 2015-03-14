//
//  GenerateMovieFromImage.m
//  TryDemo
//
//  Created by Alex Chan on 14/12/8.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "GenerateMovieFromImage.h"
#include <math.h>
static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation GenerateMovieFromImage


//+ (void) createCGImageFromFile: (NSURL*)  url completionBlock: (LoadImageCompletionBlock)handler
//{
//
//    [[[ALAssetsLibrary alloc] init] assetForURL:url resultBlock:^(ALAsset *asset) {
//        {
//            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//            CGImageRef image = [assetRep fullResolutionImage];
//            handler(image);
//        }
//    } failureBlock:^(NSError *error) {
//        handler(NULL);
//    }];
//    
//    return ;

//    
//    CGImageRef        myImage = NULL;
//    CGImageSourceRef  myImageSource;
//    CFDictionaryRef   myOptions = NULL;
//    CFStringRef       myKeys[2];
//    CFTypeRef         myValues[2];
//    
//    // Set up options if you want them. The options here are for
//    // caching the image in a decoded form and for using floating-point
//    // values if the image format supports them.
//    myKeys[0] = kCGImageSourceShouldCache;
//    myValues[0] = (CFTypeRef)kCFBooleanTrue;
//    myKeys[1] = kCGImageSourceShouldAllowFloat;
//    myValues[1] = (CFTypeRef)kCFBooleanTrue;
//    // Create the dictionary
//    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
//                                   (const void **) myValues, 2,
//                                   &kCFTypeDictionaryKeyCallBacks,
//                                   & kCFTypeDictionaryValueCallBacks);
//    // Create an image source from the URL.
//    myImageSource = CGImageSourceCreateWithURL((CFURLRef)url, myOptions);
//    CFRelease(myOptions);
//    // Make sure the image source exists before continuing
//    if (myImageSource == NULL){
//        fprintf(stderr, "Image source is NULL.");
//        return  NULL;
//    }
//    // Create an image from the first item in the image source.
//    myImage = CGImageSourceCreateImageAtIndex(myImageSource,
//                                              0,
//                                              NULL);
//    
//    CFRelease(myImageSource);
//    // Make sure the image exists before continuing
//    if (myImage == NULL){
//        fprintf(stderr, "Image not created from image source.");
//        return NULL;
//    }
//    
//    return myImage;
//}


+ (void)generateMovieWithImage:(CGImageRef)image completionBlock:(GenerateMovieWithImageCompletionBlock)handler
{
    
    
//    [GenerateMovieFromImage createCGImageFromFile:url completionBlock:^(CGImageRef image){
    
//        CGImageRef  image2 = CGImageCreateCopy(image);
    
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent: [@"tmpgen" stringByAppendingPathExtension:@"mov"  ] ];
        
        NSURL *videoUrl = [NSURL fileURLWithPath:path];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            NSError *error;
            if ([[NSFileManager defaultManager] removeItemAtPath:path error:&error] == NO) {
                NSLog(@"removeitematpath %@ error :%@", path, error);
            }
        }
        
        
        // TODO: image need to rotate programly, not in hand
        int width = (int)CGImageGetWidth(image);
        int height = (int)CGImageGetHeight(image);
        
        NSError *error = nil;
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:videoUrl
                                                               fileType:AVFileTypeQuickTimeMovie
                                                                  error:&error];
        NSParameterAssert(videoWriter);
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:height], AVVideoHeightKey,
                                       nil];
        AVAssetWriterInput* writerInput = [AVAssetWriterInput
                                           assetWriterInputWithMediaType:AVMediaTypeVideo
                                           outputSettings:videoSettings] ; //retain should be removed if ARC
        
        writerInput.transform = CGAffineTransformMakeRotation(M_PI_2) ;
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        [videoWriter addInput:writerInput];
        
//        NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                               [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,
//                                                               [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                                                               [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                                                               [NSNumber numberWithInt:width], kCVPixelBufferWidthKey,
//                                                               [NSNumber numberWithInt:height], kCVPixelBufferHeightKey,
////                                                                [NSNumber numberWithInt:frameSize.width*4], kCVPixelBufferBytesPerRowAlignmentKey,
//                                                               [NSNumber numberWithInt:4*width], kCVPixelBufferBytesPerRowAlignmentKey,
//                                                               nil];
    
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                         sourcePixelBufferAttributes:nil ];
        
        //    2) Start a session:
        NSLog(@"start session");
        
        if(! [videoWriter startWriting] ){
            NSLog(@"startWriting:%@", videoWriter.error);
        };
        [videoWriter startSessionAtSourceTime:kCMTimeZero]; //use kCMTimeZero if unsure
        
        
        dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
        [writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
            
            
//            NSLog(@"image:%@", image);
            
            if ([writerInput isReadyForMoreMediaData]) {
                
                
                //    3) Write some samples:
                
                // Or you can use AVAssetWriterInputPixelBufferAdaptor.
                // That lets you feed the writer input data from a CVPixelBuffer
                // that’s quite easy to create from a CGImage.
                
                
                CVPixelBufferRef sampleBuffer = [self newPixelBufferFromCGImage:image];
                
//                CGImageRelease(image2);
                
                
                if (sampleBuffer) {
                    CMTime frameTime = CMTimeMake(150,30);
                    if(! [adaptor appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero]){
                        NSLog(@"appendPix1:%@" , videoWriter.error );
                    };
                    if(! [adaptor appendPixelBuffer:sampleBuffer withPresentationTime:frameTime] ){
                        NSLog(@"appendPix2:%@" , videoWriter.error );
                    }
                    CFRelease(sampleBuffer);
                }
            }
            
            
            //    4) Finish the session:
            
            [writerInput markAsFinished];
            [videoWriter endSessionAtSourceTime:CMTimeMakeWithSeconds(1, 30.0) ] ; //optional can call finishWriting without specifiying endTime
            // [videoWriter finishWriting]; //deprecated in ios6
            NSLog(@"to finnish writing");
            
            [videoWriter finishWritingWithCompletionHandler:^{
                NSLog(@"%@",videoWriter);
                NSLog(@"finishWriting..");
                
                handler(videoUrl);
                
                ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path] completionBlock: ^(NSURL *assetURL, NSError *error){
                    if( error != nil) {
                        NSLog(@"writeVideoAtPathToSavedPhotosAlbum error: %@" , error);
                    }
                    
                }];
            }]; //ios 6.0+
            
        }];

        
        
//    }];
    
    




     
}


+ (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef)image
{
    
    
    
    NSLog(@"CGImageGetBitsPerPixel:%zul", CGImageGetBitsPerPixel(image) );
    NSLog(@"CGImageGetColorSpace:%@", CGImageGetColorSpace(image) );
    NSLog(@"CGImageGetBitsPerComponent:%zul", CGImageGetBitsPerComponent(image) );
    NSLog(@"CGImageGetBitmapInfo:%ul", CGImageGetBitmapInfo(image) );
    NSLog(@"CGImageGetAlphaInfo:%ul", CGImageGetAlphaInfo(image) );
    
    
    NSLog(@"test:%u", (CGBitmapInfo)kCGImageAlphaNone | kCGBitmapByteOrder32Little );
    
    //    CGImageRef image2 = CGImageCreateCopy(image);
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image) );
//    CGSize frameSize = CGSizeMake(CGImageGetHeight(image), CGImageGetWidth(image) );
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             [NSNumber numberWithInt:frameSize.width*4], kCVPixelBufferBytesPerRowAlignmentKey,
//                             [NSNumber numberWithInt:frameSize.width*4], kCVPixelBufferPlaneAlignmentKey,
//                             [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    

    
    NSLog(@"width:%f", frameSize.width);
    NSLog(@"height:%f", frameSize.height);


    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);

    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);

    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 (size_t)frameSize.width,
                                                 (size_t)frameSize.height ,
                                                 8,
                                                 (size_t)(4*frameSize.width), rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst
                                                 );
    
    NSParameterAssert(context);
    

    

    CGContextConcatCTM(context, CGAffineTransformIdentity);
    
//    CGContextTranslateCTM(context, 0.0, 1920.);
//    CGContextRotateCTM(context, radians(-90.));
//    CGContextTranslateCTM(context, 0.0, -frameSize.height/2);
//    CGContextScaleCTM(context, 1.0, 2.0);

    NSLog(@"frameSize.height:%f", frameSize.height );
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameSize.width, frameSize.height
                                           ), image);


    
    NSLog(@"image height:%zu", CGImageGetHeight(image) );
    
    
    
    

    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
//    CGImageRelease(image2);    
    
    return pxbuffer;
}



@end




