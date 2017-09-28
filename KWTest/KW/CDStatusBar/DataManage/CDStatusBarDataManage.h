//
//  CDStatusBarDataManage.h
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/2.
//
//

#import <Foundation/Foundation.h>

@interface CDStatusBarDataManage : NSObject

+ (NSString *)selectItem;

+ (void)setSelectItem:(NSString *)item;

+ (NSMutableArray *)addItem:(NSString *)item;

+ (NSMutableArray *)deleteItemAtIndex:(NSInteger)index;

+ (NSMutableArray *)listItem;

+ (void)setListItem:(NSArray *)array;
@end
