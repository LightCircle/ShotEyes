//
//  ABReportListViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportListViewController.h"
#import "ABReportListViewCell.h"

#define kTagALL @"全部"

@interface ABReportListViewController ()
{
    NSArray *list;
    NSMutableArray *taglist;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTag;
- (IBAction)onCategoryClicked:(id)sender;

@end

@implementation ABReportListViewController

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
    
    TagList *tags = [DAStorable loadByKey:kStorableKeyTagList];
    if (tags == nil) {
        
        // 如果没有缓存上，则获取后台数据
        [ABHelper fetchTag:^(){
            [self initMenu:tags.items];
        }];
    } else {
        
        // 初始化Tag菜单
        [self initMenu:tags.items];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ABReportListViewCell";
	ABReportListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    Shot *shot = [list objectAtIndex:indexPath.row];
    cell.txtTitle.text = shot.title;
    cell.txtMessage.text = shot.message;
    
    NSString *url = [ABHelper url:[@"/file/" stringByAppendingString:shot.image] params:nil];
    [cell.imgShot sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"noimage.png"]
                             options:SDWebImageHandleCookies];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)fetchList
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *params = [self.barTag.title isEqualToString:kTagALL] ? nil : [NSString stringWithFormat:@"tag=%@", self.barTag.title];
    [manager GET:[ABHelper url:@"/shot/list" params:params]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             ShotList *tagList = [[ShotList alloc] initWithDictionary:responseObject[@"data"]];
             list = tagList.items;
             [self.tblShotList reloadData];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ABHelper showError:error.description];
         }];
}

// 初始化标签一览
- (void) initMenu:(NSArray *)items
{
    taglist = [[NSMutableArray alloc] init];
    
    KxMenuItem* empty = [KxMenuItem menuItem:kTagALL
                                      image:[UIImage imageNamed:@"price-tag-small.png"]
                                     target:self
                                     action:@selector(tagItemAction:)];
    [taglist addObject:empty];
    
    for (Tag *tag in items) {
        KxMenuItem* item = [KxMenuItem menuItem:tag.name
                                          image:[UIImage imageNamed:@"price-tag-small.png"]
                                         target:self
                                         action:@selector(tagItemAction:)];
        [taglist addObject:item];
    }
}

// 选中标签
- (void) tagItemAction:(id)sender
{
    KxMenuItem *tag = (KxMenuItem *)sender;
    self.barTag.title = tag.title;
    [self fetchList];
}

- (IBAction)onCategoryClicked:(id)sender
{
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(0, 54, 320, 1)
                 menuItems:taglist];
}

@end
