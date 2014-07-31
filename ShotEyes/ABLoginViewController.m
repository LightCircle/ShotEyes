//
//  ABLoginViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABLoginViewController.h"

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



//AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//[manager GET:@"http://127.0.0.1:5001/login?name=admin&password=admin"
//  parameters:nil
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//         
//         NSDictionary *aaa = responseObject[@"data"];
//         NSLog(@"responseObject: %@", [aaa objectForKey:@"createAt"]);
//         
//         User *a = [[User alloc] initWithDictionary:aaa];
//         
//         NSLog(@"responseObject: %@", a._id);
//         
//         NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
//         NSLog(@"%@" ,[r allHeaderFields]);
//         
//         
//         
//     } failure:^(NSURLSessionDataTask *task, NSError *error) {
//         
//         NSLog(@"Error: %@", error);
//     }];

@end
