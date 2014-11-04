//
//  ABSettingViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABSettingViewController.h"
#import "ABSettingViewCell.h"
#import "Header.h"

@interface ABSettingViewController ()

@end

@implementation ABSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    if (section == 0 || section == 1) {
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
            cell.imgIcon.image = [UIImage imageNamed:@"radar-tower-7.png"];
            cell.lblTitle.text = @"地址";
            cell.lblValue.text = [ABConfigManager.defaults objectForKey:kConfigManagerServerName];
        }
        if (indexPath.row == 1) {
            cell.imgIcon.image = [UIImage imageNamed:@"lightbulb-7.png"];
            cell.lblTitle.text = @"端口";
            cell.lblValue.text = [ABConfigManager.defaults objectForKey:kConfigManagerServerPort];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.imgIcon.image = [UIImage imageNamed:@"arrow-repeat-two-7.png"];
            cell.lblTitle.text = @"更新分类";
            cell.lblValue.text = @"";
        }
        if (indexPath.row == 1) {
            cell.imgIcon.image = [UIImage imageNamed:@"door-in-7.png"];
            cell.lblTitle.text = @"注销";
            cell.lblValue.text = @"";
        }
    }
    
    if (indexPath.section == 2) {
        cell.imgIcon.image = [UIImage imageNamed:@"anchor-7.png"];
        cell.lblTitle.text = @"版本信息";
        cell.lblValue.text = [ABConfigManager.defaults objectForKey:@"CFBundleVersion"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [Helper fetchTag:^(){
                [ABHelper showInfo:@"更新成功"];
            }];
        }
        if (indexPath.row == 1) {
            [ABConfigManager.defaults removeObjectForKey:kConfigManagerUserID];
            [ABConfigManager.defaults removeObjectForKey:kConfigManagerCookie];
            [ABConfigManager.defaults removeObjectForKey:kConfigManagerCsrfToken];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationNameNeedsLogin object:nil]];
        }
    }

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
