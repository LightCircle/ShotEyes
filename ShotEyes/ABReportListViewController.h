//
//  ABReportListViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABReportListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//- (void)onImageViewTouched: (UITapGestureRecognizer *)sender;
- (IBAction)onTagListTouched:(id)sender;

@end
