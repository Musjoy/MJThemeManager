//
//  UIView+Theme.m
//  Pods
//
//  Created by 黄磊 on 16/7/5.
//
//

#import "UIView+Theme.h"
#import "MJThemeManager.h"

@implementation UIView (Theme)

- (void)reloadTheme
{
    [self setTintColor:[MJThemeManager colorFor:kThemeMainColor]];
}

@end
