//
//  YW_ContactListViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/7.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ContactListViewController.h"

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOpenIMSDKFMWK/YWServiceDef.h>
#import <WXOUIModule/YWIndicator.h>

#import "SPKitExample.h"
#import "SPUtil.h"

#import "AppDelegate.h"
#import "SPContactCell.h"

#define LabelHeight 44
#define SplitLineHeight 1
#define CellHeight 64

#define ContactNormalBackgroudColor @"#EEEEEE"
#define ContactLabelNormalTextColor @"#AAAAAA"

#define ContactSelectBackgroudColor @"#AAAAAA"
#define ContactLabelSelectTextColor @"#FFFFFF"


static NSString *const currentTitle = @"Contact";

typedef NS_ENUM(NSInteger, CurrentShowContactStyle){
    ShowNone = 1 << 0,
    ShowFavorite = 1 << 1,
    ShowInvitations = 1 << 2,
    ShowGourps = 1 << 3,
    ShowContacts = 1 << 4
};

@interface YW_ContactListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CurrentShowContactStyle showStyle;
    CGFloat favoriteTableHeight;
    CGFloat invitedTableHeight;
    CGFloat myTribeTableHeight;
    CGFloat contactTableHeight;
}

/** 联系人标签  */
@property(strong, nonatomic) UILabel *contactLabel;

/** 联系人列表  */
@property(strong, nonatomic) UITableView *contactTableView;

/** 收藏标签  */
@property(strong, nonatomic) UILabel *favoriteLabel;

/** 群组标签  */
@property(strong, nonatomic) UILabel *myTribeLabel;

/** 群组标签  */
@property(strong, nonatomic) UILabel *invitedTribeLabel;

/** 收藏列表 */
@property(strong, nonatomic) UITableView *favoriteTableView;

/** 群列表 */
@property(strong, nonatomic) UITableView *myTribeTableView;

/** 群列表 */
@property(strong, nonatomic) UITableView *invitedTribeTableView;

/** 群组 */
@property(strong, nonatomic) NSMutableDictionary *groupedTribes;

/** 聊天会话控制器 */
@property(strong, nonatomic) YWConversationViewController *conversationVC;

/** 用于检索和监听数据集 */
@property(strong, nonatomic) YWFetchedResultsController *fetchedResultsController;

@end

static CGFloat defaultHeight;

@implementation YW_ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    defaultHeight = ScreenHeight - 64 - 4 * LabelHeight - 49;
    
    [self setUpView];
    
    [self reloadTribeData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[YW_DiaryVCSingleton shareInstance] setLastVCTitle:currentTitle];
    [[YW_DiaryVCSingleton shareInstance] setContactVC:(YW_NavigationController *)self.navigationController];   //进入到chat之后，记录一下
    [[YW_NaviSingleton shareInstance] setDiaryNVC:(YW_NavigationController *)self.navigationController];
}

