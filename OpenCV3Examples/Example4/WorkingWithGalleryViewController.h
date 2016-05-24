//
//  WorkingWithGalleryViewController.h
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/16/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkingWithGalleryViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
    UIPopoverController* popoverController;
    UIImageView* imageView;
    UIImage* postcardImage;
    cv::CascadeClassifier faceDetector;
}

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) UIPopoverController* popoverController;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* loadButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* saveButton;

-(IBAction)loadButtonPressed:(id)sender;
-(IBAction)saveButtonPressed:(id)sender;

- (UIImage*)printPostcard:(UIImage*)image;

@end
