//
//  YW_SegmentInterface.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SegmentInterface.h"
#import "YW_TitleScrollView.h"
#import "YW_ChildScrollView.h"

static CGFloat const defaultItemH = 44;
static CGFloat const defaultShowCountItem = 4;

@interface YW_SegmentInterface() <UIScrollViewDelegate>

/** TitleScrollView */
@property(strong, nonatomic) YW_TitleScrollView *titleScrollView;

/** ChileControllerScrollView */
@property(strong, nonatomic) YW_ChildScrollView *childScrollView;

/** 标题数组 */
@property(strong, nonatomic) NSMutableArray *titlesArray;

/** 子控制器数组 */
@property(strong, nonatomic) NSMutableArray *childControllerArray;

@property (nonatomic,weak) UIViewController *mainViewController;

@end

@implementation YW_SegmentInterface

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self titleScrollView];
        [self childScrollView];
    }
    return self;
}

-(YW_TitleScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[YW_TitleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWitdh, defaultItemH)];
        _titleScrollView.backgroundColor = [UIColor clearColor];
        _titleScrollView.delegate = self;
        [self addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

-(YW_ChildScrollView *)childScrollView
{
    if (!_childScrollView) {
        _childScrollView = [[YW_ChildScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScrollView.frame), ScreenWitdh, self.height - _titleScrollView.frame.size.height)];
        _childScrollView.backgroundColor = [UIColor clearColor];
        _childScrollView.delegate = self;
        [self addSubview:_childScrollView];
    }
    return _childScrollView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

}

