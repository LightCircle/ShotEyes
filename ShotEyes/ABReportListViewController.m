//
//  ABReportListViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportListViewController.h"
#import "ABReportListViewCell.h"
#import "ABReportDetailViewController.h"
#import "Header.h"

#define kTagALL @"全部"

@interface ABReportListViewController ()
{
    ShotList            *shotList;
    TagList             *tags;
    Options             *option;
    UIRefreshControl    *refresh;
    NSMutableArray      *tagList;
}

@end

@implementation ABReportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载tag
    tags = [ABStorable loadByKey:kStorableKeyTagList];
    if (tags == nil) {
        [Helper startLoadingAnimated:self.view];
        [Helper fetchTag:^() {
            [Helper stopLoadingAnimated:self.view];
            [self initMenu:tags.items];
            [self fetchList];
        }];
    } else {
        [self initMenu:tags.items];
        [self fetchList];
    }
    
    // 下拉Table时显示的转圈控件
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(fetchList) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchList
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [Helper startLoadingAnimated:self.view];
    NSString *params = [self.navigationItem.title isEqualToString:kTagALL] ? nil : [NSString stringWithFormat:@"tag=%@", [ABHelper encode:self.navigationItem.title]];
    [manager GET:[ABHelper url:@"/shot/list" params:params]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSError *error;
             shotList = [[ShotList alloc] initWithDictionary:responseObject[@"data"] error:&error];
             option = [[Options alloc] initWithDictionary:responseObject[@"data"][@"options"] error:&error];
             
             [self.tableView reloadData];
             [refresh endRefreshing];
             [Helper stopLoadingAnimated:self.view];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [refresh endRefreshing];
             [Helper stopLoadingAnimated:self.view];
             [ABHelper showError:error.description];
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shotList.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABReportListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ABReportListViewCell" forIndexPath:indexPath];
    Shot *shot = [shotList.items objectAtIndex:indexPath.row];
    
    // 详细
    cell.txtMessage.text = ((Shot *)[shotList.items objectAtIndex:indexPath.row]).message;
    [cell.txtMessage sizeToFit];
    
    cell.txtTitle.text = shot.title;
    cell.txtAt.text = [ABHelper stringFromDate:shot.updateAt format:@"yyyy/MM/dd"];
    
    // 分类
    if (shot.tag != nil) {
        cell.txtTag.text = [shot.tag componentsJoinedByString:@","];
    }
    
    // 创建者
    // cell.txtUser.text = [[option.user objectForKey:shot.updateBy] objectForKey:@"name"]);

    // 图片
    cell.imgShot.userInteractionEnabled = YES;
    [cell.imgShot addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageViewTouched:)]];

    NSString *url = [ABHelper url:[@"/file/download/" stringByAppendingString:shot.image] params:nil];
    [cell.imgShot sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"noimage.png"]
                             options:SDWebImageHandleCookies];
    
    return cell;
}

- (void)onImageViewTouched: (UITapGestureRecognizer *)sender
{
    // 显示详细
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIImageView *detailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    detailView.backgroundColor = [UIColor blackColor];
    detailView.contentMode = UIViewContentModeScaleAspectFit;
    detailView.userInteractionEnabled = YES;
    [detailView setImage:((UIImageView *)sender.view).image];
    [detailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDetailViewTouched:)]];
    
    [self.view addSubview:detailView];
}

- (void)onImageDetailViewTouched: (UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shot *shot = [shotList.items objectAtIndex:indexPath.row];

    // 120 = LeftSpace(15) + ImageWidth(64) + Space(8)+ RightSpace(33)
    CGSize labelWidth = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 120, CGFLOAT_MAX);
    NSDictionary *font = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0]};
    
    // 计算高度
    CGSize modifiedSize = [shot.message boundingRectWithSize:labelWidth
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:font
                                                     context:nil].size;

    return MAX(modifiedSize.height + 76, 92);

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ABReportDetailViewController *detailViewController = segue.destinationViewController;
    
    NSLog(@"%ld", (long)[self.tableView indexPathForSelectedRow].row);
    detailViewController.shot = [shotList.items objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

- (IBAction)onTagListTouched:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    CGRect rect = [[item valueForKey:@"view"] frame];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(rect.origin.x, rect.origin.y + 26, rect.size.width, rect.size.height)
                 menuItems:tagList];
}

// 初始化标签一览
- (void) initMenu:(NSArray *)items
{
    tagList = [[NSMutableArray alloc] init];
    
    KxMenuItem* empty = [KxMenuItem menuItem:kTagALL
                                       image:[UIImage imageNamed:@"price-tag-small.png"]
                                      target:self
                                      action:@selector(tagItemAction:)];
    [tagList addObject:empty];
    
    for (Tag *tag in items) {
        KxMenuItem* item = [KxMenuItem menuItem:tag.name
                                          image:[UIImage imageNamed:@"price-tag-small.png"]
                                         target:self
                                         action:@selector(tagItemAction:)];
        [tagList addObject:item];
    }
}

// 选中标签
- (void) tagItemAction:(id)sender
{
    KxMenuItem *tag = (KxMenuItem *)sender;
    self.navigationItem.title = tag.title;
    [self fetchList];
}
@end
