//
//  JRSegmentViewController.h
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRSegmentControl.h"

@interface JRSegmentViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *titles;

/** 指示视图的颜色 */
@property (nonatomic, strong) UIColor *indicatorViewColor;
/** segment的背景颜色 */
@property (nonatomic, strong) UIColor *segmentBgColor;
/**
 *  segment每一项的文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/** segment每一项的宽 */
@property (nonatomic, assign) CGFloat itemWidth;
/** segment每一项的高 */
@property (nonatomic, assign) CGFloat itemHeight;

@end

