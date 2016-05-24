//
//  ViewController.m
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/16/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "LinkingViewController.h"
#import <opencv2/imgcodecs/ios.h>

using namespace cv;

/*
 Frameworks: UIKit, Foundation, CoreGraphics
 Ref: http://docs.opencv.org/2.4/doc/tutorials/imgproc/gausian_median_blur_bilateral_filter/gausian_median_blur_bilateral_filter.html
 */

@interface LinkingViewController () {
    Mat cvImage;
}

@end

@implementation LinkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"lena.png"];
    _originImageView.image = image;
    
    // Convert UIImage* to cv::Mat
    UIImageToMat(image, cvImage);
    
    if (/* DISABLES CODE */ (0))
    {
        NSString* filePath = [[NSBundle mainBundle]
                              pathForResource:@"lena" ofType:@"png"];
        // Create file handle
        NSFileHandle* handle =
        [NSFileHandle fileHandleForReadingAtPath:filePath];
        // Read content of the file
        NSData* data = [handle readDataToEndOfFile];
        // Decode image from the data buffer
        cvImage = cv::imdecode(Mat(1, (int)[data length], CV_8UC1,
                                       (void*)data.bytes),
                               CV_LOAD_IMAGE_UNCHANGED);
    }
    
    if (/* DISABLES CODE */ (0))
    {
        NSData* data = UIImagePNGRepresentation(image);
        // Decode image from the data buffer
        cvImage = cv::imdecode(Mat(1, [data length], CV_8UC1,
                                       (void*)data.bytes),
                               CV_LOAD_IMAGE_UNCHANGED);
    }
    
    if (!cvImage.empty())
    {
        Mat gray;
        // Convert the image to grayscale
        cvtColor(cvImage, gray, CV_RGBA2GRAY);
        // Apply Gaussian filter to remove small edges
        GaussianBlur(gray, gray,
                     cv::Size(5, 5), 1.2, 1.2);
        // Calculate edges with Canny
        Mat edges;
        Canny(gray, edges, 0, 50);
        // Fill image with white color
        cvImage.setTo(Scalar::all(255));
        // Change color on edges
        cvImage.setTo(Scalar(0, 128, 255, 255), edges);
        // Convert cv::Mat to UIImage* and show the resulting image
        _processedImageView.image = MatToUIImage(cvImage);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
