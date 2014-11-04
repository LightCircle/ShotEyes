//
//  ABReportViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportViewController.h"
#import "Header.h"

@interface ABReportViewController ()

@end

@implementation ABReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设定绘图笔颜色
    self.imageView.penBold = [NSNumber numberWithFloat:2.0f];
    self.imageView.penColor = [UIColor redColor];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = [UIImage imageNamed:@"background.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onCameraTouched:(id)sender
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    
    // 启动相机
    [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = NO;
        
        [self presentViewController:ipc animated:YES completion:nil];
    }]];
    
    // 选择图片
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.allowsEditing = NO;
        
        [self presentViewController:ipc animated:YES completion:nil];
    }]];
    
    // 擦除涂鸦
    [alert addAction:[UIAlertAction actionWithTitle:@"擦除涂鸦" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imageView.image = [ABStorable loadByKey:kStorableKeyOriginalImage];
    }]];

    // 取消
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [ABStorable store:self.imageView.image withKey:kStorableKeyFinalImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    self.imageView.isImageSelected = YES;

    [self dismissViewControllerAnimated:YES completion:nil];
    [ABStorable store:self.imageView.image withKey:kStorableKeyOriginalImage];
}

@end
