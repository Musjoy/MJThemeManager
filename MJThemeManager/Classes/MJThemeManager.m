//
//  MJThemeManager.m
//  Pods
//
//  Created by 黄磊 on 16/7/4.
//
//

#import "MJThemeManager.h"
#import HEADER_SERVER_URL
#if __has_include("FileSource.h")
#import "FileSource.h"
#endif
#ifdef MODULE_CACHE_MANAGER
#import "MJCacheManager.h"
#endif
#ifdef HEADER_CONTROLLER_MANAGER
#import HEADER_CONTROLLER_MANAGER
#endif
#ifdef HEADER_ANALYSE
#import HEADER_ANALYSE
#endif

#ifndef kDefualtSelectThemeId
#define kDefualtSelectThemeId   @"DefualtSelectThemeId"
#endif

#ifndef STAT_ChangeTheme
#define STAT_ChangeTheme        @"ChangeTheme"
#endif

// ===================
NSString *const kThemeId                    = @"themeId";
NSString *const kThemeThumb                 = @"themeThumb";
NSString *const kThemeName                  = @"themeName";
NSString *const kThemeBgImageName           = @"ThemeBgImageName";
// 主要颜色
NSString *const kThemeStyle                 = @"ThemeStyle";
NSString *const kThemeStatusStyle           = @"ThemeStatusStyle";
NSString *const kThemeMainColor             = @"ThemeMainColor";
NSString *const kThemeTintColor             = @"ThemeTintColor";
NSString *const kThemeContrastColor         = @"ThemeContrastColor";
NSString *const kThemeBgColor               = @"ThemeBgColor";
NSString *const kThemeHeaderBgColor         = @"ThemeHeaderBgColor";
NSString *const kThemeContentBgColor        = @"ThemeContentBgColor";
NSString *const kThemeTextColor             = @"ThemeTextColor";
// TabBar颜色
NSString *const kThemeTabTintColor          = @"ThemeTabTintColor";
NSString *const kThemeTabBgColor            = @"ThemeTabBgColor";
NSString *const kThemeTabSelectBgColor      = @"ThemeTabSelectBgColor";
// 导航栏颜色
NSString *const kThemeNavTintColor          = @"ThemeNavTintColor";
NSString *const kThemeNavBgColor            = @"ThemeNavBgColor";
NSString *const kThemeNavTitleColor         = @"ThemeNavTitleColor";
// 按钮颜色
NSString *const kThemeBtnTintColor          = @"ThemeBtnTintColor";
NSString *const kThemeBtnTintColor2         = @"ThemeBtnTintColor2";
NSString *const kThemeBtnBgColor            = @"ThemeBtnBgColor";
NSString *const kThemeBtnContrastColor      = @"ThemeBtnContrastColor";
// Cell颜色
NSString *const kThemeCellTintColor         = @"ThemeCellTintColor";
NSString *const kThemeCellBgColor           = @"ThemeCellBgColor";
NSString *const kThemeCellHLBgColor         = @"ThemeCellHLBgColor";
NSString *const kThemeCellTextColor         = @"ThemeCellTextColor";
NSString *const kThemeCellSubTextColor      = @"ThemeCellSubTextColor";
NSString *const kThemeCellBtnColor          = @"ThemeCellBtnColor";
NSString *const kThemeCellLineColor         = @"ThemeCellLineColor";
// 广告颜色设置
NSString *const kThemeAdTitleColor          = @"ThemeAdTitleColor";
NSString *const kThemeAdTextColor           = @"ThemeAdTextColor";
NSString *const kThemeAdDetailColor         = @"ThemeAdDetailColor";
NSString *const kThemeAdBtnColor            = @"ThemeAdBtnColor";
NSString *const kThemeAdBtnBgColor          = @"ThemeAdBtnBgColor";
// 其他颜色
NSString *const kThemeGlassColor            = @"ThemeGlassColor";
NSString *const kThemeRefreshColor          = @"ThemeRefreshColor";
NSString *const kThemeSearchBarBgColor      = @"ThemeSearchBarBgColor";


NSString *const kNoticThemeChanged          = @"NoticThemeChanged";

static MJThemeManager *s_themeManager   = nil;

static NSDictionary *s_defaultTheme    = nil;

@interface MJThemeManager ()

