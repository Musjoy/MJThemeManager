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
    [self setTintColor:[MJThemeManager colorFor:kThemeMainColor]];
    [self setBackgroundColor:[MJThemeManager colorFor:kThemeCellBgColor]];
    [self.textLabel setTextColor:[MJThemeManager colorFor:kThemeCellTextColor]];
    [self.detailTextLabel setTextColor:[MJThemeManager colorFor:kThemeCellSubTextColor]];
    UIColor *hlBgColor = [MJThemeManager colorFor:kThemeCellHLBgColor];
    if (hlBgColor) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [bgView setBackgroundColor:hlBgColor];
        self.selectedBackgroundView = bgView;    
    } else {
        self.selectedBackgroundView = nil;
    }
}

@end
