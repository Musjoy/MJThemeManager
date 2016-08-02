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
#ifdef MODULE_CACHE_MANAGER
#import "CacheManager.h"
#endif
#ifdef HEADER_CONTROLLER_MANAGER
#import HEADER_CONTROLLER_MANAGER
#endif

#ifndef kDefualtSelectThemeId
#define kDefualtSelectThemeId   @"DefualtSelectThemeId"
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
    int length = inColorString.length * 4;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> (length-8));
    greenByte = (unsigned char) (colorCode >> (length-16));
    blueByte = (unsigned char) (colorCode  >> (length-24)); // masks off high bits
    float alpha = 1.0;
    if (length > 24) {
        int dLength = length-24;
        unsigned char alphaByte = (unsigned char) (colorCode - ((colorCode  >> dLength) << dLength));
        if (length == 28) {
            alpha = (float)alphaByte / 0xf;
        } else if (length == 32) {
            alpha = (float)alphaByte / 0xff;
        }
    }
    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:alpha];
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
            @{kThemeId                  : @"0",
              kThemeStyle               : @0,
              kThemeMainColor           : @"007AFF",
              kThemeContrastColor       : @"FFFFFF",
              kThemeBgColor             : kThemeContrastColor,
              kThemeHeaderBgColor       : kThemeBgColor,
              kThemeContentBgColor      : @"",
              kThemeTextColor           : @"000000",
              kThemeTabTintColor        : kThemeMainColor,
//              kThemeTabBgColor          : @"",
//              kThemeTabSelectBgColor : ,
              kThemeNavTintColor        : kThemeMainColor,
//              kThemeNavBgColor       : @"",
              kThemeNavTitleColor       : kThemeNavTintColor,
              kThemeBtnTintColor        : kThemeMainColor,
              kThemeBtnTintColor2       : kThemeBtnTintColor,
              kThemeBtnBgColor          : kThemeMainColor,
              kThemeBtnContrastColor    : kThemeContrastColor,
              kThemeCellTintColor       : kThemeMainColor,
              kThemeCellBgColor         : @"",
              kThemeCellTextColor       : kThemeTextColor,
              kThemeCellSubTextColor    : @"666666",
              kThemeCellBtnColor        : kThemeBtnTintColor,
              kThemeCellLineColor       : @"999999",
//              kThemeGlassColor          : @"",
              kThemeRefreshColor        : kThemeMainColor};
        
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
    return [[self shareInstance] curStyle];
}

+ (NSInteger)curStatusStyle
{
    return [[self shareInstance] curStatusStyle];
}

+ (UIImage *)curBgImage
{
    NSString *imageStr = [[self shareInstance] curTheme][kThemeBgImageName];
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
        theImage = [CacheManager getLocalFileWithUrl:imageStr fileType:eCacheFileImage completion:NULL];
#endif
    }
    return theImage;
}

+ (UIColor *)colorFor:(NSString *)colorKey
{
    return [[self shareInstance] colorFor:colorKey];
}

+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size
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
    if (theColor) {
        [_dicColors setObject:theColor forKey:colorKey];
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
        theImage = [CacheManager getLocalFileWithUrl:aImageName fileType:eCacheFileImage completion:^(BOOL isSucceed, NSString *message, NSObject *data) {
            if (completion) {
                completion(isSucceed);
            }
        }];
#endif
    }
    return theImage;
}


@end
