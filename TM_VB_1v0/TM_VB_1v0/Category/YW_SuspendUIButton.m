//
//  YW_SuspendUIButton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SuspendUIButton.h"

@interface YW_SuspendUIButton()

/**
 *  开始按下的触点坐标
 */
@property (nonatomic, assign)CGPoint startPos;

@end

@implementation YW_SuspendUIButton

// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Dir;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"Menu" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithHexString:ThemeColor];
        self.layer.cornerRadius = frame.size.width / 2;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        [self.btnDelegate dragButtonClicked:self];
        return;//点击后不吸附
    }
    // 与四个屏幕边界距离
    CGFloat left = curPoint.x;
    CGFloat right = ScreenWitdh - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = ScreenHeight - curPoint.y;
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
    }
    if (top < minDistance) {
        minDistance = top;
        minDir = TOP;
    }
    if (bottom < minDistance) {
        minDir = BOTTOM;
    }
    // 开始吸附
    switch (minDir) {
        case LEFT:
            self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            break;
        case RIGHT:
            self.superview.center = CGPointMake(ScreenWitdh - self.superview.frame.size.width/2, self.superview.center.y);
            break;
        case TOP:
            self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            break;
        case BOTTOM:
            self.superview.center = CGPointMake(self.superview.center.x, ScreenHeight - self.superview.frame.size.height/2);
            break;
        default:
            break;
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
}

@end