@property (nonatomic, strong) NSArray *arrThemes;
@property (nonatomic, strong) NSMutableDictionary *dicThemes;
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
    int length = inColorString.length;
    if (length > 8) {
        inColorString = [inColorString substringFromIndex:length-8];
        length = 8;
    }
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    
    float alpha = 1.0;
    if (length > 6) {
        unsigned char alphaByte = (unsigned char)(colorCode  >> 24);
        colorCode = colorCode - ((colorCode >> 24) << 24);
        if (length == 7) {
            alpha = (float)alphaByte / 0xf;
        } else if (length == 8) {
            alpha = (float)alphaByte / 0xff;
        }
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char)colorCode;
    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:alpha];
    return result;
}

+ (instancetype)sharedInstance
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
            @{kThemeId                  : @"0",
              kThemeStyle               : @0,
              kThemeTintColor           : @"007AFF",
              kThemeMainColor           : kThemeTintColor,
              kThemeContrastColor       : @"FFFFFF",
              kThemeBgColor             : kThemeContrastColor,
              kThemeHeaderBgColor       : kThemeBgColor,
              kThemeContentBgColor      : @"",
              kThemeTextColor           : @"000000",
              kThemeTabTintColor        : kThemeTintColor,
//              kThemeTabBgColor          : @"",
//              kThemeTabSelectBgColor : ,
              kThemeNavTintColor        : kThemeTintColor,
//              kThemeNavBgColor       : @"",
              kThemeNavTitleColor       : kThemeNavTintColor,
              kThemeBtnTintColor        : kThemeTintColor,
              kThemeBtnTintColor2       : kThemeBtnTintColor,
              kThemeBtnBgColor          : kThemeTintColor,
              kThemeBtnContrastColor    : kThemeContrastColor,
              kThemeCellTintColor       : kThemeTintColor,
              kThemeCellBgColor         : @"",
              kThemeCellTextColor       : kThemeTextColor,
              kThemeCellSubTextColor    : @"666666",
              kThemeCellBtnColor        : kThemeBtnTintColor,
              kThemeCellLineColor       : @"999999",
//              kThemeGlassColor          : @"",
              kThemeRefreshColor        : kThemeTintColor,
              kThemeAdTitleColor        : kThemeCellTextColor,
              kThemeAdTextColor         : kThemeCellSubTextColor,
              kThemeAdDetailColor       : kThemeAdTitleColor,
              kThemeAdBtnColor          : @"FFFFFF",
              kThemeAdBtnBgColor        : @"5DC75F",};
        
        // 读取本地可能存在的默认主题设置
        NSDictionary *dicDefault = getFileData(FILE_NAME_THEME_CONFIG);
        if (dicDefault) {
            NSMutableDictionary *newDefaultTheme = [s_defaultTheme mutableCopy];
            [newDefaultTheme  addEntriesFromDictionary:dicDefault];
            s_defaultTheme = newDefaultTheme;
        }
        
        _dicColors = [[NSMutableDictionary alloc] init];
        _dicThemes = [[NSMutableDictionary alloc] init];
        
        // 加载主题文件
        _arrThemes = getFileData(FILE_NAME_THEME_LIST);
        if (_arrThemes.count > 0) {
            // 处理主题列表
            NSMutableArray *arrAvailable = [[NSMutableArray alloc] init];
            for (NSDictionary *aTheme in _arrThemes) {
                NSLog(@"%@", aTheme[kThemeId]);
                if (aTheme[kThemeId]) {
                    if ([_dicThemes objectForKey:aTheme[kThemeId]]) {
                        LogError(@"There are two same themeId : (%@)", aTheme[kThemeId]);
                    } else {
                        [_dicThemes setObject:aTheme forKey:aTheme[kThemeId]];
                        [arrAvailable addObject:aTheme];
                    }
                }
            }
            _arrThemes = arrAvailable;
            // 读取当前选中的主题
            NSString *selectThemeId = [[NSUserDefaults standardUserDefaults] objectForKey:kDefualtSelectThemeId];
            if (selectThemeId) {
                _curTheme = _dicThemes[selectThemeId];
            } else if (_arrThemes.count > 0) {
                _curTheme = _arrThemes[0];
            }
        }
        if (_curTheme && _curTheme[kThemeId]) {
            NSMutableDictionary *aTheme = [s_defaultTheme mutableCopy];
            [aTheme addEntriesFromDictionary:_curTheme];
            _curTheme = aTheme;
        } else {
            _curTheme = s_defaultTheme;
        }
        _curThemeId = _curTheme[kThemeId];
        
        _curStyle = [_curTheme[kThemeStyle] integerValue];
        if (_curStyle < 0 || _curStyle > 1) {
            _curStyle = 0;
        }
        if (_curTheme[kThemeStatusStyle]) {
            _curStatusStyle = [_curTheme[kThemeStatusStyle] integerValue];
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
    return [[self sharedInstance] curStyle];
}

