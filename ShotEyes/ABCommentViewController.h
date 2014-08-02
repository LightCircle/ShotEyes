//
//  ABCommentViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ABCommentViewControllerComplet)(NSString *, NSString *);

@interface ABCommentViewController : UIViewController
@property (strong, nonatomic) ABCommentViewControllerComplet onComplet;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *message;
@end
