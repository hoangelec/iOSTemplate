//
//  CameraManager.m
//  Trendify
//
//  Created by Hoangcv on 10/12/14.
//  Copyright (c) 2014 Hoangcv. All rights reserved.
//

#import "CameraManager.h"
#import <ImageIO/ImageIO.h>

@interface CameraManager()

@property (nonatomic, strong) AVCaptureDevice *frontCamera;
@property (nonatomic, strong) AVCaptureDevice *backCamera;
@property (strong) AVCaptureStillImageOutput *stillImageOutput;


@end

@implementation CameraManager
@synthesize previewLayer, stillImage;

#pragma mark - Capture Session configuration

/**
 *  Init the camera manager
 *
 *  @param cameraView the view that the feeding content will be displayed
 *
 *  @return nil if initialization fails
 */
- (id) initWithFeedInView:(UIView*)cameraView {
    
    self = [super init];
    if (self) {
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
        
        if (![self addVideoPreviewLayer]) {
            return nil;
        };
        
        if (![self addVideoInput]) {
            return nil;
        }
        
        [self addStillImageOutput];
        
        [self.previewLayer setFrame:cameraView.bounds];
        [cameraView.layer addSublayer:self.previewLayer];
    }
    return self;
}

/**
 *  Add video feed to the target view
 *
 *  @param preview The view to display the video feed
 */
- (void) setCameraPreview:(UIView*)cameraView {
    [self.previewLayer setFrame:cameraView.bounds];
    [cameraView.layer addSublayer:self.previewLayer];
}

/**
 *  Config video quality and preview layer dislay
 *
 *  @return NO if unsuccessful
 */
- (BOOL) addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
    if ([[self captureSession] canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self captureSession].sessionPreset = AVCaptureSessionPresetHigh;
    } else {
        return NO;
    }
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];//set the preview scene
    return YES;
}

/**
 *  add Video input for camera, which are front and back camera
 *
 *  @return NO if unsuccessful
 */
- (BOOL)addVideoInput{
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *dev in videoDevices) {
        if (dev.position == AVCaptureDevicePositionFront) {
            self.frontCamera = dev;
        } else if (dev.position == AVCaptureDevicePositionBack) {
            self.backCamera = dev;
        }
    }
    
    
    AVCaptureDevice *defaultVideoDevice = self.backCamera;
    
//    //The setting manager must exists for settings configurations
//    if (self.settingManager) {
//        NSError *lockError = nil;
//        [videoDevice lockForConfiguration:&lockError];
//        if (!lockError) {
//            if ([videoDevice isFocusModeSupported:[self.settingManager focusMode]]) {
//                [videoDevice setFocusMode:[self.settingManager focusMode]];
//            } else {
//                DLog(@"Cannot set focus mode");
//                *error = [NSError new];
//            }
//            
//            if ([videoDevice isWhiteBalanceModeSupported:[self.settingManager whiteBalanceMode]]) {
//                [videoDevice setWhiteBalanceMode:[self.settingManager whiteBalanceMode]];
//            } else {
//                DLog(@"Cannot set white balance mode");
//                *error = [NSError new];
//            }
//            
//            if ([videoDevice isExposureModeSupported:[self.settingManager exposureMode]]) {
//                [videoDevice setExposureMode:[self.settingManager exposureMode]];
//            } else {
//                DLog(@"Cannot set exposure mode");
//                *error = [NSError new];
//            }
//            
//            if ([videoDevice isFocusPointOfInterestSupported]) {
//                [videoDevice setFocusPointOfInterest:[self.settingManager focusPoint]];
//            } else {
//                DLog(@"Cannot set focus point");
//                *error = [NSError new];
//            }
//            
//            [videoDevice unlockForConfiguration];
//        } else {
//            DLog(@"Cannot lock camera for configuration");
//            *error = [NSError new];
//        }
//        
//    } else {
//        if (error) {
//        *error = [NSError new];
//        }
//    }
    
    //videoDevice can be has successfully be configged
	if (defaultVideoDevice) {
        
		NSError *deviceError;
        
        if ([self hasFlash]) {
            if (![self applyFlashMode:AVCaptureFlashModeAuto]) {
                DLog(@"Couldn't apply Auto Flash Mode at first use");
                return NO;
            }
        }
        
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:defaultVideoDevice error:&deviceError];
		if (!deviceError) {
			if ([[self captureSession] canAddInput:videoIn]) {
				[[self captureSession] addInput:videoIn];
            }
			else {
				DLog(@"Couldn't add video input");
                return NO;
            }
		}
		else {
			DLog(@"Couldn't create video input");
            return NO;
        }
	}
	else {
		DLog(@"Couldn't create video capture device");
        return NO;
    }
    return YES;
}

/**
 *  config output image
 */
- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

#pragma mark - Camera functionalities
/**
 *  Apply zoom factor to camera
 *
 *  @param zoomFactor zoom factor to be apply
 *
 *  @return NO if unsuccessful
 */
- (BOOL)applyZoomFactor:(CGFloat)zoomFactor {
    //get the default camera and config its zoom factor
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *lockError = nil;
    [videoDevice lockForConfiguration:&lockError];
    if (!lockError) {
        //check again for any changes of the device
        if (zoomFactor >= 1 && videoDevice.activeFormat.videoMaxZoomFactor >= zoomFactor) {
            [videoDevice setVideoZoomFactor:zoomFactor];
            DLog(@"Configured zoom factor successfully");
        } else {
            DLog(@"Cannot set zoom factor");
            return NO;
        }
        [videoDevice unlockForConfiguration];
    } else {
        DLog(@"Failed to lock device");
    }
    return YES;
}

/**
 *  Apply flash mode for back camera only
 *
 *  @return YES if successful
 */