+ (NSInteger)curStatusStyle
{
    return [[self sharedInstance] curStatusStyle];
}

+ (UIImage *)curBgImage
{
    NSString *imageStr = [[self sharedInstance] curTheme][kThemeBgImageName];
    if (imageStr.length == 0) {
        return nil;
    }
    UIImage *theImage = [UIImage imageNamed:imageStr];
    if (theImage == nil) {
        // 网络图片需下载
#ifdef MODULE_CACHE_MANAGER
        if (![imageStr hasPrefix:@"http"]) {
#ifdef kServerUrl
            if ([imageStr hasPrefix:@"/"]) {
                imageStr = [kServerUrl stringByAppendingString:imageStr];
            } else {
                imageStr = [NSString stringWithFormat:@"%@/%@", kServerUrl, imageStr];;
            }
#else
            return nil;
#endif
        }
        theImage = [MJCacheManager getLocalFileWithUrl:imageStr fileType:eCacheFileImage completion:NULL];
#endif
    }
    return theImage;
}

+ (UIColor *)colorFor:(NSString *)colorKey
{
    return [[self sharedInstance] colorFor:colorKey];
}

+ (UIColor *)colorFor:(NSString *)colorKey andIdentifier:(NSString *)themeIdentifier
{
    if (themeIdentifier.length > 0) {
        colorKey = [colorKey stringByAppendingFormat:@"-%@", themeIdentifier];
    }
    return [[self sharedInstance] colorFor:colorKey];
}

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)thumbImageForTheme:(NSString *)aThemeId
{
    
}

#pragma mark - Theme Setting

- (NSArray *)themeList
{
    return _arrThemes;
}

- (UIImage *)thumbImageForTheme:(NSString *)aThemeId
{
    NSDictionary *aTheme = _dicThemes[aThemeId];
    if (!aTheme) {
        return nil;
    }
    NSString *imageStr = aTheme[kThemeThumb];
    if (imageStr.length == 0) {
        return nil;
    }
    UIImage *theImage = [self getImageForImageName:imageStr completion:NULL];
    return theImage;
}

- (NSString *)fullImageNameFor:(NSString *)aImageName
{
    NSString *fullName = aImageName;
    if (![fullName hasPrefix:@"http"]) {
#ifdef kServerUrl
        if ([fullName hasPrefix:@"/"]) {
            fullName = [kServerUrl stringByAppendingString:fullName];
        } else {
            fullName = [NSString stringWithFormat:@"%@/%@", kServerUrl, fullName];
        }
#endif
    }
    return fullName;

}

- (NSString *)selectThemeId
{
    return _curTheme[kThemeId];
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
    _curThemeId = newTheme[kThemeId];
    _curStyle = [_curTheme[kThemeStyle] integerValue];
    if (_curStyle < 0 || _curStyle > 1) {
        _curStyle = 0;
    }
    if (_curTheme[kThemeStatusStyle]) {
        _curStatusStyle = [_curTheme[kThemeStatusStyle] integerValue];
        if (_curStatusStyle < 0 || _curStatusStyle > 1) {
            _curStatusStyle = _curStyle;
        }
    } else {
        _curStatusStyle = _curStyle;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_curThemeId forKey:kDefualtSelectThemeId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticThemeChanged object:_curTheme];
}

- (void)selectThemeWith:(NSString *)aThemeId completion:(ThemeSelectBlock)completion
{
    // 首先判断改主题是否完整
    [self checkAllImageInTheme:aThemeId completion:^(BOOL isSucced) {
        if (isSucced) {
            triggerEventStr(STAT_ChangeTheme, aThemeId);
            [self setSelectThemeId:aThemeId];
        }
        completion(isSucced);
    }];
}

