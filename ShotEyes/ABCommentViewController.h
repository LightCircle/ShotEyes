//
//  ABCommentViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ABCommentViewControllerComplet)(NSString *);

@interface ABCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) ABCommentViewControllerComplet onComplet;

@end
