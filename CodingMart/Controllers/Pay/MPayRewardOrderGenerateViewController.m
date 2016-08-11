//
//  MPayRewardOrderGenerateViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayRewardOrderGenerateViewController.h"
#import "UITTTAttributedLabel.h"
#import "MPayRewardOrderPayViewController.h"
#import "Coding_NetAPIManager.h"

@interface MPayRewardOrderGenerateViewController ()
@property (strong, nonatomic) MPayOrder *curMPayOrder;

@property (weak, nonatomic) IBOutlet UITextField *totalFeeF;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *bottomL;
@end

@implementation MPayRewardOrderGenerateViewController

- (void)setCurMPayOrder:(MPayOrder *)curMPayOrder{
    _curMPayOrder = curMPayOrder;
    if (_curMPayOrder) {
        _totalFeeF.text = _curMPayOrder.totalFee;
        _totalFeeF.userInteractionEnabled = NO;
    }else{
        _totalFeeF.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF;
    [_bottomL addLinkToStr:@"《码市用户权责条款》" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToAgreement];
    }];
    [self refresh];
}

- (void)refresh{
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_GenerateOrderWithRewardId:_curReward.id block:^(id data, NSError *error) {
        if (data) {
            weakSelf.curMPayOrder = data;
        }
    }];
}

- (void)goToAgreement{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"publish_agreement" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"码市用户权责条款"];
}


- (IBAction)bottomBtnClicked:(id)sender {
    if (_curMPayOrder) {
        MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
        vc.curMPayOrder = self.curMPayOrder;
        vc.curReward = self.curReward;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (_totalFeeF.text.floatValue < 500) {
            [NSObject showHudTipStr:@"订金金额不可低于 500 元"];
            return;
        }
        [NSObject showHUDQueryStr:@"生成订单..."];
        WEAKSELF;
        [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithRewardId:_curReward.id totalFee:_totalFeeF.text block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
                vc.curMPayOrder = weakSelf.curMPayOrder = data;
                vc.curReward = weakSelf.curReward;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

@end
