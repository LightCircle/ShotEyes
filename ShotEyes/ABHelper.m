//
//  ABHelper.m
//  ShotEyes
//
//  Created by LI LIN on 14-8-2.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABHelper.h"
#import "ABHeader.h"

@implementation ABHelper

+ (void)showError:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"错误"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+ (void)showInfo:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+ (NSString *) url:(NSString *)path params:(NSString *)params
{
    // TODO: get from define
    NSString *host = [DAConfigManager.defaults objectForKey:kConfigManagerServerName];
    NSString *port = [DAConfigManager.defaults objectForKey:kConfigManagerServerPort];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@%@", host, port, path];
    if (params) {
        url = [NSString stringWithFormat:@"http://%@:%@%@?%@", host, port, path, params];
    }

    return url;
}

+ (NSString *) urlWithToken:(NSString *)path params:(NSString *)params
{
    // TODO: get from define
    NSString *host = [DAConfigManager.defaults objectForKey:kConfigManagerServerName];
    NSString *port = [DAConfigManager.defaults objectForKey:kConfigManagerServerPort];
    NSString *token = [ABHelper encode:[DAConfigManager.defaults objectForKey:kConfigManagerCsrfToken]];

    NSString *url = [NSString stringWithFormat:@"http://%@:%@%@?_csrf=%@", host, port, path, token];
    if (params) {
        url = [[url stringByAppendingString:@"&"] stringByAppendingString:params];
    }
    
    return url;
}

+ (NSString*) encode:(NSString *)string
{
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)string,
                                                                                NULL,
                                                                                (CFStringRef)@"!*'();:@&=+$,./?%#[]",
                                                                                kCFStringEncodingUTF8);
}

+ (void)fetchTag:(void (^)())callback
{
    NSString *user = [DAConfigManager.defaults objectForKey:kConfigManagerUserID];
    if (user == nil) {
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[ABHelper url:@"/tag/list" params:nil]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             TagList *tagList = [[TagList alloc] initWithDictionary:responseObject[@"data"]];
             [DAStorable store:tagList withKey:kStorableKeyTagList];
             if (callback) {
                 callback();
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ABHelper showError:error.description];
         }];
}

+ (NSDate *) dateFromISODateString:(NSString *)isodate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    return [dateFormatter dateFromString:isodate];
}

+ (NSString *) stringFromISODate:(NSDate *)isodate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm"];
    return [format stringFromDate:isodate];
}

+ (NSString *) stringFromISODateString:(NSString *)isodate
{
    NSDate *date = [ABHelper dateFromISODateString:isodate];
    return [ABHelper stringFromISODate:date];
}


@end
