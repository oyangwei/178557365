//
//  YWContactsViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/29.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWContactsViewController.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOpenIMSDKFMWK/YWServiceDef.h>
#import <WXOUIModule/YWIndicator.h>

#import "SPKitExample.h"
#import "SPContactCell.h"
#import "SPUtil.h"

@interface YWContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) YWFetchedResultsController *fetchedResultsController;

@end

@implementation YWContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.separatorColor =[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f];
    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.identifier = person.personId;
    
    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];
    
    if (!displayName || avatar == nil) {
        displayName = person.personId;
        
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndextPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndextPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndextPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          }
                                                  }
                                                completion:nil];
    };
    
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    
    [cell configureWithAvatar:avatar title:displayName subtitle:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor lightGrayColor]];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section >= [[self.fetchedResultsController sectionIndexTitles] count]) {
        return nil;
    }
    return  [self.fetchedResultsController sectionIndexTitles][(NSInteger)section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

-(YWFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        YWIMCore *imcore = [SPKitExample sharedInstance].ywIMKit.IMCore;
        _fetchedResultsController = [[imcore getContactService] fetchedResultsControllerWithListMode:YWContactListModeAlphabetic imCore:imcore];
        
        __weak typeof(self) weakSelf = self;
        [_fetchedResultsController setDidChangeContentBlock:^{
            [weakSelf.tableView reloadData];
        }];
        
        [_fetchedResultsController setDidResetContentBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }
    return _fetchedResultsController;
}

@end
