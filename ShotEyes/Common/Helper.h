//
//  Helper.h
//  ShotEyes
//
//  Created by LI LIN on 14/10/28.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (void)fetchTag:(void (^)())callback;
+ (void)startLoadingAnimated: (UIView *)view;
+ (void)stopLoadingAnimated: (UIView *)view;

@end
