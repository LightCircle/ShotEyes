//
//  ABCommentViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABCommentViewController.h"
#import "ABCommentViewCell.h"
#import "EditorViewController.h"
#import "Header.h"

@interface ABCommentViewController ()
{
    TagList *tags;
    double latitude;    // 经度
    double longitude;   // 纬度
}

@end

@implementation ABCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设定上传按钮标题
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(onUploadTouched)];
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 左边按钮
    UIImage *leftBarButtonItemImage = [[UIImage imageNamed:@"half-arrow-left-7.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc]
                                    initWithImage:leftBarButtonItemImage
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onBackTouched)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    // 加载tag
    tags = [ABStorable loadByKey:kStorableKeyTagList];
    if (tags == nil) {
        [Helper startLoadingAnimated:self.view];
        [Helper fetchTag:^() {
            [Helper stopLoadingAnimated:self.view];
        }];
    }

    // 开始测定位置
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) { // IOS8
        [self.locationManager requestWhenInUseAuthorization];
    } else { // IOS7
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 校验输入内容
- (BOOL) isValid
{
    ABCommentViewCell *title = (ABCommentViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (title.lblContent.text.length <= 0) {
        [ABHelper showError:@"请填写标题"];
        return NO;
    }

    return YES;
}

- (void)onBackTouched
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onUploadTouched
{
    if ([self isValid] == NO) {
        return;
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // 生成上传用Request
    AFHTTPRequestSerializer *serial = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serial multipartFormRequestWithMethod:@"POST"
                                                                URLString:[ABHelper urlWithToken:@"/file/create" params:nil]
                                                               parameters:nil
                                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                    
                                                    // TODO: 根据大小调整缩放比例
                                                    UIImage *image = [ABStorable loadByKey:kStorableKeyFinalImage];
                                                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.2)
                                                                                name:@"IOS"
                                                                            fileName:@"IOS_PICTURE.JPG"
                                                                            mimeType:@"image/jpeg"];
                                                } error:nil];
    
    // 上传文件
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:nil
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  if (error) {
                                                                      NSLog(@"Error: %@", error);
                                                                      [Helper stopLoadingAnimated:self.view];
                                                                      [ABHelper showError:error.description];
                                                                      return;
                                                                  }
                                                                  
                                                                  NSArray *array = [((NSDictionary *)responseObject) objectForKey:@"data"];
                                                                  NSString *imageId = [((NSDictionary *)[array objectAtIndex:0]) objectForKey:@"_id"];
                                                                  
                                                                  [self uploadShot:imageId];
                                                              }];
    
    [Helper startLoadingAnimated:self.view];
    [uploadTask resume];
}

// 上传内容
- (void) uploadShot:(NSString *)image
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"" parameters:nil error:nil];
    
    // 生成参数
    ABCommentViewCell *title = (ABCommentViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ABCommentViewCell *message = (ABCommentViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    ABCommentViewCell *tag = (ABCommentViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    Shot *shot = [[Shot alloc] init];
    shot.title = title.lblContent.text;
    shot.message = message.lblContent.text;
    shot.image = image;
    shot.latitude = [NSNumber numberWithDouble:latitude];
    shot.longitude = [NSNumber numberWithDouble:longitude];
    shot.tag = @[tag.lblContent.text];

    // 上传
    [manager POST:[ABHelper urlWithToken:@"/shot/add" params:nil]
       parameters:@{ @"data": [shot toDictionary] }
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [Helper stopLoadingAnimated:self.view];
              [ABHelper showInfo:@"上传成功"];
              
              // 返回主页面
              [self.navigationController popViewControllerAnimated:YES];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
              [Helper stopLoadingAnimated:self.view];
              [ABHelper showError:error.description];
          }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ABCommentViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.lblTitle.text = @"图像";
            cell.imgShot.hidden = NO;
            cell.imgShot.image = [ABStorable loadByKey:kStorableKeyFinalImage];
            cell.indicator.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 1) {
            cell.lblTitle.text = @"分类";
            cell.lblContent.text = @"";
            cell.lblContent.hidden = NO;
            cell.indicator.hidden = YES;
        }
    }
    
    if (indexPath.section == 1) {
        cell.lblContent.hidden = NO;
        cell.indicator.hidden = YES;
        
        if (indexPath.row == 0) {
            cell.lblTitle.text = @"标题";
            cell.lblContent.text = @"";
        }
        if (indexPath.row == 1) {
            cell.lblTitle.text = @"说明";
            cell.lblContent.text = @"";
        }
        if (indexPath.row == 2) {
            cell.lblTitle.text = @"位置";
            cell.lblContent.text = @"";
            cell.indicator.hidden = NO;
            [cell.indicator startAnimating];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightSpace setConstant:25];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        return;
    }
    
    ABCommentViewCell *cell = (ABCommentViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    // Tag转换成数组
    NSMutableArray *items = [[NSMutableArray alloc] init];
    Underscore.arrayEach(tags.items, ^(Tag *item) {
        [items addObject:item.name];
    });

    // 显示编辑窗口
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Editor" bundle:nil];
    EditorViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"EditorViewController"];
    viewController.type = (indexPath.section == 0 && indexPath.row == 1) ? LEEditorOption : LEEditorText;
    viewController.items = items;
    viewController.defaults = cell.lblContent.text;
    viewController.onComplet = ^(id result) {
        cell.lblContent.text = result;
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 88;
        }
    }
    return 44;
}

// 用户允许使用位置信息
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

// 获取位置失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO 错误处理
    NSLog(@"错误 %@", error);
}

// 获取位置成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 结束位置测定
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;

    // 逆向GEO，获取地址
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       if (error) {
                           // TODO 错误处理
                           NSLog(@"错误 %@", error);
                           return;
                       }
                       
                       // 获取地址成功
                       if ([placemarks count] > 0) {
                           CLPlacemark *placemark = (CLPlacemark *)[placemarks lastObject];
                           ABCommentViewCell *cell = (ABCommentViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                           
                           // 拼接地图
                           NSString *address = [placemark.locality stringByAppendingString:placemark.subLocality];
                           if (placemark.thoroughfare != nil) {
                               address = [address stringByAppendingString:placemark.thoroughfare];
                           }
                           if (placemark.subThoroughfare != nil) {
                               address = [address stringByAppendingString:placemark.subThoroughfare];
                           }
                           
                           cell.lblContent.text = address;
                           cell.indicator.hidden = YES;
                           [cell.indicator stopAnimating];
                       }
                   }];
}


@end
