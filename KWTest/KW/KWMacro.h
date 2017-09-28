//
//  KWMacro.h
//  Erongdu
//
//  Created by Mr_zhaohy on 2017/1/12.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#ifndef KWMacro_h
#define KWMacro_h
//身份证图片
#define FrontImageFileName @"front.jpg"
#define BackImageFileName @"back.jpg"
#define OCRImageFileName @"ocr.jpg"
#define IDCardImageFloderName @"IDCard"
//活体识别面部图片
#define LivingImageFileName @"face.jpg"
#define LivingImageFloderName @"Face"

#define OCRDataFileName @"ocrData"
#define OCRFrontData @"encryptedFrontData"
#define OCRBackData @"encryptedBackData"
#define FaceData @"encryptedFaceData"

#define NOTICE_AppErrorNotification @"AppErrorNotification"
//是否登录
#define Logon [[KWAppUserProfile sharedInstance] isLogon]

//-----------------------------------------------------------

#define appDelegate		((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KEYWINDOW       ([UIApplication sharedpplication].keyWindow)
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBA_HEX(v, a) [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 green:((float)(((v) & 0xFF00) >> 8))/255.0 blue:((float)((v) & 0xFF))/255.0 alpha:(a)]

static NSString * const YGBBLUE = @"#1E81D2";
static NSString * const YGBBLUETEXT = @"#35a7e9";
static NSString * const BUTTONGRAY = @"#d9d9d9";
static NSString * const YGBGREY = @"#eff3f5";
static NSString * const YGBPickerGREY = @"#f4f4f6";
static NSString * const kNetState = @"NetState";

#define XPOINTOF(view) view.frame.origin.x
#define YPOINTOF(view) view.frame.origin.y
#define WIDTHOF(view) view.frame.size.width
#define HEIGHTOF(view) view.frame.size.height
#define MOVEVIEWTOX(view, x) view.frame = CGRectMake(x, YPOINTOF(view), WIDTHOF(view), HEIGHTOF(view))
#define MOVEVIEWTOY(view, y) view.frame = CGRectMake(XPOINTOF(view), y, WIDTHOF(view), HEIGHTOF(view))
#define CHANGEWIDTHOFVIEW(view, width) view.frame = CGRectMake(XPOINTOF(view), YPOINTOF(view), width, HEIGHTOF(view))
#define CHANGEHEIGHTOFVIEW(view, height) view.frame = CGRectMake(XPOINTOF(view), YPOINTOF(view), WIDTHOF(view), height)
#define LOADIMAGE(file,ext) [UIImage imageNamed:(file)]
#define GBSTR_FROM_DATA(data) [[NSString alloc] initWithData: (data) encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif)]

#define UTF82GBK(str) [[NSString alloc] initWithData:[str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding)] encoding: kCFStringEncodingGB_18030_2000]
#define GBK2UTF8(str) [[NSString alloc] initWithData:[str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] encoding: NSUTF8StringEncoding]
#define INT2STRING(intValue) [NSString stringWithFormat:@"%d", intValue]
#define INT2NUMBER(intValue) [NSNumber numberWithInt:intValue]
#define O2STR(obj) (obj ? [NSString stringWithFormat:@"%@", obj] : @"")
#define IDTOSTRING(idValue) (([idValue isKindOfClass:[NSString class]] && ![idValue isEqualToString:@"0"]) ? idValue : (([idValue isKindOfClass:[NSNumber class]] && ![idValue isEqual:@0]) ? O2STR(idValue) : @""))

#define FILE_FULL_PATH(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]
#define FILE_FULL_PATH_IN_DOCUMENT(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]
#define FILE_CACHE_PATH(path) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: (path)]

#define iPhone4 CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define iPhone5 CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define iPhone6 CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define iPhone6p CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)

#define ERROR_DOMAIN(domain) [NSString stringWithFormat:@"com.koudai.error.%@", domain]
#define API_ERRMSG(error) [error.userInfo objectForKey:@"message"] ? [error.userInfo objectForKey:@"message"] : @"接口错误"

#define HEIGHTOFSCREEN [[UIScreen mainScreen] bounds].size.height
#define WIDTHOFSCREEN [[UIScreen mainScreen] bounds].size.width
#define WIDTHRADIUS (WIDTHOFSCREEN/375.0)

#define IOSVERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define IOS7 (IOSVERSION >= 7.0)
#define IOS8 (IOSVERSION >= 8.0)
#define IOS9_2 (IOSVERSION >= 9.2)

#define IOS8_OR_LATER ([[UIDevice currentDevice].systemVersion intValue]>=8?YES:NO)


#define APPVERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define NSUSER_DEFAULT [NSUserDefaults standardUserDefaults]

/**
 *  平台联系方式
 */
#define platformTel @"4008003136"
#endif /* KWMacro_h */
