//
//  JRSegmentControl.h
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRSegmentControl;

@protocol JRSegmentControlDelegate <NSObject>

/** 选中某个按钮时的代理回调 */
- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index;

@end

@interface JRSegmentControl : UIView

/** 指示视图的颜色 */
@property (nonatomic, strong) UIColor *indicatorViewColor;

@property (nonatomic, weak) id<JRSegmentControlDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/** 设置segment的索引为index的按钮处于选中状态 */
- (void)setSelectedIndex:(NSInteger)index;

@end
