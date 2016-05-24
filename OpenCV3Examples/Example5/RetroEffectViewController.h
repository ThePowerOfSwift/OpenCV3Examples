//
//  RetroEffectViewController.h
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/17/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetroFilter.hpp"

@interface RetroEffectViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController* popoverController;
    UIImageView* imageView;
    UIImage* image;
    RetroFilter::Parameters params;
}
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) UIPopoverController* popoverController;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* loadButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* saveButton;

-(IBAction)loadButtonPressed:(id)sender;
-(IBAction)saveButtonPressed:(id)sender;

- (UIImage*)applyFilter:(UIImage*)image;
@end
