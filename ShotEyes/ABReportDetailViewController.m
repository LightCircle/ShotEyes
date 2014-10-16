//
//  ABReportDetailViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-8-3.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportDetailViewController.h"

@interface ABReportDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UILabel *lblAt;
@property (weak, nonatomic) IBOutlet UIImageView *imgShot;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *lblMessage;

@end

@implementation ABReportDetailViewController

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
    [self fetchList];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(320, 557)];
    [self.scrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fetchList
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *params = [NSString stringWithFormat:@"id=%@", self.messageid];
    [manager GET:[ABHelper url:@"/shot/get" params:params]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             ShotList *shotList = [[ShotList alloc] initWithDictionary:responseObject[@"data"]];
             Shot *shot = [shotList.items objectAtIndex:0];
             
             self.lblTitle.text = shot.title;
             self.lblMessage.text = shot.message;
             self.lblTag.text = [shot.tag componentsJoinedByString:@","];
             self.lblAt.text = [ABHelper stringFromISODateString:shot.updateAt];

             NSString *url = [ABHelper url:[@"/file/download/" stringByAppendingString:shot.image] params:nil];
             [self.imgShot sd_setImageWithURL:[NSURL URLWithString:url]
                             placeholderImage:[UIImage imageNamed:@"noimage.png"]
                                      options:SDWebImageHandleCookies];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ABHelper showError:error.description];
         }];
}

@end