- (void)checkAllImageInTheme:(NSString *)aThemeId completion:(ThemeSelectBlock)completion
{
    NSDictionary *aTheme = [_dicThemes objectForKey:aThemeId];
    if (!aTheme) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    __block int imageCount = 0;
    __block BOOL isBlockCalled = NO;
    __block BOOL haveLoading = NO;
    for (NSString *aKey in aTheme.allKeys) {
        if ([aKey hasSuffix:@"ImageName"]) {
            // 有一张图片
            imageCount++;
            UIImage *aImage = [self getImageForImageName:aTheme[aKey] completion:^(BOOL isSucced) {
                if (isSucced) {
                    imageCount--;
                    if (imageCount <= 0) {
                        isBlockCalled = YES;
                        if (completion) {
                            completion(YES);
                        }
#ifdef THEControllerManager
                        if (haveLoading) {
                            [THEControllerManager stopLoading];
                        }
#endif
                    }
                } else if (!isBlockCalled) {
                    isBlockCalled = YES;
                    if (completion) {
                        completion(NO);
                    }
#ifdef THEControllerManager
                    if (haveLoading) {
                        [THEControllerManager stopLoading];
                    }
#endif
                }
            }];
            if (aImage) {
                imageCount--;
            }
        }
    }

    if (imageCount == 0) {
        isBlockCalled = YES;
        if (completion) {
            completion(YES);
        }
    } else {
#ifdef THEControllerManager
        haveLoading = YES;
        [THEControllerManager startLoading:@"Downloading theme..."];
#endif
    }
}


#pragma mark - Private

- (UIColor *)colorFor:(NSString *)colorKey
{
    if (colorKey.length == 0) {
        return nil;
    }
    UIColor *theColor = [_dicColors objectForKey:colorKey];
    if (theColor) {
        if ([theColor isKindOfClass:[NSNull class]]) {
            return nil;
        }
        return theColor;
    }
    NSString *theColorStr = _curTheme[colorKey];
    if (theColorStr == nil) {
        // 截取字符串判断
        NSRange aRange = [colorKey rangeOfString:@"-"];
        if (aRange.length > 0) {
            NSString *strFirstColor = [colorKey substringToIndex:aRange.location];
            NSString *strSecondColor = _curTheme[strFirstColor];
            // 判读上一级颜色是否存在
            if (strSecondColor.length > 0 && [strSecondColor hasSuffix:@"Color"]) {
                NSString *strNewColorKey = [strSecondColor stringByAppendingString:[strFirstColor substringFromIndex:aRange.length]];
                NSString *theColor = [self colorFor:strNewColorKey];
            }
            if (theColor == nil) {
                // 去掉尾巴继续查找
                aRange = [colorKey rangeOfString:@"-" options:NSBackwardsSearch];
                theColor = [self colorFor:[colorKey substringToIndex:aRange.location]];
            }
        }
    } else if (theColorStr.length == 0) {
        theColor = [UIColor clearColor];
    } else {
        if ([theColorStr hasPrefix:@"Theme"]) {
            theColor = [self colorFor:theColorStr];
        } else {
            theColor = [self.class colorFromHexRGB:theColorStr];
        }
    }
    if (theColor) {
        [_dicColors setObject:theColor forKey:colorKey];
    } else {
        [_dicColors setObject:[NSNull null] forKey:colorKey];
    }
    return theColor;
}

- (UIImage *)getImageForImageName:(NSString *)aImageName completion:(ThemeSelectBlock)completion
{
    UIImage *theImage = [UIImage imageNamed:aImageName];
    if (theImage == nil) {
        // 网络图片需下载
#ifdef MODULE_CACHE_MANAGER
        if (![aImageName hasPrefix:@"http"]) {
#ifdef kServerUrl
            if ([aImageName hasPrefix:@"/"]) {
                aImageName = [kServerUrl stringByAppendingString:aImageName];
            } else {
                aImageName = [NSString stringWithFormat:@"%@/%@", kServerUrl, aImageName];
            }
#else
            if (completion) {
                completion(NO);
            }
            return nil;
#endif
        }
        theImage = [MJCacheManager getLocalFileWithUrl:aImageName fileType:eCacheFileImage completion:^(BOOL isSucceed, NSString *message, NSObject *data) {
            if (completion) {
                completion(isSucceed);
            }
        }];
#endif
    }
    return theImage;
}


@end
