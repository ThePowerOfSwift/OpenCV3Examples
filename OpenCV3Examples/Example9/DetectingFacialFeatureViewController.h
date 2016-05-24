//
//  DetectingFacialFeatureViewController.h
//  OpenCVExamples
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import "RetroFilter.hpp"
#import "FaceAnimator.hpp"

@interface DetectingFacialFeatureViewController : UIViewController<CvVideoCameraDelegate>
{
    CvVideoCamera* videoCamera;
    BOOL isCapturing;
    
    FaceAnimator::Parameters parameters;
    cv::Ptr<FaceAnimator> faceAnimator;
}

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* startCaptureButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* stopCaptureButton;

-(IBAction)startCaptureButtonPressed:(id)sender;
-(IBAction)stopCaptureButtonPressed:(id)sender;

@end
