//
//  UITableViewCell+Theme.m
//  Pods
//
//  Created by 黄磊 on 16/7/5.
//
//

#import "UITableViewCell+Theme.h"
#import "MJThemeManager.h"

@implementation UITableViewCell (Theme)

- (void)reloadTheme
{
    NSString *themeIdentifier = [self themeIdentifier];
    [self setTintColor:[MJThemeManager colorFor:kThemeTintColor andIdentifier:themeIdentifier]];
    [self setBackgroundColor:[MJThemeManager colorFor:kThemeCellBgColor andIdentifier:themeIdentifier]];
    [self.textLabel setTextColor:[MJThemeManager colorFor:kThemeCellTextColor andIdentifier:themeIdentifier]];
    [self.detailTextLabel setTextColor:[MJThemeManager colorFor:kThemeCellSubTextColor andIdentifier:themeIdentifier]];
    UIColor *hlBgColor = [MJThemeManager colorFor:kThemeCellHLBgColor andIdentifier:themeIdentifier];
    if (hlBgColor) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [bgView setBackgroundColor:hlBgColor];
        self.selectedBackgroundView = bgView;    
    } else {
        self.selectedBackgroundView = nil;
    }
}

@end
