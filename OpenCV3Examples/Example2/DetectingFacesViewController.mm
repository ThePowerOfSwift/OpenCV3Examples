//
//  DetectingFacesViewController.m
//  OpenCVExample
//
//  Created by Pham Chi Cong on 5/16/16.
//  Copyright © 2016 Transcosmos Technologic Arts. All rights reserved.
//

#import "DetectingFacesViewController.h"
#import <opencv2/imgcodecs/ios.h>

/*
 Frameworks: UIKit, Foundation, CoreGraphics
 Ref: http://docs.opencv.org/2.4/doc/tutorials/objdetect/cascade_classifier/cascade_classifier.html
 */

@interface DetectingFacesViewController () {
    cv::CascadeClassifier faceDetector;
}

@end

@implementation DetectingFacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load cascade classifier from the XML file
    NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource:@"haarcascade_frontalface_alt"
                             ofType:@"xml"];
    faceDetector.load([cascadePath UTF8String]);
    
    //Load image with face
    UIImage* leftImage = [UIImage imageNamed:@"lena.png"];
    _leftImageView.image = [self processFaceImage:leftImage];
    
    UIImage* rightImage = [UIImage imageNamed:@"mona_lisa.png"];
    // Show resulting image
    _rightImageView.image = [self processFaceImage:rightImage];
}

- (UIImage*)processFaceImage:(UIImage*)image {
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    // Convert to grayscale
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // Detect faces
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(gray, faces, 1.1,
                                  2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    
    // Draw all detected faces
    for(unsigned int i = 0; i < faces.size(); i++)
    {
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point tl(face.x, face.y);
        cv::Point br = tl + cv::Point(face.width, face.height);
        
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(faceImage, tl, br, magenta, 4, 8, 0);
    }
    
    // Return resulting image
    return MatToUIImage(faceImage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
