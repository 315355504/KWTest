//
//  CDStatusBarWindow.m
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import "CDStatusBarWindow.h"

@implementation CDStatusBarWindow

/* 重写手势链传递
 * 除statusBar以外的范围传递下去
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}
@end
