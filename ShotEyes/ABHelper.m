//
//  ABHelper.m
//  ShotEyes
//
//  Created by LI LIN on 14-8-2.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABHelper.h"

@implementation ABHelper

+ (void)showError:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"错误"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+ (NSString *) url:(NSString *)path params:(NSString *)params
{
    // TODO: get from define
    NSString *host = @"10.0.1.18";
    NSString *port = @"5001";
    
    // http://10.0.1.18:5001/login?name=admin&password=admin
    return [NSString stringWithFormat:@"http://%@:%@%@?%@", host, port, path, params];
}

@end