-(void)intoTitlesArray:(NSMutableArray *)titlesArray hostController:(UIViewController *)hostController
{
    _mainViewController = hostController;
    _titlesArray = titlesArray;
    _childScrollView.contentSize = CGSizeMake(ScreenWitdh * titlesArray.count, 0);
    _titleScrollView.showItemCount = _showItemCount ? _showItemCount : defaultShowCountItem;
    
    if (titlesArray.count < defaultShowCountItem && !_showItemCount) {
        _titleScrollView.showItemCount = (int)titlesArray.count;
    }
    
    if (titlesArray.count < _showItemCount) {
        _titleScrollView.showItemCount = (int)titlesArray.count;
    }
    
    _titleScrollView.defaultSelectNum = _defaultSelectNum;
    
    _titleScrollView.itemNormalTextColor = _itemNormalTextColor;
    _titleScrollView.itemSelectedTextColor = _itemSelectedTextColor;
    
    _titleScrollView.itemNormalBackgroudColor = _itemNormalBackgroudColor;
    _titleScrollView.itemSelectedBackgroudColor = _itemSelectedBackgroudColor;
    
    [_titleScrollView intoTitleArray:titlesArray];
    
    __weak typeof(self) weakSelf = self;
    
    _titleScrollView.tabItemClickBlock = ^(int currentNum, YW_TabItem *item) {
        weakSelf.currentItemNum = currentNum;
        [weakSelf.childScrollView setContentOffset:CGPointMake(weakSelf.childScrollView.frame.size.width * currentNum, 0)];
        [weakSelf addChildView];
        
        if ([weakSelf.delegate respondsToSelector:@selector(yw_ClickEvent:childViewController:segmentInterface:)]) {
            [weakSelf.delegate yw_ClickEvent:item childViewController:weakSelf.childControllerArray[currentNum] segmentInterface:weakSelf];
        }
    };
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

-(void)intoChildControllerArray:(NSMutableArray *)childControllerArray isInsert:(BOOL)isInsert
{
    _childControllerArray = childControllerArray;
    if (childControllerArray.count == 0) return;
    
    for (int i = 0; i < childControllerArray.count; i ++) {
        //过滤掉已经加入的子控制器，防止重复添加
        if (![_mainViewController.childViewControllers containsObject:childControllerArray[i]]) {
            [_mainViewController addChildViewController:childControllerArray[i]];
        }
    }
    if (!isInsert) {
        [self addChildView];
    }
}

-(void)insertTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos
{
    _currentItemNum = pos;
    
    [_titlesArray insertObject:title atIndex:pos];
    [_childControllerArray insertObject:childVC atIndex:pos];
    
    [self intoTitlesArray:_titlesArray hostController:_mainViewController];
    [self intoChildControllerArray:_childControllerArray isInsert:YES];
    
    [_titleScrollView setSelectedItem:pos];
    [self.childScrollView setContentOffset:CGPointMake(_childScrollView.frame.size.width * pos, 0)];
    [self addChildView];

}

-(void)updateTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos
{
    _currentItemNum = pos;
    
    [_titlesArray removeObjectAtIndex:pos];
    [_childControllerArray removeObjectAtIndex:pos];
    
    [_titlesArray insertObject:title atIndex:pos];
    [_childControllerArray insertObject:childVC atIndex:pos];
    
    [self intoTitlesArray:_titlesArray hostController:_mainViewController];
    [self intoChildControllerArray:_childControllerArray isInsert:YES];
    
    [_titleScrollView setSelectedItem:pos];
    [self.childScrollView setContentOffset:CGPointMake(_childScrollView.frame.size.width * pos, 0)];
    [self addChildView];
}

-(void)deleteTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos
{
    _currentItemNum = pos - 1;
    
    [_titlesArray removeObjectAtIndex:pos];
    [_childControllerArray removeObjectAtIndex:pos];
    
    [self intoTitlesArray:_titlesArray hostController:_mainViewController];
    [self intoChildControllerArray:_childControllerArray isInsert:YES];
    
    [_titleScrollView setSelectedItem:pos - 1];
    [self.childScrollView setContentOffset:CGPointMake(_childScrollView.frame.size.width * pos - 1, 0)];
    [self addChildView];
}

-(void)addChildView{
    _mainViewController.automaticallyAdjustsScrollViewInsets = NO;
    NSUInteger index = _childScrollView.contentOffset.x / _childScrollView.frame.size.width;
    UIViewController *childVC;
    if (index >= _childControllerArray.count) {
        return;
    }

    childVC = _childControllerArray[index];
    childVC.view.frame = _childScrollView.bounds;
    [_childScrollView addSubview:childVC.view];
}

-(void)addChildViewByInsert{
    UIViewController *childVC = _mainViewController.childViewControllers[_currentItemNum];
    childVC.view.frame = _childScrollView.bounds;
    [_childScrollView addSubview:childVC.view];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _childScrollView) {
        if ([self.delegate respondsToSelector:@selector(childVC_scrollView:)]) {
            [self.delegate childVC_scrollView:scrollView];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _childScrollView) {
        [self addChildView];
        int index = _childScrollView.contentOffset.x / _childScrollView.frame.size.width;
        _currentItemNum = index;
        [_titleScrollView setSelectedItem:index];
    }
}

-(void)setCurrentSelectedItemNum:(int)index
{
    if (index < _titlesArray.count && index < _childControllerArray.count) {
        [_titleScrollView setSelectedItem:index];
        [_childScrollView setContentOffset:CGPointMake(_childScrollView.frame.size.width * index, 0)];
        [self addChildView];
    }
}

-(void)setTitleScrollViewFrame:(CGRect)titleScrollViewFrame
{
    _titleScrollViewFrame = titleScrollViewFrame;
    if (!CGRectIsNull(titleScrollViewFrame)) {
        self.titleScrollViewFrame = titleScrollViewFrame;
    }
}

-(void)setDefaultSelectNum:(int)defaultSelectNum
{
    if (!defaultSelectNum) {
        _defaultSelectNum = 0;
    }
    _defaultSelectNum = defaultSelectNum;
    
    [_childScrollView setContentOffset:CGPointMake(_childScrollView.frame.size.width * defaultSelectNum, 0)];
    [self addChildView];
}


@end
