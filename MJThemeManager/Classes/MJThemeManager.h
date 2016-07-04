//
//  MJThemeManager.h
//  Pods
//
//  Created by 黄磊 on 16/7/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef PLIST_THEME_LIST
#define PLIST_THEME_LIST @"theme_list"
#endif

// ===================
static NSString *const ThemeId;                     ///< 主题id
static NSString *const ThemeThumb;                  ///< 主题缩略图
// 主要颜色
static NSString *const ThemeStyle;                  ///< 主体风格<0-UIBarStyleDefault 1-UIBarStyleBlack>，默认 UIBarStyleDefault
static NSString *const ThemeStatusStyle;            ///< 状态栏风格<0-UIStatusBarStyleDefault 1-UIStatusBarStyleLightContent>，默认 ThemeStyle
static NSString *const ThemeMainColor;              ///< 主色调，默认 007AFF
static NSString *const ThemeContrastColor;          ///< 反衬色，默认 FFFFFF
static NSString *const ThemeBgColor;                ///< 背景色，默认 ThemeContrastColor
// TabBar颜色
static NSString *const ThemeTabTintColor;           ///< TabBar主色调，默认 ThemeMainColor
static NSString *const ThemeTabBgColor;             ///< TabBar背景色，默认 nil
static NSString *const ThemeTabSelectBgColor;       ///< TabBar选中背景色，默认 nil
// 导航栏颜色
static NSString *const ThemeNavTintColor;           ///< 导航栏主色调，默认 ThemeMainColor
static NSString *const ThemeNavBgColor;             ///< 导航栏背景色，默认［UIColor clearColor]
static NSString *const ThemeNavTitleColor;          ///< 导航栏标题颜色，默认 ThemeNavTintColor
// 按钮颜色
static NSString *const ThemeBtnTintColor;           ///< 按钮主色调，默认 ThemeMainColor
static NSString *const ThemeBtnBgColor;             ///< 按钮有背景时的背景色，默认 ThemeMainColor
static NSString *const ThemeBtnContrastColor;       ///< 按钮有背景时的激活色，默认 ThemeContrastColor
// Cell颜色
static NSString *const ThemeCellTintColor;          ///< TableViewCell的主色调，默认 ThemeMainColor
static NSString *const ThemeCellBgColor;            ///< TableViewCell的背景色，默认 ThemeContrastColor
static NSString *const ThemeCellTextColor;          ///< TableViewCell的标题颜色，默认 [UIColor blackColor]
static NSString *const ThemeCellSubTextColor;       ///< TableViewCell的副标题颜色，默认 [UIColor lightGrayColor]
static NSString *const ThemeCellLineColor;          ///< TableViewCell的分割线颜色，默认 [UIColor lightGrayColor]

// ===================

static NSString *const kNoticThemeChanged;          ///< 主题变化通知

#pragma mark -

@interface MJThemeManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - Theme Use

/// 当前风格<0-UIBarStyleDefault 1-UIBarStyleBlack>
+ (NSInteger)curStyle;
/// 当前状态栏风格<0-UIStatusBarStyleDefault 1-UIStatusBarStyleLightContent>
+ (NSInteger)curStatusStyle;

+ (UIColor *)colorFor:(NSString *)colorKey;


#pragma mark - Theme Setting

/// 主题列表
- (NSArray *)themeList;
/// 选中的主题ID
- (NSString *)selectThemeId;
/// 设置选中的主题ID
- (void)setSelectThemeId:(NSString *)aThemeId;

@end
