//
//  KWRouter.h
//  router
//
//  Created by Liang Shen on 2016/10/21.
//  Copyright © 2016年 com.erongdu.friday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HHRouter/HHRouter.h>
#import "KWRouteUrl.h"

@interface KWRouter : NSObject
+ (KWRouter *)shareManager;

-(void)createRouterForAllControllers;
@end
