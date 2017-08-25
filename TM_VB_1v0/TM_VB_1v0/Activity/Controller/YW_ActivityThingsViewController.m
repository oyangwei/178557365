//
//  YW_ActivityThingsViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityThingsViewController.h"
#import "YW_ActivityThingsTableViewCell.h"
#import "SPUtil.h"

#define LabelHeight 44
#define SplitLineHeight 1
#define CellHeight 64

#define ContactNormalBackgroudColor @"#EEEEEE"
#define ContactLabelNormalTextColor @"#AAAAAA"

#define ContactSelectBackgroudColor @"#AAAAAA"
#define ContactLabelSelectTextColor @"#FFFFFF"

typedef NS_ENUM(NSInteger, CurrentShowContactStyle){
    ShowNone = 1 << 0,
    ShowFavorite = 1 << 1,
    ShowYourShared = 1 << 2,
    ShowMyShared = 1 << 3
};

@interface YW_ActivityThingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** Activity Data List */
@property(strong, nonatomic) NSMutableArray *activityArray;

/** 选中的行列表 */
@property(strong, nonatomic) NSMutableArray *deleteArray;

@end

@implementation YW_ActivityThingsViewController

#pragma mark - 懒加载Activity Data List
-(NSMutableArray *)activityArray
{
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
        for (int i = 1; i <= 50; i++) {
            [_activityArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _activityArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YW_ActivityThingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

-(void)setupView
{
//    showStyle = ShowFavorite;
//    
//    CALayer *favoriteLabelBorder = [CALayer layer];
//    favoriteLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
//    favoriteLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
//    
//    UITapGestureRecognizer *tapFavoriteGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
//    tapFavoriteGestureRecogbizer.numberOfTapsRequired = 1;
//    UILabel *favoriteLabel = [[UILabel alloc] init];
//    favoriteLabel.tag = 101;
//    favoriteLabel.userInteractionEnabled = YES;
//    favoriteLabel.text = @"Favorite";
//    favoriteLabel.backgroundColor = [UIColor colorWithHexString:ContactSelectBackgroudColor];
//    favoriteLabel.textColor = [UIColor colorWithHexString:ContactLabelSelectTextColor];
//    favoriteLabel.textAlignment = NSTextAlignmentCenter;
//    [favoriteLabel.layer addSublayer:favoriteLabelBorder];
//    [favoriteLabel addGestureRecognizer:tapFavoriteGestureRecogbizer];
//    
//    
//    CALayer *invitedTribeLabelBorder = [CALayer layer];
//    invitedTribeLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
//    invitedTribeLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
//    
//    UITapGestureRecognizer *tapInvitedTribeGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
//    tapInvitedTribeGestureRecogbizer.numberOfTapsRequired = 1;
//    UILabel *invitedTribeLabel = [[UILabel alloc] init];
//    invitedTribeLabel.tag = 102;
//    invitedTribeLabel.userInteractionEnabled = YES;
//    invitedTribeLabel.text = @"Invitations";
//    invitedTribeLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
//    invitedTribeLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
//    invitedTribeLabel.textAlignment = NSTextAlignmentCenter;
//    [invitedTribeLabel.layer addSublayer:invitedTribeLabelBorder];
//    [invitedTribeLabel addGestureRecognizer:tapInvitedTribeGestureRecogbizer];
//    
//    CALayer *myTribeLabelBorder = [CALayer layer];
//    myTribeLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
//    myTribeLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
//    
//    UITapGestureRecognizer *tapMyTribeGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
//    tapMyTribeGestureRecogbizer.numberOfTapsRequired = 1;
//    UILabel *myTribeLabel = [[UILabel alloc] init];
//    myTribeLabel.tag = 103;
//    myTribeLabel.userInteractionEnabled = YES;
//    myTribeLabel.text = @"Groups";
//    myTribeLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
//    myTribeLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
//    myTribeLabel.textAlignment = NSTextAlignmentCenter;
//    [myTribeLabel.layer addSublayer:myTribeLabelBorder];
//    [myTribeLabel addGestureRecognizer:tapMyTribeGestureRecogbizer];
//    
//    CALayer *contactLabelBorder = [CALayer layer];
//    contactLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
//    contactLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
//    
//    UITapGestureRecognizer *tapContactGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
//    tapContactGestureRecogbizer.numberOfTapsRequired = 1;
//    UILabel *contactLabel = [[UILabel alloc] init];
//    contactLabel.tag = 104;
//    contactLabel.userInteractionEnabled = YES;
//    contactLabel.text = @"Contacts";
//    contactLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
//    contactLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
//    contactLabel.textAlignment = NSTextAlignmentCenter;
//    [contactLabel.layer addSublayer:contactLabelBorder];
//    [contactLabel addGestureRecognizer:tapContactGestureRecogbizer];
//    
//    self.favoriteTableView = [[UITableView alloc] init];
//    [self.favoriteTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
//    
//    self.myTribeTableView = [[UITableView alloc] init];
//    [self.myTribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
//    
//    self.invitedTribeTableView = [[UITableView alloc] init];
//    [self.invitedTribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
//    
//    self.contactTableView = [[UITableView alloc] init];
//    [self.contactTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
//    
//    self.favoriteLabel = favoriteLabel;
//    self.myTribeLabel = myTribeLabel;
//    self.invitedTribeLabel = invitedTribeLabel;
//    self.contactLabel = contactLabel;
//    
//    //    self.favoriteTableView.delegate = self;
//    //    self.favoriteTableView.dataSource = self;
//    
//    self.myTribeTableView.delegate = self;
//    self.myTribeTableView.dataSource = self;
//    
//    self.invitedTribeTableView.delegate = self;
//    self.invitedTribeTableView.dataSource = self;
//    
//    self.contactTableView.delegate = self;
//    self.contactTableView.dataSource = self;
//    
//    [self.view addSubview:self.favoriteLabel];
//    [self.view addSubview:self.favoriteTableView];
//    [self.view addSubview:self.myTribeLabel];
//    [self.view addSubview:self.myTribeTableView];
//    [self.view addSubview:self.invitedTribeLabel];
//    [self.view addSubview:self.invitedTribeTableView];
//    [self.view addSubview:self.contactLabel];
//    [self.view addSubview:self.contactTableView];
//    
//    [favoriteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(self.view.mas_top);
//        make.height.mas_equalTo(LabelHeight);
//    }];
//    
//    [_favoriteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(favoriteLabel.mas_bottom);
//        make.height.mas_equalTo(0);
//    }];
//    
//    [invitedTribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(_favoriteTableView.mas_bottom);
//        make.height.mas_equalTo(LabelHeight);
//    }];
//    
//    [_invitedTribeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(invitedTribeLabel.mas_bottom);
//        make.height.mas_equalTo(0);
//    }];
//    
//    [myTribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(_invitedTribeTableView.mas_bottom);
//        make.height.mas_equalTo(LabelHeight);
//    }];
//    
//    [_myTribeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(myTribeLabel.mas_bottom);
//        make.height.mas_equalTo(0);
//    }];
//    
//    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(_myTribeTableView.mas_bottom);
//        make.height.mas_equalTo(LabelHeight);
//    }];
//    
//    [_contactTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading);
//        make.trailing.equalTo(self.view.mas_trailing);
//        make.top.equalTo(contactLabel.mas_bottom);
//        make.height.mas_equalTo(0);
//    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ActivityThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    [cell configureWithAvatar:[UIImage imageNamed:@"login_bg"] title:_activityArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [self.deleteArray addObject:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [self.deleteArray removeObject:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *collect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Collect" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[SPUtil sharedInstance] showNotificationInViewController:self title:@"Collect Successful" subtitle:nil type:SPMessageNotificationTypeSuccess];
    }];
    collect.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[SPUtil sharedInstance] showNotificationInViewController:self title:@"Share Successful" subtitle:nil type:SPMessageNotificationTypeSuccess];
    }];
    share.backgroundColor = [UIColor purpleColor];
    return @[collect, share];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)setEditing:(BOOL)editing cancle:(BOOL)cancle
{
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height -= EditBtnHeight;
            self.tableView.frame = frame;
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height += EditBtnHeight;
            self.tableView.frame = frame;
        }];
    }
    
    if (cancle) {
        self.deleteArray = [NSMutableArray array];
        return;
    }
    
    NSArray *sortDeleteArray = [self.deleteArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *indexPath1 = (NSIndexPath *)obj1;
        NSIndexPath *indexPath2 = (NSIndexPath *)obj2;
        //因为满足sortedArrayUsingComparator方法的默认排序顺序，则不需要交换
        if (indexPath1.row > indexPath2.row)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    for (NSIndexPath *indexPath in sortDeleteArray) {
        [_activityArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:sortDeleteArray withRowAnimation:UITableViewRowAnimationFade];
}

@end
