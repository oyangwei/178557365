//
//  ViewController.m
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "ViewController.h"
#import "YW_SegmentInterface.h"
#import "YW_TitleScrollView.h"
#import "YW_UIViewController01.h"
#import "YW_UIViewController02.h"
#import "YW_UIViewController03.h"
#import "YW_UIViewController04.h"
#import "YW_UIViewController05.h"

@interface ViewController ()

/**  */
@property(strong, nonatomic) YW_SegmentInterface *interface;

- (IBAction)AddChildViewController:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YW_SegmentInterface *interface = [[YW_SegmentInterface alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    
    interface.defaultSelectNum = 2;
    
    interface.itemNormalTextColor = [UIColor purpleColor];
    interface.itemSelectedTextColor = [UIColor orangeColor];
    
    interface.itemNormalBackgroudColor = [UIColor orangeColor];
    interface.itemSelectedBackgroudColor = [UIColor purpleColor];
    
    YW_UIViewController01 *vc1 = [[YW_UIViewController01 alloc] init];
    
    YW_UIViewController02 *vc2 = [[YW_UIViewController02 alloc] init];
    
    YW_UIViewController03 *vc3 = [[YW_UIViewController03 alloc] init];
    
    YW_UIViewController04 *vc4 = [[YW_UIViewController04 alloc] init];
    
    [interface intoTitlesArray:titles hostController:self];
    
    [interface intoChildControllerArray:[NSMutableArray arrayWithObjects:vc1, vc2, vc3, vc4, nil] isInsert:NO];
    
    
    self.interface = interface;
    [self.view addSubview:interface];
    
}

- (IBAction)AddChildViewController:(id)sender {
    [self.interface insertTitle:[NSString stringWithFormat:@"%d", arc4random_uniform(100)  + 6] childVC:[[YW_UIViewController05 alloc] init] position:3];
    
}
@end
