//
//  ABLoginViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABLoginViewController.h"


@interface ABLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)onLoginClicked:(id)sender;

@end

@implementation ABLoginViewController

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
    
    // 恢复过去输入过的用户ID
    NSString *defaultUserID = [DAConfigManager.defaults objectForKey:kConfigManagerDefaultUserID];
    if (defaultUserID != nil) {
        self.txtUserID.text = defaultUserID;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Functions

- (IBAction)onLoginClicked:(id)sender
{
    // 记住用户ID
    [DAConfigManager.defaults setObject:self.txtUserID.text forKey:kConfigManagerDefaultUserID];
    
    if ([self isValid] == NO) {
        return;
    }
    
    [self login];
}

- (void)login
{
    // 登陆参数
    NSString *params = [NSString stringWithFormat:@"name=%@&password=%@", self.txtUserID.text, self.txtPassword.text];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[ABHelper url:@"/login" params:params]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSDictionary *data = responseObject[@"data"];
             
             // 保存登陆用户用户
             User *user = [[User alloc] initWithDictionary:data];
             [DAConfigManager.defaults setObject:user.id forKey:kConfigManagerUserID];
             
             // 保存和cookie，csrftoken
             NSDictionary *headerFields = [((NSHTTPURLResponse *)task.response) allHeaderFields];
             [DAConfigManager.defaults setObject:[headerFields objectForKey:kConfigManagerCookie] forKey:kHTTPHeaderCookieName];
             [DAConfigManager.defaults setObject:[headerFields objectForKey:kConfigManagerCsrfToken] forKey:kHTTPHeaderCsrftokenName];
             
             // 关闭登陆画面
             [self.view removeFromSuperview];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             // 错误
             NSLog(@"Error: %@", error);
             [ABHelper showError:error.description];
         }];
}

- (BOOL)isValid
{
    // 检证userId是否为空，去掉前后的半角和全角空格
    NSString * userId = [self.txtUserID.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" 　" ]];
    if (userId.length == 0) {
        [ABHelper showError:@"请输入用户名"];
        [self.txtUserID becomeFirstResponder];
        return NO;
    }
    
    // 检证password是否为空，去掉前后的半角和全角空格
    NSString * password = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" 　" ]];
    if ( password.length  == 0) {
        [ABHelper showError:@"请输入密码"];
        [self.txtPassword becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
