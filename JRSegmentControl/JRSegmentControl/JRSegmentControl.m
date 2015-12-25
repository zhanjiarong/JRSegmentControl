//
//  JRSegmentControl.m
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import "JRSegmentControl.h"

#define DefaultCurrentBtnColor [UIColor whiteColor]


#pragma mark - JRSegmentButton

@interface JRSegmentButton ()

@end

@implementation JRSegmentButton

- (void)setHighlighted:(BOOL)highlighted {
    // 取消高亮效果
}

@end

#pragma mark - JRSegmentControl

@interface JRSegmentControl ()
{
    NSUInteger _btnCount; // 按钮总数
    
    CGFloat _btnWidth; // 按钮宽度
    
    JRSegmentButton *_currentBtn;   // 指示视图当前所在的按钮
    
    UIView *_indicatorView; // 指示视图(滑动视图)
    
    BOOL _isSelectedBegan; // 是否设置了selectedBegan
}

@property (nonatomic, strong) NSMutableArray *buttons; // 存放button

@end



@implementation JRSegmentControl

@synthesize indicatorViewColor = _indicatorViewColor;


#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius  = frame.size.height / 10;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

#pragma mark setter/getter方法

/**
 *  设置按钮标题数组
 */
- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];
    
    _btnCount = [_titles count];
    
    [self createUI];
}

/**
 *  设置圆角半径
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = _cornerRadius;
    _indicatorView.layer.cornerRadius = _cornerRadius;
}

/**
 *  设置保存按钮的数组
 */
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

/**
 *  设置指示视图的背景色
 */
- (void)setIndicatorViewColor:(UIColor *)indicatorViewColor
{
    if (indicatorViewColor == nil) {
        return;
    }
    _indicatorViewColor = indicatorViewColor;
    _indicatorView.backgroundColor = _indicatorViewColor;
}

/**
 *  获取指示视图的背景色
 */
- (UIColor *)indicatorViewColor
{
    if (_indicatorViewColor == nil) {
        _indicatorViewColor = [UIColor whiteColor];
    }
    return _indicatorViewColor;
}

/**
 *  设置按钮上文字颜色
 */
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    for (int i = 0; i < _btnCount; i++) {
        JRSegmentButton *btn = self.buttons[i];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateHighlighted];
    }
    
    // 如果不设置backgroundColor，第一个按钮的文字颜色就会被设置为默认颜色
    [_currentBtn setTitleColor:DefaultCurrentBtnColor forState:UIControlStateNormal];
}

/**
 *  设置背景色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [_currentBtn setTitleColor:backgroundColor forState:UIControlStateNormal];
}


#pragma mark 创建视图
- (void)createUI
{
    _btnWidth = self.frame.size.width / _btnCount;
    CGFloat btnHeight = self.frame.size.height;
    
    // 指示视图
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, btnHeight)];
    _indicatorView.backgroundColor = self.indicatorViewColor;
    _indicatorView.layer.cornerRadius = self.layer.cornerRadius;
    _indicatorView.layer.masksToBounds = YES;
    [self addSubview:_indicatorView];
    
    // 创建各个按钮
    for (int i = 0; i < _btnCount; i++)
    {
        JRSegmentButton *btn = [JRSegmentButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(_btnWidth * i, 0, _btnWidth, btnHeight);
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [self.buttons addObject:btn]; // 加入数组
    }
    
    // 第一个设置字体颜色
    _currentBtn = (JRSegmentButton *)self.buttons[0];
    // 如果不设置backgroundColor，第一个按钮的文字颜色就会被设置为默认颜色
    [_currentBtn setTitleColor:DefaultCurrentBtnColor forState:UIControlStateNormal];
}

#pragma mark 事件拦截，当点击区域在指示视图的范围内时就直接把事件交给self处理，按钮就接收不到事件了
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint p = [self convertPoint:point toView:_indicatorView];
    if ([_indicatorView pointInside:p withEvent:event]) {
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
    
    CGRect frame = _indicatorView.frame;
    
    // 限制_indicatorView的滑动范围
    if (frame.origin.x + delta >= 0 && frame.origin.x + delta <= (_btnCount - 1) * _btnWidth) {
        frame.origin = CGPointMake(frame.origin.x + delta, 0);
    }
    
    CGFloat persent = _indicatorView.frame.origin.x / (_btnCount * _btnWidth);
    if ([self.delegate respondsToSelector:@selector(segmentControl:didScrolledPersent:)]) {
        [self.delegate segmentControl:self didScrolledPersent:persent];
    }
    
    _indicatorView.frame = frame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 先计算_indicatorView最终应该在哪个button上
    CGPoint center = _indicatorView.center;
    
    NSInteger index = (NSInteger)center.x / _btnWidth;
    
    [self setSelectedIndex:index]; //////////////////////////////////////
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


- (void)setIndicatorViewPercent:(CGFloat)percent {
    CGRect frame = _indicatorView.frame;
    frame.origin.x = _btnCount * _btnWidth * percent;
    
    _indicatorView.frame = frame;
}

#pragma mark 按钮点击事件处理
- (void)btnClicked:(UIButton *)btn
{
    NSInteger index = 0;
    for (UIButton *button in self.buttons) {
        if (button.frame.origin.x == btn.frame.origin.x) {
            break;
        }
        index++;
    }
    
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
    
    _currentBtn = self.buttons[index];
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _indicatorView.frame = CGRectMake(_btnWidth * index, 0, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self selectedEnd]; // 选中结束的设置 //////////////////////////////////////
    }];
}

/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan
{
    if (_isSelectedBegan) return;
    
    _isSelectedBegan = YES;
    
    _indicatorView.alpha = 0.5f;
    [_currentBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
}

/** 选开始的设置 */
- (void)selectedEnd
{
    if (!_isSelectedBegan) return;
    
    _isSelectedBegan = NO;
    
    _indicatorView.alpha = 1.0f;
    
    // 如果没有设置background，就为默认颜色
    UIColor *color = self.backgroundColor ? self.backgroundColor : DefaultCurrentBtnColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
}

@end