-(void)setUpView
{
    showStyle = ShowFavorite;
    
    CALayer *favoriteLabelBorder = [CALayer layer];
    favoriteLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    favoriteLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapFavoriteGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapFavoriteGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *favoriteLabel = [[UILabel alloc] init];
    favoriteLabel.tag = 101;
    favoriteLabel.userInteractionEnabled = YES;
    favoriteLabel.text = @"Favorite";
    favoriteLabel.backgroundColor = [UIColor colorWithHexString:ContactSelectBackgroudColor];
    favoriteLabel.textColor = [UIColor colorWithHexString:ContactLabelSelectTextColor];
    favoriteLabel.textAlignment = NSTextAlignmentCenter;
    [favoriteLabel.layer addSublayer:favoriteLabelBorder];
    [favoriteLabel addGestureRecognizer:tapFavoriteGestureRecogbizer];
    
    
    CALayer *invitedTribeLabelBorder = [CALayer layer];
    invitedTribeLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    invitedTribeLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapInvitedTribeGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapInvitedTribeGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *invitedTribeLabel = [[UILabel alloc] init];
    invitedTribeLabel.tag = 102;
    invitedTribeLabel.userInteractionEnabled = YES;
    invitedTribeLabel.text = @"Invitations";
    invitedTribeLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
    invitedTribeLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
    invitedTribeLabel.textAlignment = NSTextAlignmentCenter;
    [invitedTribeLabel.layer addSublayer:invitedTribeLabelBorder];
    [invitedTribeLabel addGestureRecognizer:tapInvitedTribeGestureRecogbizer];
    
    CALayer *myTribeLabelBorder = [CALayer layer];
    myTribeLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    myTribeLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapMyTribeGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapMyTribeGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *myTribeLabel = [[UILabel alloc] init];
    myTribeLabel.tag = 103;
    myTribeLabel.userInteractionEnabled = YES;
    myTribeLabel.text = @"Groups";
    myTribeLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
    myTribeLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
    myTribeLabel.textAlignment = NSTextAlignmentCenter;
    [myTribeLabel.layer addSublayer:myTribeLabelBorder];
    [myTribeLabel addGestureRecognizer:tapMyTribeGestureRecogbizer];
    
    CALayer *contactLabelBorder = [CALayer layer];
    contactLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    contactLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapContactGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapContactGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.tag = 104;
    contactLabel.userInteractionEnabled = YES;
    contactLabel.text = @"Contacts";
    contactLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
    contactLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
    contactLabel.textAlignment = NSTextAlignmentCenter;
    [contactLabel.layer addSublayer:contactLabelBorder];
    [contactLabel addGestureRecognizer:tapContactGestureRecogbizer];
    
    self.favoriteTableView = [[UITableView alloc] init];
    [self.favoriteTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.myTribeTableView = [[UITableView alloc] init];
    [self.myTribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.invitedTribeTableView = [[UITableView alloc] init];
    [self.invitedTribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.contactTableView = [[UITableView alloc] init];
    [self.contactTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.favoriteLabel = favoriteLabel;
    self.myTribeLabel = myTribeLabel;
    self.invitedTribeLabel = invitedTribeLabel;
    self.contactLabel = contactLabel;
    
//    self.favoriteTableView.delegate = self;
//    self.favoriteTableView.dataSource = self;
    
    self.myTribeTableView.delegate = self;
    self.myTribeTableView.dataSource = self;
    
    self.invitedTribeTableView.delegate = self;
    self.invitedTribeTableView.dataSource = self;
    
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    [self.view addSubview:self.favoriteLabel];
    [self.view addSubview:self.favoriteTableView];
    [self.view addSubview:self.myTribeLabel];
    [self.view addSubview:self.myTribeTableView];
    [self.view addSubview:self.invitedTribeLabel];
    [self.view addSubview:self.invitedTribeTableView];
    [self.view addSubview:self.contactLabel];
    [self.view addSubview:self.contactTableView];
    
    [favoriteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(LabelHeight);
    }];
    
    [_favoriteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(favoriteLabel.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [invitedTribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(_favoriteTableView.mas_bottom);
        make.height.mas_equalTo(LabelHeight);
    }];
    
    [_invitedTribeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(invitedTribeLabel.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [myTribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(_invitedTribeTableView.mas_bottom);
        make.height.mas_equalTo(LabelHeight);
    }];
    
    [_myTribeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(myTribeLabel.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(_myTribeTableView.mas_bottom);
        make.height.mas_equalTo(LabelHeight);
    }];
    
    [_contactTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(contactLabel.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.contactTableView) {
        return self.fetchedResultsController.sections.count;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.contactTableView) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        
        contactTableHeight = [sectionInfo numberOfObjects] * CellHeight;
        return [sectionInfo numberOfObjects];
    }
    else if(tableView == self.myTribeTableView)
    {
        NSString *groupedTribeKey = @(0).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
        myTribeTableHeight = tribes.count * CellHeight;
        return tribes.count;
    }else
    {
        NSString *groupedTribeKey = @(1).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
        invitedTableHeight = tribes.count * CellHeight;
        return tribes.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.contactTableView) {
        SPContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
        
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.identifier = person.personId;
        
        __block NSString *displayName = nil;
        __block UIImage *avatar = nil;
        
        [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
            displayName = aDisplayName;
            avatar = aAvatarImage;
        }];
        
        if (!displayName || avatar == nil ) {
            displayName = person.personId;
            
            __weak __typeof(self) weakSelf = self;
            __weak __typeof(cell) weakCell = cell;
            [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                      progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                          if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                              NSIndexPath *aIndexPath = [weakSelf.contactTableView indexPathForCell:weakCell];
                                                              if (!aIndexPath) {
                                                                  return ;
                                                              }
                                                              [weakSelf.contactTableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          }
                                                      } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                          if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                              NSIndexPath *aIndexPath = [weakSelf.contactTableView indexPathForCell:weakCell];
                                                              if (!aIndexPath) {
                                                                  return ;
                                                              }
                                                              [weakSelf.contactTableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          }
                                                      }];
        }
        
        if (!avatar) {
            avatar = [UIImage imageNamed:@"demo_head_120"];
        }
        
        [cell configureWithAvatar:avatar title:displayName subtitle:nil];
        
        return cell;
    }
    else if(tableView == self.myTribeTableView)
    {
        NSString *groupedTribesKey = @(indexPath.section).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribesKey];
        
        SPContactCell *cell = nil;
        if( indexPath.row >= [tribes count] ) {
            NSAssert(0, @"数据出错了");
        }
        else {
            YWTribe *tribe = tribes[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                   forIndexPath:indexPath];
            
            UIImage *avatar = [[SPUtil sharedInstance] avatarForTribe:tribe];
            [cell configureWithAvatar:avatar
                                title:tribe.tribeName
                             subtitle:nil];
        }
        return cell;
    }else
    {
        NSString *groupedTribesKey = @(indexPath.section + 1).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribesKey];
        
        SPContactCell *cell = nil;
        if( indexPath.row >= [tribes count] ) {
            NSAssert(0, @"数据出错了");
        }
        else {
            YWTribe *tribe = tribes[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                   forIndexPath:indexPath];
            
            UIImage *avatar = [[SPUtil sharedInstance] avatarForTribe:tribe];
            [cell configureWithAvatar:avatar
                                title:tribe.tribeName
                             subtitle:nil];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.contactTableView) {
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        self.conversationVC = [[SPKitExample sharedInstance] exampleOpenEServiceConversationWithPersonId:person.personId];
    }
    else if(tableView == self.myTribeTableView)
    {
        NSString *groupedTribeKey = @(indexPath.section).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
        YWTribe *tribe = tribes[indexPath.row];
        self.conversationVC = [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe];
    }else
    {
        NSString *groupedTribeKey = @(indexPath.section + 1).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
        YWTribe *tribe = tribes[indexPath.row];
        self.conversationVC = [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectCellWithViewController:)]) {
        [self.delegate didSelectCellWithViewController:self.conversationVC];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.contactTableView) {
        if (section >= [[self.fetchedResultsController sectionIndexTitles] count]) {
            return nil;
        }
        return [self.fetchedResultsController sectionIndexTitles][(NSUInteger)section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:242./255 alpha:1.0];
    header.textLabel.textColor = [UIColor colorWithWhite:155./255 alpha:1.0];
    header.textLabel.font = [UIFont systemFontOfSize:12.0];
    header.textLabel.shadowColor = [UIColor clearColor];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.contactTableView) {
        return [self.fetchedResultsController sectionIndexTitles];
    }
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

#pragma mark - FRC
-(YWFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [[[self ywIMCore] getContactService] fetchedResultsControllerWithListMode:YWContactListModeAlphabetic imCore:[self ywIMCore]];
        
        __weak typeof(self) weakSelf = self;
        [_fetchedResultsController setDidChangeContentBlock:^{
            [weakSelf.contactTableView reloadData];
        }];
        
        [_fetchedResultsController setDidResetContentBlock:^{
            [weakSelf.contactTableView reloadData];
        }];
    }
    return _fetchedResultsController;
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore
{
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

-(id<IYWTribeService>)ywTribeService
{
    return [[self ywIMCore] getTribeService];
}

#pragma mark - 获取群列表数据
-(void)reloadTribeData {
    NSArray *tribes = [[self ywTribeService] fetchAllTribes];
    [self configureDataWithTribes:tribes];
    [self.myTribeTableView reloadData];
}

-(void)requestData {
    if ([[[self ywIMCore] getLoginService] isCurrentLogined]) {
        __weak typeof(self) weakSelf = self;
        [[self ywTribeService] requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
            if (error == nil) {
                [weakSelf configureDataWithTribes:tribes];
                [weakSelf.myTribeTableView reloadData];
            }
            else
            {
                [[SPUtil sharedInstance] showNotificationInViewController:self
                                                                    title:@"获取群列表失败"
                                                                 subtitle:nil
                                                                     type:SPMessageNotificationTypeError];
            }
        }];
    }
}

-(void)configureDataWithTribes:(NSArray *)tribes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSMutableArray *normalTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeNormal) stringValue]] = normalTribes;
    
    NSMutableArray *multipleChatTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeMultipleChat) stringValue]] = multipleChatTribes;
    
    for (YWTribe *tribe in tribes) {
        if (tribe.tribeType == YWTribeTypeNormal) {
            [normalTribes addObject:tribe];
        }
        else if (tribe.tribeType == YWTribeTypeMultipleChat)
        {
            [multipleChatTribes addObject:tribe];
        }
    }
    self.groupedTribes = dictionary;
}

