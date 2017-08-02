//
//  YWQuestionViewCell.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWQuestionViewCell : UITableViewCell

@property(strong, nonatomic) UILabel *questionLable;

-(void)setQuestionLableTitle:(NSString *)question;

@end
