//
//  ViewController.m
//  XFHorizontalAutoLayoutCollectionView
//
//  Created by zeroLu on 16/11/18.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "ViewController.h"
#import "XFHorizontalItemAutoLayoutView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XFHorizontalItemAutoLayoutView *view = [[XFHorizontalItemAutoLayoutView alloc] init];
    view.frame = CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
