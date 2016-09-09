//
//  CameraManager.m
//  Trendify
//
//  Created by Hoangcv on 10/12/14.
//  Copyright (c) 2014 Hoangcv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraManager.h"

typedef enum {
    CurrentActiveCameraFront, CurrentActiveCameraBack
} CurrentActiveCamera;

typedef void(^OutputHandler)(UIImage* outputImg);
typedef void(^FailureHandler)();
typedef void(^FlashModeHandler)(AVCaptureFlashMode flashMode);
@interface CameraManager : NSObject

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (nonatomic, retain) UIImage *stillImage;//holds the captured image

- (id) initWithFeedInView:(UIView*)cameraView;

- (void)captureStillImageWithHandler:(OutputHandler) outputHandler failureHandler:(FailureHandler) failureHandler;

- (BOOL)applyZoomFactor:(CGFloat)zoomFactor;

- (void)setCameraPreview:(UIView*)preview;

- (void)startRunning;

- (void)stopRunning;

- (void)switchCamera;

- (void)switchFlashModeWithCompletionHandler:(FlashModeHandler) handler failureHandler:(FailureHandler)failureHandler;

- (CurrentActiveCamera)activeCamera;

- (BOOL)hasFlash;

//@property (nonatomic, weak) id<GZRCameraManagerDelegate> delegate;

@end
