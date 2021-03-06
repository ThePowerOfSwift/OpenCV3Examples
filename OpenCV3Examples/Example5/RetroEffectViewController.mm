//
//  RetroEffectViewController.m
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "RetroEffectViewController.h"
#import <opencv2/imgcodecs/ios.h>

/*
 Frameworks: UIKit, Foundation, CoreGraphics
 */

@interface RetroEffectViewController ()

@end

@implementation RetroEffectViewController
@synthesize imageView;
@synthesize loadButton;
@synthesize saveButton;
@synthesize popoverController;
@synthesize toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load images
    UIImage* resImage = [UIImage imageNamed:@"scratches.png"];
    UIImageToMat(resImage, params.scratches);
    
    resImage = [UIImage imageNamed:@"fuzzyBorder.png"];
    UIImageToMat(resImage, params.fuzzyBorder);
    
    [saveButton setEnabled:NO];
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

- (UIImage*)applyFilter:(UIImage*)inputImage;
{
    cv::Mat frame;
    UIImageToMat(inputImage, frame);
    
    params.frameSize = frame.size();
    RetroFilter retroFilter(params);
    
    cv::Mat finalFrame;
    retroFilter.applyToPhoto(frame, finalFrame);
    
    return MatToUIImage(finalFrame);
}

- (void)imagePickerController: (UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad)
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES
                                   completion:nil];
    }
    
    UIImage* temp =
    [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    image = [self applyFilter:temp];
    imageView.image = image;
    
    [saveButton setEnabled:YES];
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad)
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)loadButtonPressed:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    
    UIImagePickerController* picker =
    [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad)
    {
        if ([self.popoverController isPopoverVisible])
        {
            [self.popoverController dismissPopoverAnimated:YES];
        }
        else
        {
            self.popoverController =
            [[UIPopoverController alloc]
             initWithContentViewController:picker];
            
            popoverController.delegate = self;
            
            [self.popoverController
             presentPopoverFromBarButtonItem:sender
             permittedArrowDirections:UIPopoverArrowDirectionDown
             animated:YES];
        }
    }
    else
    {
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (image != nil)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        
        //Alert window
        UIAlertView *alert = [UIAlertView alloc];
        alert = [alert initWithTitle:@"Status"
                             message:@"Saved to the Gallery!"
                            delegate:nil
                   cancelButtonTitle:@"Continue"
                   otherButtonTitles:nil];
        [alert show];
    }
}

@end
