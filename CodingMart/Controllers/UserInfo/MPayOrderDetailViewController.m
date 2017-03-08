//
//  MPayOrderDetailViewController.m
//  CodingMart
//
//  Created by Ease on 2016/11/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrderDetailViewController.h"
#import "NSDate+Helper.h"
#import "MPayRewardOrderPayViewController.h"
#import "Coding_NetAPIManager.h"
#import "RewardPrivate.h"

@interface MPayOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *bottomV;

#pragma process
@property (weak, nonatomic) IBOutlet UIImageView *p01_lineV;
@property (weak, nonatomic) IBOutlet UIImageView *p12_lineV;
@property (weak, nonatomic) IBOutlet UIImageView *p0_iconV;
@property (weak, nonatomic) IBOutlet UIImageView *p1_iconV;
@property (weak, nonatomic) IBOutlet UIImageView *p2_iconV;
@property (weak, nonatomic) IBOutlet UILabel *p0_timeL;
@property (weak, nonatomic) IBOutlet UILabel *p1_timeL;
@property (weak, nonatomic) IBOutlet UILabel *p2_timeL;
@property (weak, nonatomic) IBOutlet UILabel *p2_titleL;
@property (weak, nonatomic) IBOutlet UILabel *aliCountL;
@property (weak, nonatomic) IBOutlet UILabel *typeCountL;

@end

@implementation MPayOrderDetailViewController

+ (instancetype)vcWithOrder:(MPayOrder *)order{
    MPayOrderDetailViewController *vc = [MPayOrderDetailViewController vcInStoryboard:@"UserInfo" withIdentifier:[order isWithDraw]? @"MPayOrderDetailViewController_Process": @"MPayOrderDetailViewController"];
    vc.curOrder = order;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    static NSDictionary *statusNameDict;
    if (!statusNameDict) {
        statusNameDict = @{@"UnknownStatus": @"未知状态",
                           @"Pending": @"正在处理",
                           @"Success": @"已完成",
                           @"Fail": @"处理失败",
                           @"Cancel": @"已取消",};
        
    }

    _titleL.text = _curOrder.title;
    _feeL.text = [NSString stringWithFormat:@"%@%@", _curOrder.symbol, _curOrder.totalFee];
    _statusL.text = statusNameDict[_curOrder.status];
    _timeL.text = [_curOrder.createdAt stringWithFormat:@"yyyy-MM-dd HH:mm"];

    NSString *orderTypeName;
    if ([_curOrder.orderType isEqualToString:@"Refund"]){
        orderTypeName = ([_curOrder.productType isEqualToString:@"Reward"]? @"项目订金退款":
                         [_curOrder.productType isEqualToString:@"RewardStage"]? @"项目阶段退款": orderTypeName);
    }else{
        orderTypeName = _curOrder.tradeType;
    }
    _typeL.text = orderTypeName;

    if ([_curOrder isWithDraw] && ![_curOrder.productType isEqualToString:@"SystemFinance"]) {
        if (_curOrder.account) {
            _typeCountL.text = @"支付宝账号";
            _aliCountL.text = [NSString stringWithFormat:@"%@(%@)", _curOrder.account, _curOrder.accountName];
        } else if (_curOrder.invoiceNo){
            _typeCountL.text = @"发票编号";
            _aliCountL.text = _curOrder.invoiceNo;
        } else {
            _typeCountL.text = @"";
            _aliCountL.text = @"";
        }
        _p0_timeL.text = _p1_timeL.text = [_curOrder.createdAt stringWithFormat:@"yyyy-MM-dd HH:mm"];
        _p2_timeL.text = _curOrder.updatedAt? [_curOrder.updatedAt stringWithFormat:@"yyyy-MM-dd HH:mm"]: @"";
        
        BOOL isFailed = [_curOrder.status isEqualToString:@"Fail"];
        _p2_titleL.text = isFailed? [NSString stringWithFormat:@"提现失败 - %@", _curOrder.feedback]: @"提现完成";
        NSString *imageSuffix = (isFailed? @"red"://全红
                                 [_curOrder.status isEqualToString:@"Success"]? @"green"://全绿
                                 [_curOrder.status isEqualToString:@"Cancel"]? @"gray"://全灰
                                 nil);//部分
        _p01_lineV.image = [UIImage imageNamed:[NSString stringWithFormat:@"withdraw_p_line_%@", imageSuffix ?: @"green"]];
        _p12_lineV.image = [UIImage imageNamed:[NSString stringWithFormat:@"withdraw_p_line_%@", imageSuffix ?: @"gray"]];
        _p0_iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"withdraw_p_0_%@", imageSuffix ?: @"green"]];
        _p1_iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"withdraw_p_1_%@", imageSuffix ?: @"green"]];
        _p2_iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"withdraw_p_1_%@", imageSuffix ?: @"gray"]];
    }else{
        if (![_curOrder.orderType isEqualToString:@"RewardPrepayment"] ||
            ![_curOrder.productType isEqualToString:@"Reward"] ||
            ![_curOrder.status isEqualToString:@"Pending"]) {
            _bottomV.hidden = YES;
        }
    }

}
- (IBAction)bottomBtnClicked:(id)sender {
    WEAKSELF
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_RewardPrivateDetailWithId:_curOrder.productId.integerValue block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
            vc.curReward = [(RewardPrivate *)data basicInfo];
            vc.curMPayOrder = _curOrder;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
