//
//  Reward.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardRoleType.h"
#import "RewardWinnerInfo.h"
#import "JoinInfo.h"
#import "MartFile.h"
#import "User.h"
#import "HtmlMedia.h"

typedef NS_ENUM(NSInteger, RewardStatus) {
    RewardStatusFresh = 0,//待审核
    RewardStatusAccepted,//审核中
    RewardStatusRejected,//未通过
    RewardStatusCanceled,//已取消
    RewardStatusPassed,//未开始
    RewardStatusRecruiting,//招募中
    RewardStatusDeveloping,//开发中
    RewardStatusFinished,//已结束
    RewardStatusPrepare,//待支付
    RewardStatusMaintain//质保中
};

typedef NS_ENUM(NSInteger, PayMethodType) {
    PayMethodAlipay = 0,
    PayMethodWeiXin,
    PayMethodBank
};


@interface Reward : NSObject
//List
@property (strong, nonatomic) NSNumber *id, *type, *status, *progress, *price, *testService, *duration, *warranty, *reward_status, *apply_status, *balance, *price_with_fee, *version, *mpay, *visitCount, *service_type, *service_fee, *service_fee_percent;
@property (strong, nonatomic) NSNumber *need_pay_prepayment;
@property (strong, nonatomic) NSString *format_balance, *format_content, *plain_content, *format_price_with_fee, *format_first_sample, *format_second_sample, *developPlan, *rewardDemand, *industry, *industryName;
@property (strong, nonatomic) MartFile *first_attach_file, *second_attach_file, *require_doc_file;
@property (strong, nonatomic) NSString *cover, *home, *managerName;
@property (strong, nonatomic) User *owner;
@property (strong, nonatomic) HtmlMedia *format_contentMedia;
@property (strong, nonatomic) NSMutableArray *roleTypes, *roles, *winners;
@property (readwrite, nonatomic, strong) NSDictionary *propertyArrayMap;
@property (strong, nonatomic) NSString *cancelReason;

@property (strong, nonatomic, readonly) NSNumber *highPaid, *high_paid, *applyCount, *apply_count;
@property (strong, nonatomic, readonly) NSString *formatPriceNoCurrency, *format_price;

@property (strong, nonatomic) NSString *phaseType;
@property (assign, nonatomic, readonly) BOOL isNewPhase;

//Do Publish
@property (strong, nonatomic) NSNumber *budget, *require_clear, *need_pm;
@property (strong, nonatomic) NSString *name, *description_mine, *contact_name, *contact_email, *contact_mobile, *first_sample, *second_sample, *first_file, *second_file, *require_doc, *survey_extra, *contact_mobile_code, *recommend, *country, *phoneCountryCode;
//Display
@property (strong, nonatomic) NSString *typeDisplay, *typeImageName, *statusDisplay, *roleTypesDisplay, *statusStrColorHexStr, *statusBGColorHexStr;
@property (strong, nonatomic, readonly) NSArray *roleTypesNotCompleted;
//Pay
@property (strong, nonatomic) NSString *payMoney;
@property (assign ,nonatomic) PayMethodType payType;

- (BOOL)needToPay;
- (BOOL)hasPaidSome;
- (BOOL)hasConversation;

- (void)prepareToDisplay;
- (NSDictionary *)toPostParams;

- (NSString *)toShareLinkStr;

+ (BOOL)saveDraft:(Reward *)curReward;
+ (BOOL)deleteCurDraft;
+ (Reward *)rewardWithId:(NSUInteger)r_id;
+ (Reward *)rewardToBePublished;
@end
