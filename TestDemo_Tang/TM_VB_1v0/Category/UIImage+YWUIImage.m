//
//  UIImage+YWUIImage.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/30.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "UIImage+YWUIImage.h"

@implementation UIImage (YWUIImage)

+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *reImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reImage;
}

@end
