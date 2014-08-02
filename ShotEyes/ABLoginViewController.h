//
//  ABLoginViewController.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABHeader.h"

typedef void (^ABLoginViewControllerComplet)();

@interface ABLoginViewController : UIViewController
@property (strong, nonatomic) ABLoginViewControllerComplet onComplet;
@end
