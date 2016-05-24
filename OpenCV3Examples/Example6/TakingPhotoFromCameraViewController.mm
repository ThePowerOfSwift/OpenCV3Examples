//
//  TakingPhotoFromCameraViewController.m
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "TakingPhotoFromCameraViewController.h"
#import <opencv2/imgcodecs/ios.h>

/*
 Frameworks: UIKit, Foundation, CoreGraphics, QuartzCore, CoreImage, Accelerate
 */

@interface TakingPhotoFromCameraViewController ()

@end

@implementation TakingPhotoFromCameraViewController
@synthesize imageView;
@synthesize toolbar;
@synthesize photoCamera;
@synthesize takePhotoButton;
@synthesize startCaptureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize camera
    photoCamera = [[CvPhotoCamera alloc]
                   initWithParentView:imageView];
    photoCamera.delegate = self;
    photoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionFront;
    photoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPresetPhoto;
    photoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    
    // Load images
    UIImage* resImage = [UIImage imageNamed:@"scratches.png"];
    UIImageToMat(resImage, params.scratches);
    
    resImage = [UIImage imageNamed:@"fuzzyBorder.png"];
    UIImageToMat(resImage, params.fuzzyBorder);
    
    [takePhotoButton setEnabled:NO];
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

-(IBAction)takePhotoButtonPressed:(id)sender;
{
    [photoCamera takePicture];
}

-(IBAction)startCaptureButtonPressed:(id)sender;
{
    [photoCamera start];
    [self.view addSubview:imageView];
    [takePhotoButton setEnabled:YES];
    [startCaptureButton setEnabled:NO];
}

- (UIImage*)applyEffect:(UIImage*)image;
{
    cv::Mat frame;
    UIImageToMat(image, frame);
    NSLog(@"%d - %d",frame.size().width,frame.size().height);
    params.frameSize = frame.size();
    RetroFilter retroFilter(params);
    
    cv::Mat finalFrame;
    retroFilter.applyToPhoto(frame, finalFrame);
    
    UIImage* result = MatToUIImage(finalFrame);
    return [UIImage imageWithCGImage:[result CGImage]
                               scale:1.0
                         orientation:UIImageOrientationLeftMirrored];
}

- (void)photoCamera:(CvPhotoCamera*)camera capturedImage:(UIImage *)image;
{
    [camera stop];
    NSLog(@"%lf - %lf",imageView.bounds.size.width,imageView.bounds.size.height);
    resultView = [[UIImageView alloc] initWithFrame:imageView.bounds];
    
    UIImage* result = [self applyEffect:image];
    
    [resultView setImage:result];
    [self.view addSubview:resultView];
    
    [takePhotoButton setEnabled:NO];
    [startCaptureButton setEnabled:YES];
}

- (void)photoCameraCancel:(CvPhotoCamera*)camera;
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [photoCamera stop];
}

- (void)dealloc
{
    photoCamera.delegate = nil;
}

@end
