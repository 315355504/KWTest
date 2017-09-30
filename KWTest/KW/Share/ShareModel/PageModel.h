//
//  PageModel.h
//  HuiBang
//
//  Created by Mr_zhaohy on 2017/1/13.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageModel : NSObject

@property (nonatomic,assign) NSInteger current;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pages;
@property (nonatomic,assign) NSInteger total;

@end
