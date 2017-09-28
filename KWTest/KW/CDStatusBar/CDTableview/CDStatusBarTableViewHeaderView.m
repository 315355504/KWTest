//
//  CDStatusBarTableViewHeaderView.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/2.
//
//

#import "CDStatusBarTableViewHeaderView.h"

@implementation CDStatusBarTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
