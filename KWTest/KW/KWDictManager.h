//
//  KWDictManager.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWDictManager : NSObject

/**
 联系人关系，type=CONTACT_RELATION
 */
@property (nonatomic,strong)NSArray *contactRelationList;
/**
 教育程度，type=EDUCATIONAL_STATE
 */
@property (nonatomic,strong)NSArray *educationalList;
/**
 居住时长，type=LIVE_TIME
 */
@property (nonatomic,strong)NSArray *liveTimeList;
/**
 婚姻状况，type=MARITAL_STATE
 */
@property (nonatomic,strong)NSArray *maritalList;
/**
 月薪范围，type=SALARY_RANGE
 */
@property (nonatomic,strong)NSArray *salaryRangeList;
/**
 工作时长，type=WORK_TIME
 */
@property (nonatomic,strong)NSArray *workTimeList;

+(KWDictManager *)shareManager;
@end
