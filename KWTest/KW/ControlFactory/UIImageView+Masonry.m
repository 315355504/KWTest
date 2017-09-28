//
//  UIImageView+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UIImageView+Masonry.h"
#import "UIColor+Palette.h"
@implementation UIImageView (Masonry)

+(UIImageView *)getImageViewWithImageName:(NSString *)imageName superView:(UIView *)superView
{
    UIImageView *imageView;
    if (!imageName || [imageName isEqualToString:@""]) {
        imageView = [[UIImageView alloc] init];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:imageView];
    
    return imageView;
}

@end
