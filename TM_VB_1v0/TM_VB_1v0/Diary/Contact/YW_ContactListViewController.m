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
#define ContactNormalBackgroudColor @"#AAAAAA"
#define ContactSelectBackgroudColor @"#EEEEEE"
#define ContactLabelNormalTextColor @"#AAAAAA"
#define ContactLabelSelectTextColor @"#FFFFFF"

@interface YW_ContactListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isTribe;
    BOOL isHidden;
}

/** 联系人标签  */
@property(strong, nonatomic) UILabel *contactLabel;

/** 联系人列表  */
@property(strong, nonatomic) UITableView *contactTableView;

/** 群组标签  */
@property(strong, nonatomic) UILabel *tribeLabel;

/** 群列表 */
@property(strong, nonatomic) UITableView *tribeTableView;

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
    
    defaultHeight = ScreenHeight - 64 - TabBarHeight - SearchBarHeight - 2 * LabelHeight;
    
    [self setUpView];
    
    [self reloadTribeData];
}

-(void)setUpView
{
    isTribe = YES;
    isHidden = NO;
    
    CALayer *tribeLabelBorder = [CALayer layer];
    tribeLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    tribeLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapTribeGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapTribeGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *tribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, LabelHeight)];
    tribeLabel.tag = 101;
    tribeLabel.userInteractionEnabled = YES;
    tribeLabel.text = @"Group";
    tribeLabel.backgroundColor = [UIColor colorWithHexString:ContactNormalBackgroudColor];
    tribeLabel.textColor = [UIColor colorWithHexString:ContactLabelSelectTextColor];
    tribeLabel.textAlignment = NSTextAlignmentCenter;
    [tribeLabel.layer addSublayer:tribeLabelBorder];
    [tribeLabel addGestureRecognizer:tapTribeGestureRecogbizer];
    
    CALayer *contactLabelBorder = [CALayer layer];
    contactLabelBorder.frame = CGRectMake(0.0f, LabelHeight - SplitLineHeight, self.view.width, SplitLineHeight);
    contactLabelBorder.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    UITapGestureRecognizer *tapContactGestureRecogbizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContact:)];
    tapContactGestureRecogbizer.numberOfTapsRequired = 1;
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, defaultHeight + LabelHeight, self.view.width, LabelHeight)];
    contactLabel.tag = 102;
    contactLabel.userInteractionEnabled = YES;
    contactLabel.text = @"Contact";
    contactLabel.backgroundColor = [UIColor colorWithHexString:ContactSelectBackgroudColor];
    contactLabel.textColor = [UIColor colorWithHexString:ContactLabelNormalTextColor];
    contactLabel.textAlignment = NSTextAlignmentCenter;
    [contactLabel.layer addSublayer:contactLabelBorder];
    [contactLabel addGestureRecognizer:tapContactGestureRecogbizer];
    
    self.tribeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, LabelHeight, self.view.width, defaultHeight) style:UITableViewStylePlain];
    [self.tribeTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, defaultHeight / 2, self.view.width, 0) style:UITableViewStylePlain];
    [self.contactTableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    self.tribeLabel = tribeLabel;
    self.contactLabel = contactLabel;
    
    self.tribeTableView.delegate = self;
    self.tribeTableView.dataSource = self;
    
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    [self.view addSubview:self.tribeLabel];
    [self.view addSubview:self.tribeTableView];
    [self.view addSubview:self.contactLabel];
    [self.view addSubview:self.contactTableView];
}

#pragma mark - UITableViewDataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.contactTableView) {
        return self.fetchedResultsController.sections.count;
    }
    else
    {
        return self.groupedTribes.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.contactTableView) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        NSString *groupedTribeKey = @(section).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
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
    else
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
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.contactTableView) {
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        self.conversationVC = [[SPKitExample sharedInstance] exampleOpenEServiceConversationWithPersonId:person.personId];
    }
    else
    {
        NSString *groupedTribeKey = @(indexPath.section).stringValue;
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
    else
    {
        NSString *groupedTribeKey = @(section).stringValue;
        NSArray *tribes = self.groupedTribes[groupedTribeKey];
        if (section == 0) {
            return tribes.count ? @"普通群" : nil;
        }
        else if (section == 1)
        {
            return tribes.count ? @"多聊群" : nil;
        }
        return nil;
    }
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
        YWIMCore *imcore = [SPKitExample sharedInstance].ywIMKit.IMCore;
        _fetchedResultsController = [[imcore getContactService] fetchedResultsControllerWithListMode:YWContactListModeAlphabetic imCore:imcore];
        
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
    [self.tribeTableView reloadData];
}

-(void)requestData {
    if ([[[self ywIMCore] getLoginService] isCurrentLogined]) {
        __weak typeof(self) weakSelf = self;
        [[self ywTribeService] requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
            if (error == nil) {
                [weakSelf configureDataWithTribes:tribes];
                [weakSelf.tribeTableView reloadData];
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
            if (isTribe) {
                return;
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect tribeTableFrame = self.tribeTableView.frame;
                    tribeTableFrame.size.height = defaultHeight;
                    self.tribeTableView.frame = tribeTableFrame;
                } completion:^(BOOL finished) {
                    CGRect contactTableFrame = self.contactTableView.frame;
                    contactTableFrame.size.height = 0;
                    self.contactTableView.frame = contactTableFrame;
                    
                    CGRect contactLabelFrame = self.contactLabel.frame;
                    contactLabelFrame.origin.y = defaultHeight + LabelHeight;
                    self.contactLabel.frame = contactLabelFrame;
                }];
                isTribe = !isTribe;
            }
            break;
        }
        case 102:{
            if (!isTribe) {
                return;
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect tribeTableFrame = self.tribeTableView.frame;
                    tribeTableFrame.size.height = 0;
                    self.tribeTableView.frame = tribeTableFrame;
                    
                    CGRect contactLabelFrame = self.contactLabel.frame;
                    contactLabelFrame.origin.y = LabelHeight;
                    self.contactLabel.frame = contactLabelFrame;
                    
                } completion:^(BOOL finished) {
                    CGRect contactTableFrame = self.contactTableView.frame;
                    contactTableFrame.origin.y = 2 * LabelHeight;
                    contactTableFrame.size.height = defaultHeight;
                    self.contactTableView.frame = contactTableFrame;
                    
                }];
                isTribe = !isTribe;
            }
            break;
        }
        default:
            break;
    }
    
    self.contactLabel.backgroundColor = [UIColor colorWithHexString:isTribe?ContactSelectBackgroudColor:ContactNormalBackgroudColor];
    self.tribeLabel.backgroundColor = [UIColor colorWithHexString:isTribe?ContactNormalBackgroudColor:ContactSelectBackgroudColor];
    self.contactLabel.textColor = [UIColor colorWithHexString:isTribe?ContactLabelNormalTextColor:ContactLabelSelectTextColor];
    self.tribeLabel.textColor = [UIColor colorWithHexString:isTribe?ContactLabelSelectTextColor:ContactLabelNormalTextColor];
}

@end
