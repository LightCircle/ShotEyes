//
//  ABReportDetailViewController.m
//  ShotEyes
//
//  Created by LI LIN on 14/10/29.
//  Copyright (c) 2014年 Alphabets. All rights reserved.
//

#import "ABReportDetailViewController.h"

@interface ABReportDetailViewController ()

@end

@implementation ABReportDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    double latitude = [self.shot.latitude doubleValue];
    double longitude = [self.shot.longitude doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 设定地图中心点
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    
    // 尺寸
    MKCoordinateRegion cr = self.mapView.region;
    cr.center = location.coordinate;
    cr.span.latitudeDelta = 0.05;
    cr.span.longitudeDelta = 0.05;
    [self.mapView setRegion:cr animated:NO];
    
    // 设置指针
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = self.shot.title;
    //annotation.subtitle = self.shot.message;
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
    
    // 左边按钮
    UIImage *leftBarButtonItemImage = [[UIImage imageNamed:@"half-arrow-left-7.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithImage:leftBarButtonItemImage
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(onBackTouched)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onBackTouched
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
