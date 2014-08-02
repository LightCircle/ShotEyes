//
//  ABReportListViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportListViewController.h"
#import "ABReportListViewCell.h"
#import <UIImageView+WebCache.h>
#import <DAConfigManager.h>
#import <AFHTTPSessionManager.h>

#define kHTTPHeaderCookieName   @"Set-Cookie"
#define kHTTPHeaderCsrftoken    @"csrftoken"

@interface ABReportListViewController ()
{
    NSArray             *list;
}

@end

@implementation ABReportListViewController

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
    
    NSString *cookie = [DAConfigManager.defaults objectForKey:kHTTPHeaderCookieName];
    SDWebImageDownloader *sd = [SDWebImageDownloader sharedDownloader];
    [sd setValue:cookie forHTTPHeaderField:kHTTPHeaderCookieName];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"http://10.0.1.18:5001/shot/list"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSDictionary *aaa = responseObject[@"data"];
             NSLog(@"responseObject: %@", aaa);
             
             list = [aaa objectForKey:@"items"];
             NSLog(@"responseObject: %@", list);
             
             [self.tblShotList reloadData];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             NSLog(@"Error: %@", error);
         }];
    

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ABReportListViewCell";
	ABReportListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//    {
//        cell = [[ABReportListViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:identifier];
//    }

//    [cell.imgShot sd_setImageWithURL:[NSURL URLWithString:@"http://127.0.0.1:5001/file/53d7bef0f40c1000004d5dcd"] placeholderImage:[UIImage imageNamed:@"IMG_2946_x.jpg"]];

    
    NSDictionary *row = [list objectAtIndex:indexPath.row];
    
    cell.txtTitle.text = [row objectForKey:@"title"];
    cell.txtMessage.text = [row objectForKey:@"message"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://10.0.1.18:5001/file/", [row objectForKey:@"image"]];
    NSLog(@"url: %@", url);
    
    [cell.imgShot sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.png"] options:SDWebImageHandleCookies];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DAGroupDetailViewController *groupDetailViewController =[[DAGroupDetailViewController alloc]initWithNibName:@"DAGroupDetailViewController" bundle:nil];
//    groupDetailViewController.hidesBottomBarWhenPushed = YES;
//    groupDetailViewController.gid = ((DAGroup *)[list objectAtIndex:indexPath.row])._id ;
//    
//    [self.navigationController pushViewController:groupDetailViewController animated:YES];
    
}

@end
