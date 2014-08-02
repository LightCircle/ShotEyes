//
//  ABCommentViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14-7-31.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABCommentViewController.h"

@interface ABCommentViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@end

@implementation ABCommentViewController

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
    
    self.txtTitle.text = self.text;
    self.txtComment.text = self.message;
    [self.txtTitle becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.onComplet) {
        self.onComplet(self.txtTitle.text, self.txtComment.text);
    }
}

@end
