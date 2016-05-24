//
//  TakingPhotoFromCameraViewController.h
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import "RetroFilter.hpp"

@interface TakingPhotoFromCameraViewController : UIViewController <CvPhotoCameraDelegate> {
    CvPhotoCamera* photoCamera;
    UIImageView* resultView;
    RetroFilter::Parameters params;
}
@property (nonatomic, strong) CvPhotoCamera* photoCamera;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* takePhotoButton;
@property (nonatomic, weak) IBOutlet
UIBarButtonItem* startCaptureButton;

-(IBAction)takePhotoButtonPressed:(id)sender;
-(IBAction)startCaptureButtonPressed:(id)sender;

- (UIImage*)applyEffect:(UIImage*)image;
@end
