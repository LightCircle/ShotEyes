//
//  ABReportViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportViewController.h"
#import <DAStorable.h>
#import "ABCommentViewController.h"
#import <AFHTTPSessionManager.h>
#import <DAConfigManager.h>
#import "KxMenu.h"

@interface ABReportViewController ()

@end

@implementation ABReportViewController

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
    
    // ペンの太さ、色
    self.imgAttach.penBold = [NSNumber numberWithFloat:5.0f];
    self.imgAttach.penColor = [UIColor redColor];
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

- (IBAction)onPhotoLibraryClicked:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage:(UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imgAttach.image = image;
    self.imgAttach.isImageSelected = YES;
    
    [DAStorable store:image withKey:@"originalImage"];
    
//    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[DAHelper documentPath:@"attach.jpg"] atomically:YES];
//    imageUpdated = YES;
//    _message.contentType = message_contenttype_image;
//    self.btnClearImg.hidden = NO;
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        _photoFromCamera = YES;
//    } else {
//        _photoFromCamera = NO;
//    }
//    [self renderButtons];
}

- (IBAction)onCameraClicked:(id)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.allowsEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

- (IBAction)onRefreshClicked:(id)sender
{
    self.imgAttach.image = [DAStorable loadByKey:@"originalImage"];
}

#define kHTTPHeaderCsrftoken    @"csrftoken"
- (NSString *)appendCsrf:(NSString *)path
{
    NSString *csrftoken = [DAConfigManager.defaults objectForKey:kHTTPHeaderCsrftoken];

    NSString *spliter = [path rangeOfString:@"?"].location == NSNotFound ? @"?" : @"&";
    
    return [NSString stringWithFormat:@"%@%@_csrf=%@", path, spliter, [self uriEncodeForString:csrftoken]];
}

- (NSString*)uriEncodeForString:(NSString *)string {
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)string,
                                                                                NULL,
                                                                                (CFStringRef)@"!*'();:@&=+$,./?%#[]",
                                                                                kCFStringEncodingUTF8);
}

- (IBAction)onReportClicked:(id)sender
{
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:[self appendCsrf:@"http://10.0.1.18:5001/file/upload"]
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                       
         NSData *jpegData = UIImageJPEGRepresentation(self.imgAttach.image, 1.0);
        [formData appendPartWithFileData:jpegData
                                    name:@"file"
                                fileName:@"filename.jpg"
                                mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            NSArray *array = [((NSDictionary *)responseObject) objectForKey:@"data"];
            ;
            
            NSString *img = [((NSDictionary *)[array objectAtIndex:0]) objectForKey:@"_id"];
            NSLog(@"image : %@", img);
            
            
            // AFHTTPSessionManagerを利用して、http://localhost/test.jsonからJSONデータを取得する
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
//            NSMutableDictionary *content = [NSMutableDictionary dictionary];
//            [content setValue:@"title" forKey:@"title"];
//            [content setValue:@"messagemessagemessagemessagemessagemessagemessagemessage" forKey:@"message"];
//            [content setValue:img forKey:@"image"];
            
            NSDictionary *content = @{@"title": @"title", @"message" :@"messagemessagemessagemessagemessagemessagemessagemessage", @"image": img };
            
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setValue:content forKey:@"data"];
            
            NSDictionary *params = @{@"data": content};
            
            
            [manager POST:[self appendCsrf:@"http://10.0.1.18:5001/shot/add"]
               parameters:params
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      // 通信に成功した場合の処理
                      NSLog(@"responseObject: %@", responseObject);
                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                      // エラーの場合はエラーの内容をコンソールに出力する
                      NSLog(@"Error: %@", error);
                  }];
            
        }
    }];
    
    [uploadTask resume];
    
}

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked.");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ABCommentViewController *nvc = (ABCommentViewController*)[segue destinationViewController];
    nvc.onComplet = ^(NSString *comment){
        NSLog(@"%@", comment);
    };
}

- (IBAction)onCategoryClicked:(id)sender
{
    NSLog(@"asdfasdfs");
    
    CGRect aRect = CGRectMake(0, 54, 320, 1);
    
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Share this"
                     image:[UIImage imageNamed:@"price-tag-small.png"]
                    target:self
                    action:@selector(menuItemAction:)],
      
      [KxMenuItem menuItem:@"Check menu"
                     image:[UIImage imageNamed:@"price-tag-small.png"]
                    target:self
                    action:@selector(menuItemAction:)],
      
      [KxMenuItem menuItem:@"Reload page"
                     image:[UIImage imageNamed:@"price-tag-small.png"]
                    target:self
                    action:@selector(menuItemAction:)],
      
      [KxMenuItem menuItem:@"Search"
                     image:[UIImage imageNamed:@"price-tag-small.png"]
                    target:self
                    action:@selector(menuItemAction:)],
      
      [KxMenuItem menuItem:@"Go home"
                     image:[UIImage imageNamed:@"price-tag-small.png"]
                    target:self
                    action:@selector(menuItemAction:)]
      ];
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:aRect
                 menuItems:menuItems];
}

- (void) menuItemAction:(id)sender
{
    NSLog(@"%@", sender);
}


@end
