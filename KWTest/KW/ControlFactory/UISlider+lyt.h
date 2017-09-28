//
//  UISlider+lyt.h
//  KDFDApp
//
//  Created by haoran on 16/9/14.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (lyt)

+(UISlider *)getSliderWithMaxValue:(CGFloat)max andMinValue:(CGFloat)min leftColor:(UIColor *)leftColor andRightColor:(UIColor *)rightColor normalImage:(NSString *)normal andHeigImage:(NSString *)high superView:(UIView *)superView;


@end
