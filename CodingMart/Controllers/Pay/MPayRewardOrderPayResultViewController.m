//
//  MPayRewardOrderPayResultViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayRewardOrderPayResultViewController.h"
#import "RewardActivitiesViewController.h"
#import "RewardPrivateViewController.h"

@interface MPayRewardOrderPayResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalFeeL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation MPayRewardOrderPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _totalFeeL.text = [NSString stringWithFormat:@"￥%@", _curMPayOrders? _curMPayOrders.orderAmount: _curMPayOrder.totalFee];
    _titleL.text = [NSString stringWithFormat:@"「%@」%@", _curReward.id, _curReward.name];
}


#pragma mark - Btn

- (IBAction)recordBtnClicked:(id)sender {
    [MobClick event:kUmeng_Event_UserAction label:@"MPay_支付结果_动态"];
    UINavigationController *nav = self.navigationController;
    [nav popToRootViewControllerAnimated:NO];
    
    [nav pushViewController:[RewardActivitiesViewController vcWithActivities:[Activities ActivitiesWithRewardId:_curReward.id]] animated:YES];
}

- (IBAction)rewardDetailBtnClicked:(id)sender {
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:_curReward];
    UINavigationController *nav = self.navigationController;
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:YES];
}

@end
