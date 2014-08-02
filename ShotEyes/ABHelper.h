//
//  ABHelper.h
//  ShotEyes
//
//  Created by LI LIN on 14-8-2.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DAConfigManager.h>

@interface ABHelper : NSObject

+ (void) showError:(NSString *)message;
+ (void)showInfo:(NSString *)message;

+ (NSString *) url:(NSString *)path params:(NSString *)params;
+ (NSString *) urlWithToken:(NSString *)path params:(NSString *)params;
+ (NSString*) encode:(NSString *)string;

+ (void)fetchTag:(void (^)())callback;

@end
