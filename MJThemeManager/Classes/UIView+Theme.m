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

- (NSString *)themeIdentifier
{
    UIResponder *nextResponder = self.nextResponder;
    if ([nextResponder respondsToSelector:@selector(themeIdentifier)]) {
        return ((UIView *)nextResponder).themeIdentifier;
    }
    return nil;
}

- (void)reloadTheme
{
    [self setTintColor:[MJThemeManager colorFor:kThemeTintColor andIdentifier:self.themeIdentifier]];
}

@end
