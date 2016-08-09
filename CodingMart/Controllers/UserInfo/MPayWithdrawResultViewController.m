//
//  MPayWithdrawResultViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayWithdrawResultViewController.h"
#import "NSDate+Helper.h"

@interface MPayWithdrawResultViewController ()
@property (strong, nonatomic) Withdraw *withdraw;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeL;
@property (weak, nonatomic) IBOutlet UILabel *accountL;
@property (weak, nonatomic) IBOutlet UILabel *createdAtL;
@property (weak, nonatomic) IBOutlet UILabel *updatedAtL;

@end

@implementation MPayWithdrawResultViewController

+ (instancetype)vcWithWithdraw:(Withdraw *)withdraw{
    MPayWithdrawResultViewController *vc = [MPayWithdrawResultViewController vcInStoryboard:@"UserInfo"];
    vc.withdraw = withdraw;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _totalFeeL.text = [NSString stringWithFormat:@"￥ %@", _withdraw.order.totalFee];
    _accountL.text = [NSString stringWithFormat:@"%@（%@）", _withdraw.account.account, _withdraw.account.accountName];
    
    _createdAtL.text = [[NSDate dateWithTimeIntervalSince1970:_withdraw.order.createdAt.doubleValue/1000] stringWithFormat:@"yyyy-MM-dd HH:mm"];
    _updatedAtL.text = [[NSDate dateWithTimeIntervalSince1970:_withdraw.order.updatedAt.doubleValue/1000] stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

@end
