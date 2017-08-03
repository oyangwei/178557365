//
//  SPContactListController.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SPContactListModeNormal,
    SPContactListModeSingleSelection,
    SPContactListModeMultipleSelection
} SPContactListMode;

@class SPContactListController;
@protocol SPContactListControllerDelegate <NSObject>
- (void)contactListController:(SPContactListController *)controller
           didSelectPersonIDs:(NSArray *)personIDs;
@end

typedef void(^SPContactListSelectDoneBlock)(SPContactListController *aController, NSArray *aPersonIDs);

@interface SPContactListController : UIViewController

@property (nonatomic, assign) SPContactListMode mode;
@property (nonatomic, strong) NSArray *excludedPersonIDs;
@property (nonatomic, weak) id<SPContactListControllerDelegate> delegate;

@property (nonatomic, copy) SPContactListSelectDoneBlock doneBlock;
- (void)setDoneBlock:(SPContactListSelectDoneBlock)doneBlock;

@end
