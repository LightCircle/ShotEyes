//
//  ABLoginViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABLoginViewController.h"
#import <AFHTTPSessionManager.h>
#import "Entities.h"
#import <DAConfigManager.h>

@interface ABLoginViewController ()

@end

@implementation ABLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#define kHTTPHeaderCookieName   @"Set-Cookie"
#define kHTTPHeaderCsrftoken    @"csrftoken"

- (IBAction)onLoginClicked:(id)sender
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:@"http://10.0.1.18:5001/login?name=admin&password=admin"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {

             NSDictionary *aaa = responseObject[@"data"];
             NSLog(@"responseObject: %@", [aaa objectForKey:@"createAt"]);

             User *a = [[User alloc] initWithDictionary:aaa];

             NSLog(@"responseObject: %@", a._id);

             NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
             NSLog(@"%@" ,[r allHeaderFields]);
             
             
             NSString *cookie = [DAConfigManager.defaults objectForKey:kHTTPHeaderCookieName];
             NSString *csrftoken = [DAConfigManager.defaults objectForKey:kHTTPHeaderCsrftoken];
             NSLog(@"cookie: %@", cookie);
             NSLog(@"csrftoken: %@", csrftoken);

             [DAConfigManager.defaults setObject:[[r allHeaderFields] objectForKey:kHTTPHeaderCookieName] forKey:kHTTPHeaderCookieName];
             [DAConfigManager.defaults setObject:[[r allHeaderFields] objectForKey:kHTTPHeaderCsrftoken] forKey:kHTTPHeaderCsrftoken];
             
             [self.view removeFromSuperview];

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             NSLog(@"Error: %@", error);
         }];
}
@end
