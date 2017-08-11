//
//  YW_NaviBarListViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_NaviBarListViewController.h"

@interface YW_NaviBarListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YW_NaviBarListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark 创建 tableView
- (void)setupView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero ];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"];
    [self.tableView setSeparatorColor:[UIColor redColor]];
    
}
#pragma mark tabelView 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"];
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listItemBlock) {
        self.listItemBlock(indexPath.row);
        
    }
}

#pragma mark 重写 preferredContentSize, 返回 popover 的大小
/**
 *  此方法,会返回一个由UIKit子类调用后得到的Size ,此size即是完美适应调用此方法的UIKit子类的size
 *  得到此size后, 可以调用 调整弹框大小的方法 **preferredContentSize**配合使用
 *  重置本控制器的大小
 */
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        //返回一个完美适应tableView的大小的 size; sizeThatFits 返回的是最合适的尺寸, 但不会改变控件的大小
        CGSize size = [self.tableView sizeThatFits:tempSize];
        return size;
    }else{
        return [self preferredContentSize];
    }
}

-(void)updateItems:(NSArray *)titles
{
    self.titles = titles;
    [self.tableView reloadData];
}

@end
