//
//  ABReportListViewCell.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABReportListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgShot;
@property (weak, nonatomic) IBOutlet UILabel *txtMessage;
@property (weak, nonatomic) IBOutlet UILabel *txtAt;
@property (weak, nonatomic) IBOutlet UILabel *txtTag;
@property (weak, nonatomic) NSString *messageId;

@end
