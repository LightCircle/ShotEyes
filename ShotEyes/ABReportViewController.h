//
//  ABReportViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCanvasImageView.h"

@interface ABReportViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)onPhotoLibraryClicked:(id)sender;
- (IBAction)onCameraClicked:(id)sender;
- (IBAction)onRefreshClicked:(id)sender;
- (IBAction)onReportClicked:(id)sender;
@property (weak, nonatomic) IBOutlet ABCanvasImageView *imgAttach;
- (IBAction)onCategoryClicked:(id)sender;

@end
