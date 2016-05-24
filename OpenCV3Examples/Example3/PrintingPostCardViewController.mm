//
//  PrintingPostCardViewController.m
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/16/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "PrintingPostCardViewController.h"
#import "PostcardPrinter.hpp"
#import <opencv2/imgcodecs/ios.h>

/*
 Frameworks: UIKit, Foundation, CoreGraphics
 Ref: http://docs.opencv.org/2.4/modules/imgproc/doc/imgproc.html
 */

@interface PrintingPostCardViewController ()

@end

@implementation PrintingPostCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PostcardPrinter::Parameters params;
    
    // Load image with face
    UIImage* image = [UIImage imageNamed:@"lena.png"];
    UIImageToMat(image, params.face);
    
    // Load image with texture
    image = [UIImage imageNamed:@"texture.jpg"];
    UIImageToMat(image, params.texture);
    cvtColor(params.texture, params.texture, CV_RGBA2RGB);
    
    // Load image with text
    image = [UIImage imageNamed:@"text.png"];
    UIImageToMat(image, params.text, true);
    
    // Create PostcardPrinter class
    PostcardPrinter postcardPrinter(params);
    
    // Print postcard, and measure printing time
    cv::Mat postcard;
    int64 timeStart = cv::getTickCount();
    postcardPrinter.print(postcard);
    int64 timeEnd = cv::getTickCount();
    float durationMs =
    1000.f * float(timeEnd - timeStart) / cv::getTickFrequency();
    NSLog(@"Printing time = %.3fms", durationMs);
    
    if (!postcard.empty())
        _imageView.image = MatToUIImage(postcard);
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

@end
