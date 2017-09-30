//
//  BannerScroll.m
//  CashLoan
//
//  Created by xia on 2017/8/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "BannerScroll.h"

@implementation BannerScroll

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

@end
