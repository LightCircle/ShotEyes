//
//  ABSettingViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-8-1.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABSettingViewController.h"
#import "ABSettingViewCell.h"

@interface ABSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tblSetting;

@end

@implementation ABSettingViewController

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
    
    // TODO: 从设定文件里读取IP，端口
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ABSettingViewCell";
	ABSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imgIcon.image = [UIImage imageNamed:@"table_satellite-dish.png"];
            cell.lblTitle.text = @"地址";
            cell.lblValue.text = [DAConfigManager.defaults objectForKey:kConfigManagerServerName];
        }
        if (indexPath.row == 1) {
            cell.imgIcon.image = [UIImage imageNamed:@"table_lightbulb.png"];
            cell.lblTitle.text = @"端口";
            cell.lblValue.text = [DAConfigManager.defaults objectForKey:kConfigManagerServerPort];
        }
    }
    
    if (indexPath.section == 1) {
        cell.imgIcon.image = [UIImage imageNamed:@"table_entrance.png"];
        cell.lblTitle.text = @"注销";
        cell.lblValue.text = @"";
    }
    
    if (indexPath.section == 2) {
        cell.imgIcon.image = [UIImage imageNamed:@"table_anchor.png"];
        cell.lblTitle.text = @"版本信息";
        cell.lblValue.text = @"v1.0.0";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [DAConfigManager.defaults removeObjectForKey:kConfigManagerUserID];
        [DAConfigManager.defaults removeObjectForKey:kConfigManagerCookie];
        [DAConfigManager.defaults removeObjectForKey:kConfigManagerCsrfToken];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationNameNeedsLogin object:nil]];
    }
}


@end
