//
//  KWShareView.h
//  Pods
//
//  Created by hey on 2016/12/21.
//
//

#import <UIKit/UIKit.h>
#import "ShareViewItem.h"

@protocol KWShareViewDelegate <NSObject>

-(void)shareViewDidSelectItemWith:(NSIndexPath *)indexPath withTitle:(NSString *)title;

@end

@protocol ShareViewItem <NSObject>

@end

@interface KWShareView : UIView

@property(nonatomic, strong)id<KWShareViewDelegate>KWShareViewDelegate;

-(void)showKWShareViewWith:(NSArray<ShareViewItem *> *)dataArray;

@end
