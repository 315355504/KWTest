//
//  CDStatusBarView.m
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import "CDStatusBarView.h"

NSString * const CDStatusBarViewTouch = @"CDStatusBarViewTouch";

@interface CDStatusBarView ()


@end
@implementation CDStatusBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _prompt = [[UILabel alloc] initWithFrame:frame];
        _prompt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _prompt.textAlignment = NSTextAlignmentCenter;
        _prompt.font = [UIFont systemFontOfSize:14.0];
        _prompt.textColor = [UIColor whiteColor];
        [self addSubview:_prompt];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(statusBarViewTouch:)]) {
        [_delegate statusBarViewTouch:self];
    }
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:CDStatusBarViewTouch object:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