-(void)switchContact:(UITapGestureRecognizer *)tapGestureRecogbizer{
    UILabel *label = (UILabel *)tapGestureRecogbizer.view;
    switch (label.tag) {
        case 101:{
            if (showStyle == ShowFavorite) {
                [UIView animateWithDuration:0.2 animations:^{
                    [_favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    }];
                }];
                showStyle = ShowNone;
                return;
            }
            else
            {
                [self HideAllContact];
                [UIView animateWithDuration:0.2 animations:^{
                    [_favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(favoriteTableHeight > defaultHeight ? defaultHeight : favoriteTableHeight);
                    }];
                }];
                showStyle = ShowGourps;
            }
            break;
        }
        case 102:{
            if (showStyle == ShowInvitations) {
                [UIView animateWithDuration:0.2 animations:^{
                    [_invitedTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    }];
                }];
                showStyle = ShowNone;
                return;
            }
            else
            {
                [self HideAllContact];
                [UIView animateWithDuration:0.2 animations:^{
                    [_invitedTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(invitedTableHeight > defaultHeight ? defaultHeight : invitedTableHeight);
                    }];
                }];
                showStyle = ShowInvitations;
            }
            break;
        }
        case 103:{
            if (showStyle == ShowGourps) {
                [UIView animateWithDuration:0.2 animations:^{
                    [_myTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    }];
                }];
                showStyle = ShowNone;
                return;
            }
            else
            {
                [self HideAllContact];
                [UIView animateWithDuration:0.2 animations:^{
                    [_myTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(myTribeTableHeight > defaultHeight ? defaultHeight : myTribeTableHeight);
                    }];
                }];
                showStyle = ShowGourps;
            }
            break;
        }
        case 104:{
            if (showStyle == ShowContacts) {
                [UIView animateWithDuration:0.2 animations:^{
                    [_contactTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    }];
                }];
                showStyle = ShowNone;
                return;
            }
            else
            {
                [self HideAllContact];
                [UIView animateWithDuration:0.2 animations:^{
                    [_contactTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(contactTableHeight > defaultHeight ? defaultHeight : contactTableHeight);
                    }];
                }];
                showStyle = ShowContacts;
            }
            break;
        }
        default:
            break;
    }
    
    self.favoriteLabel.backgroundColor = [UIColor colorWithHexString:showStyle == ShowFavorite?ContactSelectBackgroudColor:ContactNormalBackgroudColor];
    self.invitedTribeLabel.backgroundColor = [UIColor colorWithHexString:showStyle == ShowInvitations?ContactSelectBackgroudColor:ContactNormalBackgroudColor];
    self.myTribeLabel.backgroundColor = [UIColor colorWithHexString:showStyle == ShowGourps?ContactSelectBackgroudColor:ContactNormalBackgroudColor];
    self.contactLabel.backgroundColor = [UIColor colorWithHexString:showStyle == ShowContacts?ContactSelectBackgroudColor:ContactNormalBackgroudColor];
    
    self.favoriteLabel.textColor = [UIColor colorWithHexString:showStyle == ShowFavorite?ContactLabelSelectTextColor:ContactLabelNormalTextColor];
    self.invitedTribeLabel.textColor = [UIColor colorWithHexString:showStyle == ShowInvitations?ContactLabelSelectTextColor:ContactLabelNormalTextColor];
    self.myTribeLabel.textColor = [UIColor colorWithHexString:showStyle == ShowGourps?ContactLabelSelectTextColor:ContactLabelNormalTextColor];
    self.contactLabel.textColor = [UIColor colorWithHexString:showStyle == ShowContacts?ContactLabelSelectTextColor:ContactLabelNormalTextColor];
}

- (void)HideAllContact
{
    [UIView animateWithDuration:0.2 animations:^{
        [_favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [_invitedTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [_myTribeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        
        [_contactTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }];
}

@end
