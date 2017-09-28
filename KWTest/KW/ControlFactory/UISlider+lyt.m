//
//  UISlider+lyt.m
//  KDFDApp
//
//  Created by haoran on 16/9/14.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "UISlider+lyt.h"
#import "UIColor+Palette.h"
#import "KWSlider.h"

@implementation UISlider (lyt)


+(UISlider *)getSliderWithMaxValue:(CGFloat)max andMinValue:(CGFloat)min leftColor:(UIColor *)leftColor andRightColor:(UIColor *)rightColor normalImage:(NSString *)normal andHeigImage:(NSString *)high superView:(UIView *)superView {

    KWSlider *slide = [[KWSlider alloc]init];
    slide.maximumValue = max;
    slide.minimumValue = min;

    slide.maximumTrackTintColor = leftColor;
    slide.minimumTrackTintColor = rightColor;

    [slide setThumbImage: [UIImage imageNamed:normal] forState:UIControlStateNormal];
    [slide setThumbImage:[UIImage imageNamed:high] forState:UIControlStateHighlighted];
    slide.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:slide];
    
    return slide;
}
+ (UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
@end
