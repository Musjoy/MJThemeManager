//
//  MJThemeManager.h
//  Pods
//
//  Created by 黄磊 on 16/7/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Theme.h"
#import "UITableViewCell+Theme.h"

#ifndef FILE_NAME_THEME_CONFIG
#define FILE_NAME_THEME_CONFIG @"theme_config"
#endif

#ifndef FILE_NAME_THEME_LIST
#define FILE_NAME_THEME_LIST @"theme_list"
#endif

#ifdef __cplusplus
extern "C" {
#endif
// ===================
extern NSString *const kThemeId;                        ///< 主题id
extern NSString *const kThemeThumb;                     ///< 主题缩略图
extern NSString *const kThemeName;                      ///< 主题名称
extern NSString *const kThemeBgImageName;               ///< 背景名称
// 主要颜色
extern NSString *const kThemeStyle;                     ///< 主体风格<0-UIBarStyleDefault 1-UIBarStyleBlack>，默认 UIBarStyleDefault
extern NSString *const kThemeStatusStyle;               ///< 状态栏风格<0-UIStatusBarStyleDefault 1-UIStatusBarStyleLightContent>，默认 kThemeStyle
extern NSString *const kThemeTintColor;                 ///< 主色调，默认 007AFF
extern NSString *const kThemeMainColor;                 ///< 主色调，默认 kThemeTintColor
extern NSString *const kThemeContrastColor;             ///< 反衬色，默认 FFFFFF
extern NSString *const kThemeBgColor;                   ///< 背景色，默认 kThemeContrastColor
extern NSString *const kThemeHeaderBgColor;             ///< 内容背景色，默认 kThemeContrastColor
extern NSString *const kThemeContentBgColor;            ///< 内容背景色，默认 [UIColor clearColor]
extern NSString *const kThemeTextColor;                 ///< 普通文案颜色，默认 [UIColor blackColor]
// TabBar颜色
extern NSString *const kThemeTabTintColor;              ///< TabBar主色调，默认 kThemeTintColor
extern NSString *const kThemeTabBgColor;                ///< TabBar背景色，默认 nil
extern NSString *const kThemeTabSelectBgColor;          ///< TabBar选中背景色，默认 nil
// 导航栏颜色
extern NSString *const kThemeNavTintColor;              ///< 导航栏主色调，默认 kThemeTintColor
extern NSString *const kThemeNavBgColor;                ///< 导航栏背景色，默认 nil
extern NSString *const kThemeNavTitleColor;             ///< 导航栏标题颜色，默认 kThemeNavTintColor
// 按钮颜色
extern NSString *const kThemeBtnTintColor;              ///< 按钮主色调，默认 kThemeTintColor
extern NSString *const kThemeBtnTintColor2;             ///< 按钮第二主色调，默认 kThemeBtnTintColor
extern NSString *const kThemeBtnBgColor;                ///< 按钮有背景时的背景色，默认 kThemeTintColor
extern NSString *const kThemeBtnContrastColor;          ///< 按钮有背景时的激活色，默认 kThemeContrastColor
// Cell颜色
extern NSString *const kThemeCellTintColor;             ///< TableViewCell的主色调，默认 kThemeTintColor
extern NSString *const kThemeCellBgColor;               ///< TableViewCell的背景色，默认 [UIColor clearColor]
extern NSString *const kThemeCellHLBgColor;             ///< TableViewCell的高亮背景色, 默认 nil
extern NSString *const kThemeCellTextColor;             ///< TableViewCell的标题颜色，默认 kThemeTextColor
extern NSString *const kThemeCellSubTextColor;          ///< TableViewCell的副标题颜色，默认 [UIColor lightGrayColor]
extern NSString *const kThemeCellBtnColor;              ///< TableViewCell的按钮颜色，默认 kThemeBtnTintColor
extern NSString *const kThemeCellLineColor;             ///< TableViewCell的分割线颜色，默认 [UIColor lightGrayColor]
// 广告颜色设置
extern NSString *const kThemeAdTitleColor;              ///< 广告的标题颜色，默认 kThemeCellTextColor
extern NSString *const kThemeAdTextColor;               ///< 广告文案的颜色，默认 kThemeCellSubTextColor
extern NSString *const kThemeAdDetailColor;             ///< 广告内容的颜色，默认 kThemeAdTitleColor
extern NSString *const kThemeAdBtnColor;                ///< 广告按钮文字颜色，默认 [UIColor whiteColor]
extern NSString *const kThemeAdBtnBgColor;              ///< 广告按钮背景颜色，默认 5DC75F
// 其他颜色
extern NSString *const kThemeGlassColor;                ///< 毛玻璃，默认 nil
extern NSString *const kThemeRefreshColor;              ///< 刷新图标的颜色，默认 kThemeTintColor
extern NSString *const kThemeSearchBarBgColor;          ///< 搜索框的背景颜色，默认 nil

// ===================

extern NSString *const kNoticThemeChanged;              ///< 主题变化通知

#ifdef __cplusplus
}
#endif

typedef void (^ThemeSelectBlock)(BOOL isSucced);


#pragma mark -

@interface MJThemeManager : NSObject

@property (nonatomic, strong) NSDictionary *curTheme;       ///< 当前使用主题


+ (instancetype)sharedInstance;

#pragma mark - Theme Use

/// 当前风格<0-UIBarStyleDefault 1-UIBarStyleBlack>
+ (NSInteger)curStyle;
/// 当前状态栏风格<0-UIStatusBarStyleDefault 1-UIStatusBarStyleLightContent>
+ (NSInteger)curStatusStyle;

+ (UIImage *)curBgImage;

/// 根据颜色key获取对应颜色
+ (UIColor *)colorFor:(NSString *)colorKey;
/// 根据颜色key和唯一标示获取对应颜色
+ (UIColor *)colorFor:(NSString *)colorKey andIdentifier:(NSString *)themeIdentifier;

/// 从字符串的RGB值中得到UIColor
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/// 使用颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;



#pragma mark - Theme Setting

/// 主题列表
- (NSArray *)themeList;
/// 对于主题的缩略图
- (UIImage *)thumbImageForTheme:(NSString *)aThemeId;
/// 获取完整的图片路径
- (NSString *)fullImageNameFor:(NSString *)aImageName;
/// 选中的主题ID
- (NSString *)selectThemeId;
/// 设置选中的主题ID
- (void)setSelectThemeId:(NSString *)aThemeId;
/// 设置新主题
- (void)selectThemeWith:(NSString *)aThemeId completion:(ThemeSelectBlock)completion;


@end

