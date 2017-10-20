//
//  YW_DeclareView.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/19.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_DeclareView.h"

@interface YW_DeclareView()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirmClick:(id)sender;

@end

@implementation YW_DeclareView

+(instancetype)declareView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.backgroundColor = [UIColor colorWithHexString:ThemeColor];
}

- (IBAction)confirmClick:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
@end
