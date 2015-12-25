//
//  JRSegmentControl.h
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRSegmentControl;

#pragma mark - JRSegmentButton
@interface JRSegmentButton : UIButton

@end


#pragma mark - JRSegmentControlDelegate
@protocol JRSegmentControlDelegate <NSObject>

/** 选中某个按钮时的代理回调 */
- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index;

@optional

/** 指示视图滑动进度的代理回调 */
- (void)segmentControl:(JRSegmentControl *)segment didScrolledPersent:(CGFloat)persent;

@end

#pragma mark - JRSegmentControl
@interface JRSegmentControl : UIView

/**
 *  按钮标题数组
 */
@property (nonatomic, copy) NSArray *titles;
/** 按钮圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 指示视图的颜色 */
@property (nonatomic, strong) UIColor *indicatorViewColor;
/** 未选中时的按钮文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, weak) id<JRSegmentControlDelegate> delegate;

/** 设置segment的索引为index的按钮处于选中状态 */
- (void)setSelectedIndex:(NSInteger)index;

- (void)setIndicatorViewPercent:(CGFloat)percent;

/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan;

/** 选开始的设置 */
- (void)selectedEnd;

@end
