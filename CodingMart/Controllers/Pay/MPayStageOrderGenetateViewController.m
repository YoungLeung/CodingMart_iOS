//
//  MPayStageOrderGenetateViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/31.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayStageOrderGenetateViewController.h"
#import "MPayRewardOrderPayViewController.h"


@interface MPayStageOrderGenetateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerL;

@property (weak, nonatomic) IBOutlet UILabel *despL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *priceTipL;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleL;
@end

@implementation MPayStageOrderGenetateViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _headerL.text = [NSString stringWithFormat:@"资金支付后才能启动%@", [self p_priceTitle]];
    _priceTitleL.text = [NSString stringWithFormat:@"%@金额", [self p_priceTitle]];
    if (_curMPayOrder) {
        _despL.text = [NSString stringWithFormat:@"项目 %@ 中阶段 %@ 的款项", _curRewardP.basicInfo.id, _curStage.stage_no];
        _priceL.text = [NSString stringWithFormat:@"%@ 元", _curMPayOrder.totalFee];
        _priceTipL.text = [NSString stringWithFormat:@"包含 %@ 元阶段款 + %@.0%% 平台服务费", _curStage.price, _curRewardP.basicInfo.service_fee_percent];
    }else if (_curMPayOrders){
        _despL.text = [NSString stringWithFormat:@"项目 %@ 中角色 %@ 的%@款项", _curRewardP.basicInfo.id, _curRole.role_name, [self p_priceTitle]];
        _priceL.text = [NSString stringWithFormat:@"%@ 元", _curMPayOrders.orderAmount];
        _priceTipL.text = [NSString stringWithFormat:@"包含 %@ 元阶段款 + %.1f%% 平台服务费", _curMPayOrders.stageAmount, _curMPayOrders.serviceFee.floatValue/_curMPayOrders.stageAmount.floatValue];
    }
}

-(NSString *)p_priceTitle{
    return _curMPayOrder? @"本阶段": [_curRole needToPayStageNum] == _curRole.stages.count? @"全部阶段": @"剩余阶段";
}

- (IBAction)bottomBtnClicked:(id)sender {
    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
    vc.curReward = _curRewardP.basicInfo;
    vc.curMPayOrder = _curMPayOrder;
    vc.curMPayOrders = _curMPayOrders;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
