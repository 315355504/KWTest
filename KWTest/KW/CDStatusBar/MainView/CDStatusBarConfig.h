//
//  CDStatusBarConfig.h
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import <UIKit/UIKit.h>

static inline BOOL CDFrameAutoAdjustedForOrientation() {

#ifdef __IPHONE_8_0
    /**
     *  traitCollection 是描述当前界面环境，在ios8后支持
     */
    return [[UIScreen mainScreen] respondsToSelector:@selector(traitCollection)];
#else
    return NO;
#endif
}


#pragma mark - Status Bar Frame
/// Get the height of the status bar for given orientation.
static CGFloat CDGetStatusBarHeightForOrientation(UIInterfaceOrientation orientation) {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    if (CDFrameAutoAdjustedForOrientation()) {
        return CGRectGetHeight(statusBarFrame);
    }
    
    return (UIInterfaceOrientationIsLandscape(orientation)) ?
    CGRectGetWidth(statusBarFrame) :
    CGRectGetHeight(statusBarFrame);
}

/// Get the width of the status bar for given orientation.
static CGFloat CDGetStatusBarWidthForOrientation(UIInterfaceOrientation orientation) {
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    
    if (CDFrameAutoAdjustedForOrientation()) {
        return CGRectGetWidth(mainScreenBounds);
    }
    
    return (UIInterfaceOrientationIsPortrait(orientation)) ?
    CGRectGetWidth(mainScreenBounds) :
    CGRectGetHeight(mainScreenBounds);
}

static CGSize CDGetStatusBarSizeForOrientation(UIInterfaceOrientation orientation) {
    return CGSizeMake(CDGetStatusBarWidthForOrientation(orientation), CDGetStatusBarHeightForOrientation(orientation));

}

static CGRect CDGetStatusBarFrameForOrientation(UIInterfaceOrientation orientation) {
    CGSize statusBarSize = CDGetStatusBarSizeForOrientation(orientation);
    return CGRectMake(0, 0, statusBarSize.width, statusBarSize.height);
}

#pragma mark - Orientation Helper
/**
 Get the current device status bar orientation
 */
static UIInterfaceOrientation CDGetDeviceOrientation() {
    return [UIApplication sharedApplication].statusBarOrientation;
}



