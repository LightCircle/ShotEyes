//
//  ABReportViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportViewController.h"
#import "ABCommentViewController.h"

#define kTagNone @"选择分类"

@interface ABReportViewController ()
{
    NSMutableArray *taglist;
    NSString *title;
    NSString *message;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTag;
@property (weak, nonatomic) IBOutlet ABCanvasImageView *imgAttach;

- (IBAction)onPhotoLibraryClicked:(id)sender;
- (IBAction)onCameraClicked:(id)sender;
- (IBAction)onRefreshClicked:(id)sender;
- (IBAction)onReportClicked:(id)sender;
- (IBAction)onCategoryClicked:(id)sender;

@end

@implementation ABReportViewController

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
    
    // 设定绘图笔颜色
    self.imgAttach.penBold = [NSNumber numberWithFloat:5.0f];
    self.imgAttach.penColor = [UIColor redColor];
    
    
    TagList *list = [DAStorable loadByKey:kStorableKeyTagList];
    if (list == nil) {
        
        // 如果没有缓存上，则获取后台数据
        [ABHelper fetchTag:^(){
            [self initMenu:list.items];
        }];
    } else {
        
        // 初始化Tag菜单
        [self initMenu:list.items];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Functions

// 选择图片
- (IBAction)onPhotoLibraryClicked:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

// 启动相机
- (IBAction)onCameraClicked:(id)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.allowsEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

// 重置图片
- (IBAction)onRefreshClicked:(id)sender
{
    self.imgAttach.image = [DAStorable loadByKey:kStorableKeyOriginalImage];
}

// 选择标签
- (IBAction)onCategoryClicked:(id)sender
{
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(0, 54, 320, 1)
                 menuItems:taglist];
}

// 报告
- (IBAction)onReportClicked:(id)sender
{
    if ([self isValid] == NO) {
        return;
    }
    
    // TODO: 做成共同的上传
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;

    // 生成上传用Request
    AFHTTPRequestSerializer *serial = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serial multipartFormRequestWithMethod:@"POST"
                                                                URLString:[ABHelper urlWithToken:@"/file/upload" params:nil]
                                                               parameters:nil
                                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                   
                                                    // TODO: 根据大小调整缩放比例
                                                    [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imgAttach.image, 0.2)
                                                                                name:@"IOS"
                                                                            fileName:@"IOS_PICTURE.JPG"
                                                                            mimeType:@"image/jpeg"];
    } error:nil];
    
    // 上传文件
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [ABHelper showError:error.description];
            return;
        }

        NSArray *array = [((NSDictionary *)responseObject) objectForKey:@"data"];
        NSString *imageId = [((NSDictionary *)[array objectAtIndex:0]) objectForKey:@"_id"];
        [self uploadShot:imageId];
    }];
    
    [uploadTask resume];
}

// 上传内容
- (void) uploadShot:(NSString *)image
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"" parameters:nil error:nil];
    
    // 生成参数
    NSArray *tag = [self.barTag.title isEqualToString:kTagNone] ? @[@""] : @[self.barTag.title];
    NSDictionary *content = @{ @"title": title,
                               @"message": message,
                               @"image": image,
                               @"tag": tag};
    NSDictionary *data = @{ @"data": content };
    
    // 上传
    [manager POST:[ABHelper urlWithToken:@"/shot/add" params:nil]
       parameters:data
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [ABHelper showInfo:@"报告成功"];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
              [ABHelper showError:error.description];
          }];
}

// 校验输入内容
- (BOOL) isValid
{
    if (title.length <= 0) {
        [ABHelper showError:@"请填写标题"];
        return NO;
    }
    if (message.length <= 0) {
        [ABHelper showError:@"请填写注释"];
        return NO;
    }
    if (self.imgAttach.isImageSelected == NO) {
        [ABHelper showError:@"请指定照片"];
        return NO;
    }
    
    return YES;
}

// 图片保存
-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage:(UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imgAttach.image = image;
    self.imgAttach.isImageSelected = YES;
    
    [DAStorable store:self.imgAttach.image withKey:kStorableKeyOriginalImage];
}

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
}

// 显示注释画面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ABCommentViewController *viewController = (ABCommentViewController*)[segue destinationViewController];
    viewController.text = title;
    viewController.message = message;
    viewController.onComplet = ^(NSString *t, NSString *m){
        title = t;
        message = m;
    };
}

// 选中标签
- (void) tagItemAction:(id)sender
{
    KxMenuItem *tag = (KxMenuItem *)sender;
    self.barTag.title = tag.title;
}

// 初始化标签一览
- (void) initMenu:(NSArray *)items
{
    taglist = [[NSMutableArray alloc] init];
    for (Tag *tag in items) {
        KxMenuItem* item = [KxMenuItem menuItem:tag.name
                                          image:[UIImage imageNamed:@"price-tag-small.png"]
                                         target:self
                                         action:@selector(tagItemAction:)];
        [taglist addObject:item];
    }
}

@end
