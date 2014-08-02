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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册登陆页面的显示
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(notificationShowLogin:) name:kNotificationNameNeedsLogin object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *user = [DAConfigManager.defaults objectForKey:kConfigManagerUserID];
    if (user == nil) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationNameNeedsLogin object:nil]];
    }
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Functions

// 处理未登录通知
- (void)notificationShowLogin:(NSNotification*)note
{
    // TODO: 动画显示
    ABLoginViewController *loginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ABLoginViewController"];
    
    [loginViewController.view setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    
    // 登陆成功，获取tag
    loginViewController.onComplet = ^(){
        [ABHelper fetchTag:nil];
    };
}

@end
