//
//  YW_HistoryTableView.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/1.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_HistoryTableView.h"

@interface YW_HistoryTableView()  <UITableViewDelegate, UITableViewDataSource>

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation YW_HistoryTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
    }
    return self;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyRecord.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(indexPath.row == self.historyRecord.count)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.historyRecord[indexPath.row];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"promptCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"promptCell"];
        }
        UILabel *label = [[UILabel alloc] init];
        label.text = self.historyRecord.count == 0?@"暂无历史记录":@"清空历史记录";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading);
            make.trailing.equalTo(cell.contentView.mas_trailing);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.historyRecord.count) {
        if (self.clearBlock) {
            self.clearBlock();
        }
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.cellBlock) {
        self.cellBlock(cell.textLabel.text);
    }
}

@end
