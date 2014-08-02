//
//  ABMainViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-8-1.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABMainViewController.h"
#import "ABLoginViewController.h"

@interface ABMainViewController ()

@end

@implementation ABMainViewController

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
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(notificationShowLogin:) name:@"NeedsLogin" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NeedsLogin" object:nil]];
    [super viewDidAppear:animated];
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

// 接受通知
- (void)notificationShowLogin:(NSNotification*)note
{
    // TODO: 动画显示
    ABLoginViewController *loginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ABLoginViewController"];
    
//    ABLoginViewController *loginViewController = [[ABLoginViewController alloc]initWithNibName:@"DALoginViewController" bundle:nil];
    [loginViewController.view setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
}

@end
