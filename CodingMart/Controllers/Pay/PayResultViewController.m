//
//  PayResultViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayResultViewController.h"
#import "RewardPrivateViewController.h"
#import "MartWebViewController.h"
#import "Reward.h"
#import "RewardActivitiesViewController.h"

@interface PayResultViewController ()
@property (strong, nonatomic) Reward *curReward;

@property (weak, nonatomic) IBOutlet UILabel *currentPaidL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *totalPaidL;
@property (weak, nonatomic) IBOutlet UILabel *totalLeftL;
@end

@implementation PayResultViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Pay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PayResultViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _curReward = [NSObject objectOfClass:@"Reward" fromJSON:_orderDict[@"reward"]];
    _currentPaidL.text = _orderDict[@"format_price"];
    _totalPaidL.text = [NSString stringWithFormat:@"￥%.2f", _curReward.price_with_fee.floatValue - _curReward.balance.floatValue];
    _totalLeftL.text = [NSString stringWithFormat:@"￥%.2f", _curReward.balance.floatValue];
//    _totalLeftL.text = _curReward.format_balance;
    _nameL.text = _curReward.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Btn 

- (IBAction)recordBtnClicked:(id)sender {
    [MobClick event:kUmeng_Event_UserAction label:@"支付结果_动态"];
    [self.navigationController pushViewController:[RewardActivitiesViewController vcWithActivities:[Activities ActivitiesWithRewardId:_curReward.id]] animated:YES];
}

- (IBAction)rewardDetailBtnClicked:(id)sender {
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:_curReward];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
