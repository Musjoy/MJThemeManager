//
//  MJThemeManager.m
//  Pods
//
//  Created by 黄磊 on 16/7/4.
//
//

#import "MJThemeManager.h"
#if __has_include("FileSource.h")
#import "FileSource.h"
#endif

#ifndef kDefualtSelectThemeId
#define kDefualtSelectThemeId   @"DefualtSelectThemeId"
#endif

// ===================
static NSString *const ThemeId                  = @"themeId";
static NSString *const ThemeThumb               = @"themeThumb";
// 主要颜色
static NSString *const ThemeStyle               = @"ThemeStyle";
static NSString *const ThemeStatusStyle         = @"ThemeStatusStyle";
static NSString *const ThemeMainColor           = @"ThemeMainColor";
static NSString *const ThemeContrastColor       = @"ThemeContrastColor";
static NSString *const ThemeBgColor             = @"ThemeBgColor";
// TabBar颜色
static NSString *const ThemeTabTintColor        = @"ThemeTabTintColor";
static NSString *const ThemeTabBgColor          = @"ThemeTabBgColor";
static NSString *const ThemeTabSelectBgColor    = @"ThemeTabSelectBgColor";
// 导航栏颜色
static NSString *const ThemeNavTintColor        = @"ThemeNavTintColor";
static NSString *const ThemeNavBgColor          = @"ThemeNavBgColor";
static NSString *const ThemeNavTitleColor       = @"ThemeNavTitleColor";
// 按钮颜色
static NSString *const ThemeBtnTintColor        = @"ThemeBtnTintColor";
static NSString *const ThemeBtnBgColor          = @"ThemeBtnBgColor";
static NSString *const ThemeBtnContrastColor    = @"ThemeBtnContrastColor";
// Cell颜色
static NSString *const ThemeCellTintColor       = @"ThemeCellTintColor";
static NSString *const ThemeCellBgColor         = @"ThemeCellBgColor";
static NSString *const ThemeCellTextColor       = @"ThemeCellTextColor";
static NSString *const ThemeCellSubTextColor    = @"ThemeCellSubTextColor";
static NSString *const ThemeCellLineColor       = @"ThemeCellLineColor";

static MJThemeManager *s_themeManager   = nil;

static NSDictionary *s_defaultTheme    = nil;

@interface MJThemeManager ()

@property (nonatomic, strong) NSArray *arrThemes;
@property (nonatomic, strong) NSMutableDictionary *dicThemes;
@property (nonatomic, strong) NSDictionary *curTheme;
@property (nonatomic, strong) NSString *curThemeId;
@property (nonatomic, strong) NSMutableDictionary *dicColors;

@property (nonatomic, assign) NSInteger curStyle;
@property (nonatomic, assign) NSInteger curStatusStyle;

@end

@implementation MJThemeManager

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:1.0];
    return result;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t once_patch;
    dispatch_once(&once_patch, ^() {
        s_themeManager = [[self alloc] init];
    });
    return s_themeManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        s_defaultTheme =
            @{ThemeId               : @"0",
              ThemeStyle            : @0,
              ThemeMainColor        : @"007AFF",
              ThemeContrastColor    : @"FFFFFF",
              ThemeBgColor          : ThemeContrastColor,
              ThemeTabTintColor     : ThemeMainColor,
//              ThemeTabBgColor       : ,
//              ThemeTabSelectBgColor : ,
              ThemeNavTintColor     : ThemeMainColor,
//              ThemeNavBgColor       : ,
              ThemeNavTitleColor    : ThemeNavTintColor,
              ThemeBtnTintColor     : ThemeMainColor,
              ThemeBtnBgColor       : ThemeMainColor,
              ThemeBtnContrastColor : ThemeContrastColor,
              ThemeCellTintColor    : ThemeMainColor,
              ThemeCellBgColor      : ThemeContrastColor,
              ThemeCellTextColor    : @"000000",
              ThemeCellSubTextColor : @"666666",
              ThemeCellLineColor    : @"999999"};
        
        _dicColors = [[NSMutableDictionary alloc] init];
        
        // 加载主题文件
        _arrThemes = getPlistFileData(PLIST_THEME_LIST);
        if (_arrThemes.count > 0) {
            // 处理主题列表
            for (NSDictionary *aTheme in _arrThemes) {
                if (aTheme[ThemeId]) {
                    [_dicThemes setObject:aTheme forKey:aTheme[ThemeId]];
                }
            }
            // 读取当前选中的主题
            NSString *selectThemeId = [[NSUserDefaults standardUserDefaults] objectForKey:kDefualtSelectThemeId];
            if (selectThemeId) {
                _curTheme = _dicThemes[selectThemeId];
            }
        }
        if (_curTheme && _curTheme[ThemeId]) {
            NSMutableDictionary *aTheme = [s_defaultTheme mutableCopy];
            [aTheme addEntriesFromDictionary:_curTheme];
            _curTheme = aTheme;
        } else {
            _curTheme = s_defaultTheme;
        }
        _curThemeId = _curTheme[ThemeId];
        
        _curStyle = [_curTheme[ThemeStyle] integerValue];
        if (_curStyle < 0 || _curStyle > 1) {
            _curStyle = 0;
        }
        if (_curTheme[ThemeStatusStyle]) {
            _curStatusStyle = [_curTheme[ThemeStatusStyle] integerValue];
            if (_curStatusStyle < 0 || _curStatusStyle > 1) {
                _curStatusStyle = _curStyle;
            }
        } else {
            _curStatusStyle = _curStyle;
        }
    }
    return self;
}


#pragma mark - Public

+ (NSInteger)curStyle
{
    return [[self shareInstance] curStyle];
}

+ (NSInteger)curStatusStyle
{
    return [[self shareInstance] curStatusStyle];
}

+ (UIColor *)colorFor:(NSString *)colorKey
{
    return [[self shareInstance] colorFor:colorKey];
}

#pragma mark - Theme Setting

- (NSArray *)themeList
{
    return _arrThemes;
}

- (NSString *)selectThemeId
{
    return _curTheme[ThemeId];
}

- (void)setSelectThemeId:(NSString *)aThemeId
{
    if (aThemeId == nil || [aThemeId isEqualToString:_curThemeId]) {
        return;
    }
    NSDictionary *aTheme = _dicThemes[aThemeId];
    if (aThemeId == nil) {
        return;
    }
    // 开始修改主题
    NSMutableDictionary *newTheme = [s_defaultTheme mutableCopy];
    [newTheme addEntriesFromDictionary:aTheme];
    _curTheme = newTheme;
    [_dicColors removeAllObjects];
    _curThemeId = newTheme[ThemeId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticThemeChanged object:_curTheme];
}

#pragma mark - Private

- (UIColor *)colorFor:(NSString *)colorKey
{
    if (colorKey.length == 0) {
        return nil;
    }
    UIColor *theColor = [_dicColors objectForKey:colorKey];
    if (theColor) {
        return theColor;
    }
    NSString *theColorStr = _curTheme[colorKey];
    if (theColorStr == nil) {
        return nil;
    } else if (theColorStr.length == 0) {
        theColor = [UIColor clearColor];
    } else {
        if ([theColorStr hasPrefix:@"Theme"]) {
            theColor = [self colorFor:theColorStr];
        } else {
            theColor = [self.class colorFromHexRGB:theColorStr];
        }
    }
    return theColor;
}




@end
