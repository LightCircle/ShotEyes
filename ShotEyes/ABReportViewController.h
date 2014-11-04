//
//  ABReportViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCanvasImageView.h"

@interface ABReportViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (IBAction)onCameraTouched:(id)sender;
@property (weak, nonatomic) IBOutlet ABCanvasImageView *imageView;
@end
