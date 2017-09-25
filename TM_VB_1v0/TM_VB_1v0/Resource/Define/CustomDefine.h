//
//  CustomDefine.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#ifndef CustomDefine_h
#define CustomDefine_h

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#define ScreenWitdh [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - 系统各控件默认高度

#define UIStatusBarHeight 20    //状态栏高度
#define NavigationBarHeight 44  //导航栏高度
#define UITabBarHeight 49       //底部栏高度
#define MenuBarHeight 44        //菜单栏高度
#define SearchBarHeight 64      //搜索栏高度
#define TabBarHeight 44         //标签栏高度
#define BarSpace 5              //各栏间隔
#define MaskWidth 20            //蒙版宽度
#define EditBtnHeight 50        //底部弹出取消确定按钮高度

#pragma mark - 颜色

#define ThemeColor @"#418ACE"

#define MenuBarButtonBgColor @"8EAFD3"

#define CustomBorderColor @"#D2D2D2"

#define MenuBarTextNormalColor @"#FFFFFF"  //菜单栏常规字体颜色
#define MenuBarTextSelectedColor @"#FF0000" //菜单栏选中颜色

#define MenuBarNormalBackgroudColor @"#418ACE"  //菜单栏未选中背景颜色
#define MenuBarSelectedBackgroudColor @"#FFFFFF" //菜单栏选中背景颜色

#define SearBarNormalBackgourdColor @"FFFFFF"  //搜索栏常规背景色
#define SearBarSelectedBackgroudColor @"E3E3E3" //搜索栏选中背景色

#define TabBarTextNormalColor @"#333333"  //标签栏常规字体颜色
#define TabBarTextSelectedColor @"#FFFFFF" //标签栏选中字体颜色

#define TabBarNormalBackgroudColor @"#FFFFFF"  //标签栏未选中背景颜色
#define TabBarSelectedBackgroudColor @"#418ACE" //标签栏选中背景颜色

#define TabBarUnderLineColor @"#333333"  //标签栏选中下划线颜色

#pragma mark - 图标名称

#define LeftMenuMaskArrow @"arrow_L_64"  //菜单栏左蒙版图片名称
#define RightMenuMaskArrow @"arrow_R_64"  //菜单栏右蒙版图片名称

#define LeftTabMaskArrow @"arrow_L_64"   //标签栏左蒙版图片名称
#define RightTabMaskArrow @"arrow_R_64"   //标签栏右蒙版图片名称

#define LeftArrow @"back"  //菜单栏左蒙版图片名称
#define RightArrow @"go"  //菜单栏右蒙版图片名称

#define BackBtnImageName @"back"  //菜单栏左蒙版图片名称
#define GoBtnImageName @"go"  //菜单栏右蒙版图片名称

typedef NS_ENUM(NSInteger, YW_ShowMenuStyles){
    YW_ShowMenuFromLeft = 1 << 1,
    YW_ShowMenuFromRight = 1 << 3,
};


#endif /* CustomDefine_h */
