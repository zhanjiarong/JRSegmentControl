//
//  JRSegmentControl.m
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import "JRSegmentControl.h"

#define DefaultCurrentBtnColor [UIColor grayColor]

@interface JRSegmentControl ()
{
    NSUInteger btnCount; // 按钮总数
    
    CGFloat btnWidth; // 按钮宽度
    
    UIButton *currentBtn;   // 指示视图当前所在的按钮
    
    UIView *indicatorView; // 指示视图(滑动视图)
    
    BOOL isSelectedBegan; // 是否设置了selectedBegan
}

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *buttons; // 存放button

@end



@implementation JRSegmentControl

@synthesize indicatorViewColor = _indicatorViewColor;


#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius  = frame.size.height / 10;
        self.layer.masksToBounds = YES;
        
        self.titles = titles;
        btnCount = titles.count;
        [self createUI];
    }
    
    return self;
}

#pragma mark setter/getter方法
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)setIndicatorViewColor:(UIColor *)indicatorViewColor
{
    if (indicatorViewColor == nil) {
        return;
    }
    _indicatorViewColor = indicatorViewColor;
    indicatorView.backgroundColor = _indicatorViewColor;
    for (UIButton *btn in self.buttons) {
        if (currentBtn != btn) {
            [btn setTitleColor:self.indicatorViewColor forState:UIControlStateNormal];
            [btn setTitleColor:self.indicatorViewColor forState:UIControlStateHighlighted];
        }
    }
}

- (UIColor *)indicatorViewColor
{
    if (_indicatorViewColor == nil) {
        _indicatorViewColor = [UIColor whiteColor];
    }
    return _indicatorViewColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [currentBtn setTitleColor:backgroundColor forState:UIControlStateNormal];
}


#pragma mark 创建视图
- (void)createUI
{
    btnWidth = self.frame.size.width / btnCount;
    CGFloat btnHeight = self.frame.size.height;
    
    // 指示视图
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    indicatorView.backgroundColor = self.indicatorViewColor;
    indicatorView.layer.cornerRadius = self.layer.cornerRadius;
    indicatorView.layer.masksToBounds = YES;
    [self addSubview:indicatorView];
    
    // 创建各个按钮
    for (int i = 0; i < btnCount; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, btnHeight);
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self.buttons addObject:btn]; // 加入数组
    }
    
    // 第一个设置字体颜色
    currentBtn = (UIButton *)self.buttons[0];
    // 如果不设置backgroundColor，第一个按钮的文字颜色就会被设置为默认颜色
    [currentBtn setTitleColor:DefaultCurrentBtnColor forState:UIControlStateNormal];
}

#pragma mark 事件拦截，当点击区域在指示视图的范围内时就直接把事件交给self处理，按钮就接收不到事件了
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint p = [self convertPoint:point toView:indicatorView];
    if ([indicatorView pointInside:p withEvent:event]) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark self的触摸事件处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectedBegan]; //////////////////////////////////////
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint prevP = [touch previousLocationInView:self];
    
    CGFloat delta = point.x - prevP.x; // 手势改变的x范围
    
    CGRect frame = indicatorView.frame;
    
    // 限制indicatorView的滑动范围
    if (frame.origin.x + delta >= 0 && frame.origin.x + delta <= (btnCount - 1) * btnWidth) {
        frame.origin = CGPointMake(frame.origin.x + delta, 0);
    }
    
    CGFloat persent = indicatorView.frame.origin.x / (btnCount * btnWidth);
    if ([self.delegate respondsToSelector:@selector(segmentControl:didScrolledPersent:)]) {
        [self.delegate segmentControl:self didScrolledPersent:persent];
    }
    
    indicatorView.frame = frame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 先计算indicatorView最终应该在哪个button上
    CGPoint center = indicatorView.center;
    
    NSInteger index = (NSInteger)center.x / btnWidth;
    
    [self setSelectedIndex:index]; //////////////////////////////////////
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark 按钮点击事件处理
- (void)btnClicked:(UIButton *)btn
{
    NSInteger index = (NSInteger)btn.frame.origin.x / btnWidth; // 求出按钮的Index
    
    [self setSelectedIndex:index]; //////////////////////////////////////
}

#pragma mark 设置选中按钮
- (void)setSelectedIndex:(NSInteger)index
{
    // 告诉代理选中了哪个按钮
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectedIndex:)]) {
        [self.delegate segmentControl:self didSelectedIndex:index];
    }
    
    [self selectedBegan]; // 选中开始的设置 //////////////////////////////////////
    
    currentBtn = self.buttons[index];
    
    [UIView animateWithDuration:0.25f animations:^{
        
        indicatorView.frame = CGRectMake(btnWidth * index, 0, indicatorView.frame.size.width, indicatorView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self selectedEnd]; // 选中结束的设置 //////////////////////////////////////
    }];
}

/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan
{
    if (isSelectedBegan) return;
    
    isSelectedBegan = YES;
    
    indicatorView.alpha = 0.5f;
    [currentBtn setTitleColor:self.indicatorViewColor forState:UIControlStateNormal];
}

/** 选开始的设置 */
- (void)selectedEnd
{
    if (!isSelectedBegan) return;
    
    isSelectedBegan = NO;
    
    indicatorView.alpha = 1.0f;
    
    // 如果没有设置background，就为默认颜色
    UIColor *color = self.backgroundColor ? self.backgroundColor : DefaultCurrentBtnColor;
    [currentBtn setTitleColor:color forState:UIControlStateNormal];
}

@end
