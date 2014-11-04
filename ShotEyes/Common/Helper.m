//
//  Helper.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/28.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "Header.h"

@implementation Helper

+ (void)fetchTag:(void (^)())callback
{
    NSString *user = [ABConfigManager.defaults objectForKey:kConfigManagerUserID];
    if (user == nil) {
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[ABHelper url:@"/tag/list" params:nil]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSError *error;
             TagList *tagList = [[TagList alloc] initWithDictionary:responseObject[@"data"] error:&error];
             [ABStorable store:tagList withKey:kStorableKeyTagList];
             if (callback) {
                 callback();
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ABHelper showError:error.description];
         }];
}

+ (void)startLoadingAnimated: (UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)stopLoadingAnimated: (UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
