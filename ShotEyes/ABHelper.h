//
//  ABHelper.h
//  ShotEyes
//
//  Created by LI LIN on 14-8-2.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABHelper : NSObject

+ (void) showError:(NSString *)message;

+ (NSString *) url:(NSString *)path params:(NSString *)params;

@end
