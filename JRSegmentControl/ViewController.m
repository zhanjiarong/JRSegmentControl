//
//  ViewController.m
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/30.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import "ViewController.h"

#import "JRSegmentViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender
{
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    
    JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
    vc.segmentBgColor = [UIColor colorWithRed:18.0f/255 green:50.0f/255 blue:110.0f/255 alpha:1.0f];
    vc.indicatorViewColor = [UIColor whiteColor];
    vc.titleColor = [UIColor whiteColor];
    
    [vc setViewControllers:@[firstVC, secondVC, thirdVC]];
    [vc setTitles:@[@"热点", @"聚焦", @"推荐"]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
