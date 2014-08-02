//
//  ABCanvasImageView.h
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCanvasImageView : UIImageView

@property (nonatomic) BOOL isImageSelected;
@property (nonatomic) UIColor *penColor;
@property (nonatomic) NSNumber *penBold;

@end
