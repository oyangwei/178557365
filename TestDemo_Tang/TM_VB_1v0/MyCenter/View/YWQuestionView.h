//
//  YWQuestionView.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/27.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWQuestionView : UIView

@property(strong, nonatomic)  UILabel *questionLabel;
@property(weak, nonatomic)  UILabel *splitLine;
@property(strong, nonatomic) UIButton *questionBtn;

-(void)setQuestionLabelText:(NSString *)title;

@end
