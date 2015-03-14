//
//  GenerateMovieFromImage.h
//  TryDemo
//
//  Created by Alex Chan on 14/12/8.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

#ifndef TryDemo_GenerateMovieFromImage_h
#define TryDemo_GenerateMovieFromImage_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

typedef void (^GenerateMovieWithImageCompletionBlock)(NSURL *movieURL);
typedef void (^LoadImageCompletionBlock)(CGImageRef image);

@interface GenerateMovieFromImage : NSObject

+ (void)generateMovieWithImage:(CGImageRef)image completionBlock:(GenerateMovieWithImageCompletionBlock)handler;
+ (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image;
//+ (void) createCGImageFromFile: (NSURL*)  url completionBlock: (LoadImageCompletionBlock)handler;
@end

#endif
