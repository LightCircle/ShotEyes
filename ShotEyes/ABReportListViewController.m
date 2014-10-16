//
//  ABReportListViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportListViewController.h"
#import "ABReportListViewCell.h"
#import "ABReportDetailViewController.h"

#define kTagALL @"全部"

@interface ABReportListViewController ()
{
    NSArray *list;
    NSMutableArray *taglist;
    UIRefreshControl    *refresh;
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
    
    // 获取数据
    [self fetchList];
    
    // 初始化菜单
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
    
    // 下拉Table时显示的转圈控件
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(fetchList) forControlEvents:UIControlEventValueChanged];
    [self.tblShotList addSubview:refresh];

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
    cell.txtAt.text = [ABHelper stringFromISODateString:shot.updateAt];
    cell.txtTag.text = [shot.tag componentsJoinedByString:@","];
    cell.messageId = shot._id;
    
    NSString *url = [ABHelper url:[@"/file/download/" stringByAppendingString:shot.image] params:nil];
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
    
    NSString *params = [self.barTag.title isEqualToString:kTagALL] ? nil : [NSString stringWithFormat:@"tag=%@", [ABHelper encode:self.barTag.title]];
    [manager GET:[ABHelper url:@"/shot/list" params:params]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             ShotList *tagList = [[ShotList alloc] initWithDictionary:responseObject[@"data"]];
             list = tagList.items;
             
             [self.tblShotList reloadData];
             [refresh endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [refresh endRefreshing];
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

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
}

// 显示注释画面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ABReportDetailViewController *viewController = (ABReportDetailViewController*)[segue destinationViewController];
    ABReportListViewCell *cell = (ABReportListViewCell *)sender;
    viewController.messageid = cell.messageId;
}

@end