- (BOOL)applyFlashMode:(AVCaptureFlashMode)flashMode {
    //get the default camera and config its zoom factor
    NSError *lockError;
    [_backCamera lockForConfiguration:&lockError];
    if (!lockError) {
        //check again for any changes of the device
        if ([self.backCamera hasFlash]) {
            [self.backCamera setFlashMode:flashMode];
            DLog(@"Configured flash mode successfully");
        } else {
            DLog(@"Cannot set flash mode");
            return NO;
        }
        [self.backCamera unlockForConfiguration];
    } else {
        DLog(@"Failed to lock device");
        return NO;
    }
    return YES;
}

/**
 *  Capture the image from camera
 *
 *  @param outputHandler - block that handles the output image
 *  @param failureHandler - block used when capturing fails
 */
- (void)captureStillImageWithHandler:(OutputHandler) outputHandler failureHandler:(FailureHandler) failureHandler
{

	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
		for (AVCaptureInputPort *port in [connection inputPorts])
        {
			if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                if ([connection isVideoOrientationSupported]) {
                    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                }
				videoConnection = connection;

				break;
			}
		}
		if (videoConnection) {
            break;
        }
        DLog(@"captureStillImage");
	}
    
	DLog(@"about to request a capture from: %@", [self stillImageOutput]);

    __weak CameraManager *weakSelf = self;
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
     
    completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        //Check exifAttachments to stop warning
        if (exifAttachments)
        {
//            DLog(@"attachements: %@", exifAttachments);
        } else
        {
//            DLog(@"no attachments");
        }
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
//            DLog(@"image size: width: %f - height: %f", image.size.width, image.size.height);

            [weakSelf setStillImage:image];
            
            if (outputHandler) {
                outputHandler(weakSelf.stillImage);
            }
            
        } else {
            DLog(@"Captured image failed");
            if (failureHandler) {
                failureHandler();
            }
        }
    }];

}
/**
 *  start the camera
 */
- (void)startRunning {
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (void)stopRunning {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

/**
 *  Switch between front and back camera
 */
- (void)switchCamera {
    AVCaptureDeviceInput *currentVideoInput;
    AVCaptureDevice *targetCamera;
    AVCaptureDeviceInput *newVideoInput;
    
    //Get the input device being used
    for (AVCaptureDeviceInput *devInput in self.captureSession.inputs) {
        
        if (devInput.device == self.frontCamera) {
            currentVideoInput = devInput;
            
            targetCamera = self.backCamera;
            break;
        } else if (devInput.device == self.backCamera) {
            currentVideoInput = devInput;
            
            targetCamera = self.frontCamera;
            break;
        }
    }
    
    //Check if the target camera is available before switching
    newVideoInput = [self videoInputForDevice:targetCamera];
    
    if (newVideoInput) {
        [self.captureSession beginConfiguration];
        
        [self.captureSession removeInput:currentVideoInput];
        if ([self.captureSession canAddInput:newVideoInput]) {
            [self.captureSession addInput:newVideoInput];
        } else {
            [self.captureSession addInput:currentVideoInput];
            DLog(@"Cannot switch camera");
        }
        [self.captureSession commitConfiguration];
    }
}

/**
 *  Get the camera input for the camera device
 *
 *  @param dev - the target camera
 *
 *  @return input instance if successful, nil otherwise
 */
- (AVCaptureDeviceInput*)videoInputForDevice:(AVCaptureDevice*)dev {
    
    //Is device is null, return NO immediately
    if (!dev) {
        return nil;
    }
    
    NSError *error;
    AVCaptureDeviceInput *devInput = [AVCaptureDeviceInput deviceInputWithDevice:dev error:&error];
    
    if (error) {
        return nil;
    } else {

        return devInput;
    }
}

/**
 *  switch back camera's flash mode. Must use [self hasFlash] to check if the device has flash or not before calling
 *
 *  @param successHandler - handle the returned flash mode after switching
 *  @param failureHandler - handle error when flash mode can not be switch
 */
- (void)switchFlashModeWithCompletionHandler:(FlashModeHandler)successHandler failureHandler:(FailureHandler)failureHandler {
    bool applySuccess = NO;
    AVCaptureFlashMode newMode;
    
    AVCaptureFlashMode flashMode = [self.backCamera flashMode];
    switch (flashMode) {
        case AVCaptureFlashModeOff:
            newMode = AVCaptureFlashModeOn;
            break;
        case AVCaptureFlashModeOn:
            newMode = AVCaptureFlashModeAuto;
            break;
        case AVCaptureFlashModeAuto:
            newMode = AVCaptureFlashModeOff;
            break;
    }
    
    applySuccess = [self applyFlashMode:newMode];
    
    if (applySuccess) {
        if (successHandler) {
            successHandler(newMode);
        }
    } else {
        if (failureHandler) {
            failureHandler();
        }
    }
}

/**
 *  Get the currently active camera
 *
 *  @return corressponding enum
 */
- (CurrentActiveCamera)activeCamera {
    for (AVCaptureDeviceInput *devInput in self.captureSession.inputs) {
        
        if (devInput.device == self.frontCamera) {
            return CurrentActiveCameraFront;
        } else if (devInput.device == self.backCamera) {
            return CurrentActiveCameraBack;
        }
    }
    return CurrentActiveCameraFront;
}

/**
 *  determine if the back camera has flash or not
 *
 *  @return <#return value description#>
 */
- (BOOL)hasFlash {
    return [self.backCamera hasFlash];
}

/**
 *  Get the current flash mode of the back camera
 *
 *  @return corresponding AVCaptureFlashMode)
 */
- (AVCaptureFlashMode)currentFlashMode {
    return [self.backCamera flashMode];
}

@end
