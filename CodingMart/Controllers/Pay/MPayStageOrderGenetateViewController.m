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

@property (weak, nonatomic) IBOutlet UILabel *despL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *priceTipL;
@end

@implementation MPayStageOrderGenetateViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _despL.text = [NSString stringWithFormat:@"项目 %@ 的阶段 %@ 的款项", _curRewardP.basicInfo.id, _curStage.stage_no];
    
    _priceL.text = [NSString stringWithFormat:@"%@ 元", _curMPayOrder.totalFee];
    
    _priceTipL.text = [NSString stringWithFormat:@"包含 %@ 元阶段款 + %@.0%% 平台服务费", _curStage.price, _curRewardP.basicInfo.service_fee_percent];
}

- (IBAction)bottomBtnClicked:(id)sender {
    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
    vc.curReward = _curRewardP.basicInfo;
    vc.curMPayOrder = _curMPayOrder;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
