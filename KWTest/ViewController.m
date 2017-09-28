//
//  ViewController.m
//  KWTest
//
//  Created by Kwin on 2017/9/28.
//  Copyright © 2017年 Kwin. All rights reserved.
//
#define TestURL @"http://api.xianjiavip.com/api/user/isPhoneExists1.htm"
#import "ViewController.h"
#import "KWAppError.h"
@interface ViewController ()
{
    NSDictionary * dic;
    NSDictionary * headDic;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dic = @{
//            @"mobileType" : @"1",
            @"phone" : @"13263266885",
//            @"versionNumber" : @"1.0.1"
            };
    headDic = @{
                @"signMsg" : @"1EF0590EF98613EB43575B44F0CF1534",
                @"token" : @""
                };
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
static void extracted(ViewController *object) {
    [KWAppError requestHTTPMethod:KWAppServiceMethodPOST URL:TestURL parameters:object->dic modelClass:nil errorDelegate:nil success:^(NSURLSessionDataTask *task, KWAppError *error, id model) {
        NSLog(@"%@",model);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
    } fail:^(NSURLSessionDataTask *task, KWAppError *error) {
        NSLog(@"%@",error.error);
    }];
}

- (void)extracted {
    extracted(self);
}

- (IBAction)touch:(UIButton *)sender {
    
    [self extracted];
     
    
  
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
