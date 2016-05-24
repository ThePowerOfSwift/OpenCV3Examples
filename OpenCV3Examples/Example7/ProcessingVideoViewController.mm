//
//  ProcessingVideoViewController.m
//  OpenCVExamples
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "ProcessingVideoViewController.h"
#import <mach/mach_time.h> 

/*
 Frameworks: UIKit, Foundation, CoreGraphics, QuartzCore, CoreImage, Accelerate, AssetsLibrary
 */

@interface ProcessingVideoViewController ()

@end

@implementation ProcessingVideoViewController
@synthesize imageView;
@synthesize startCaptureButton;
@synthesize toolbar;
@synthesize videoCamera;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize camera
    videoCamera = [[CvVideoCamera alloc]
                   initWithParentView:imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.recordVideo = YES; //Record video
    
    isCapturing = NO;
    
    // Load textures
    UIImage* resImage = [UIImage imageNamed:@"scratches.png"];
    UIImageToMat(resImage, params.scratches);
    
    resImage = [UIImage imageNamed:@"fuzzyBorder.png"];
    UIImageToMat(resImage, params.fuzzyBorder);
    
//    filter = nil;
    prevTime = mach_absolute_time();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // Only portrait orientation
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)startCaptureButtonPressed:(id)sender
{
    [videoCamera start];
    isCapturing = YES;
    
    params.frameSize = cv::Size(videoCamera.imageWidth,
                                videoCamera.imageHeight);
    
    if (!filter)
        filter = new RetroFilter(params);
}

-(IBAction)stopCaptureButtonPressed:(id)sender
{
    [videoCamera stop];
    isCapturing = NO;
}

-(IBAction)stopCaptureAndSaveVideoButtonPressed:(id)sender
{
    [videoCamera stop];
    
    NSString* relativePath = [videoCamera.videoFileURL relativePath];
    UISaveVideoAtPathToSavedPhotosAlbum(relativePath, nil, NULL, NULL);
    
    //Alert window
    UIAlertView *alert = [UIAlertView alloc];
    alert = [alert initWithTitle:@"Status"
                         message:@"Saved to the Gallery!"
                        delegate:nil
               cancelButtonTitle:@"Continue"
               otherButtonTitles:nil];
    [alert show];
    
    isCapturing = NO;
}

//TODO: may be remove this code
static double machTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom / 1e9;
}

// Macros for time measurements
#if 1
#define TS(name) int64 t_##name = cv::getTickCount()
#define TE(name) printf("TIMER_" #name ": %.2fms\n", \
1000.*((cv::getTickCount() - t_##name) / cv::getTickFrequency()))
#else
#define TS(name)
#define TE(name)
#endif

- (void)processImage:(cv::Mat&)image
{
    cv::Mat inputFrame = image;
    
    BOOL isNeedRotation = image.size() != params.frameSize;
    if (isNeedRotation)
        inputFrame = image.t();
    
    // Apply filter
    cv::Mat finalFrame;
    TS(ApplyingFilter);
    filter->applyToVideo(inputFrame, finalFrame);
    TE(ApplyingFilter);
    
    if (isNeedRotation)
        finalFrame = finalFrame.t();
    
    // Add fps label to the frame
    uint64_t currTime = mach_absolute_time();
    double timeInSeconds = machTimeToSecs(currTime - prevTime);
    prevTime = currTime;
    double fps = 1.0 / timeInSeconds;
    NSString* fpsString =
    [NSString stringWithFormat:@"FPS = %3.2f", fps];
    cv::putText(finalFrame, [fpsString UTF8String],
                cv::Point(30, 40), cv::FONT_HERSHEY_COMPLEX_SMALL,
                0.8, cv::Scalar::all(255));
    
    finalFrame.copyTo(image);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isCapturing)
    {
        [videoCamera stop];
    }
}

- (void)dealloc
{
    videoCamera.delegate = nil;
}

@end
