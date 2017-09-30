//
//  QRCodeView.m
//  Pods
//
//  Created by Liang Shen on 2016/11/15.
//
//

#import "QRCodeView.h"
#import <Masonry/Masonry.h>
#import "KWAppSkinColor.h"

#define iOS8_OR_LATER ([[UIDevice currentDevice].systemVersion intValue]>=8?YES:NO)
@interface QRCodeView ()
//背景视图
@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UIImageView *qrImageVIew;

@property (nonatomic , strong) UIButton *cancelButton;

@end

@implementation QRCodeView
-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(void)showQRCodeViewWithUrl:(NSString *)qrCodeUrl
{
    [self createViews];
    [self createConstraints];
    _qrImageVIew.image = [self encodeQRImageWithContent:qrCodeUrl size:CGSizeMake(121, 121)];
}

-(void)createViews
{
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor darkGrayColor];
    _backView.alpha = 0.5;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC.view addSubview:_backView];
    
    
    self.backgroundColor = [KWAppSkinColor sharedInstance].viewBackgroundColor;
    [rootVC.view addSubview:self];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [KWAppSkinColor sharedInstance].navigationTextColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.text = @"二维码扫一扫";
    [self addSubview:_titleLabel];
    
    _qrImageVIew = [[UIImageView alloc] init];
    [self addSubview:_qrImageVIew];
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitleColor:[KWAppSkinColor sharedInstance].emphasisSubTextColor forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
}

-(void)createConstraints
{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        make.edges.equalTo(rootVC.view);
        
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView);
        make.right.equalTo(_backView);
        make.bottom.equalTo(_backView);
        make.height.equalTo(@(235));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [_qrImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(121, 121));
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(50));
    }];
}

-(void)dismissQRView
{
    [_backView removeFromSuperview];
    
    [self removeFromSuperview];
    
    _backView = nil;
}

-(void)cancelButtonClick
{
    [self dismissQRView];
}

- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    if (iOS8_OR_LATER) {
        NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
        
        //生成
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
        
        UIColor *onColor = [UIColor blackColor];
        UIColor *offColor = [UIColor whiteColor];
        
        //上色
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                           keysAndValues:
                                 @"inputImage",qrFilter.outputImage,
                                 @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                                 @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                                 nil];
        
        CIImage *qrImage = colorFilter.outputImage;
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
        codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRelease(cgImage);
    } else {
        //        codeImage = [QRCodeGenerator qrImageForString:content imageSize:size.width];
    }
    return codeImage;
}

@end
