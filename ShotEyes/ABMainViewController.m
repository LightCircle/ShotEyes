//
//  ABMainViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABMainViewController.h"
#import "Header.h"
#import "LoginViewController.h"

@interface ABMainViewController ()

@end

@implementation ABMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 注册登陆页面的显示
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(notificationShowLogin:) name:kNotificationNameNeedsLogin object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *user = [ABConfigManager.defaults objectForKey:kConfigManagerUserID];
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
    LoginViewController *loginViewController = [LoginViewController loadFromNib];
    
    [loginViewController setLogo:[UIImage imageNamed:@"Login.png"]];
    [loginViewController.view setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    
    // 登陆成功，获取tag
    loginViewController.onComplet = ^(){
        [Helper fetchTag:nil];
    };
}

@end
