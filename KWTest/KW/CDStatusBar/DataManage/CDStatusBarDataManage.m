//
//  CDStatusBarDataManage.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/2.
//
//

#import "CDStatusBarDataManage.h"

static NSString * const list = @"CDStatusBarList";
static NSString * const selectItem = @"CDStatusBarSelectItem";

@implementation CDStatusBarDataManage

+ (NSString *)selectItem
{
    if ([[self getUserDefaults] objectForKey:selectItem]) {
        return [[self getUserDefaults] objectForKey:selectItem];
    }
    else
    {
        NSArray *array = [[self getUserDefaults] objectForKey:list];
        [self setSelectItem:array[0]];
        return array[0];
    }
}

+ (void)setSelectItem:(NSString *)item
{
    [[self getUserDefaults] setObject:item forKey:selectItem];
}
+ (NSMutableArray *)addItem:(NSString *)item
{
    NSMutableArray *array = [[[self getUserDefaults] objectForKey:list] mutableCopy];
    [array addObject:item];
    [[self getUserDefaults] setObject:array forKey:list];
    return array;
}

+ (NSMutableArray *)deleteItemAtIndex:(NSInteger)index
{
    NSMutableArray *array = [[[self getUserDefaults] objectForKey:list] mutableCopy];
    [array removeObjectAtIndex:index];
    [[self getUserDefaults] setObject:array forKey:list];
    return array;
}

+ (NSMutableArray *)listItem
{
    return [[[self getUserDefaults] objectForKey:list] mutableCopy];
}

+ (void)setListItem:(NSArray *)array
{
    if (![[self getUserDefaults] objectForKey:list]) {
        return[[self getUserDefaults] setObject:array forKey:list];
    }
}

+ (NSUserDefaults *)getUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}
@end
