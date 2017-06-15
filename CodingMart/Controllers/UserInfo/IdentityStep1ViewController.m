//
//  IdentityStep1ViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "IdentityStep1ViewController.h"
#import "IdentityStep2ViewController.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import "EAXibTipView.h"
#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import "MPayRewardOrderPayViewController.h"


@interface IdentityStep1ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *identityF;
@property (weak, nonatomic) IBOutlet UILabel *authDescL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *bottomL;
@property (strong, nonatomic) IBOutlet UIView *payV;
@property (weak, nonatomic) IBOutlet UILabel *payNameL;
@property (weak, nonatomic) IBOutlet UILabel *payIdentityL;

@property (strong, nonatomic) EAXibTipView *payTipV;
@end

@implementation IdentityStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF
    [_bottomL addLinkToStr:@"《身份认证授权与承诺书》" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToAgreement];
    }];
    _nameF.text = _info.name;
    _identityF.text = _info.identity;
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 1.0/[UIScreen mainScreen].scale: 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowH;
    if (indexPath.section == 0) {
        rowH = 130;
    }else if (indexPath.section == 1){
        rowH = 220;
    }else{
        rowH = 50 + 15 + 30 + [_authDescL.text getHeightWithFont:_authDescL.font constrainedToSize:CGSizeMake((kScreen_Width - 30 - 20), CGFLOAT_MAX)] + 2;//这个 +2 只是对高度计算不准确的冗余处理
    }
    return rowH;
}

#pragma mark Action
- (IBAction)bottomBtnClicked:(id)sender {
    if (_nameF.text.length <=0 || _identityF.text.length <= 0) {
        [NSObject showHudTipStr:_nameF.text.length <= 0? @"请正确填写姓名": @"请正确填写身份证号"];
        return;
    }
    _info.name = _nameF.text;
    _info.identity = _identityF.text;
    [self showPayTip];
}
    
- (void)afterPaySuccess{
    WEAKSELF
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_IdentityInfoBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.info = data;
            if (weakSelf.info.status.enum_identityStatus != EAIdentityStatus_REJECTED) {
                [weakSelf goToStep2];
            }else{
                kTipAlert(@"验证失败！姓名或身份证号输入有误。");
            }
        }
    }];
}

- (void)showPayTip{
    [self.view endEditing:YES];
    if (!_payTipV) {
        CGFloat height = 225;
        UILabel *tipL = [_payV viewWithTag:100];
        height += [tipL.text getHeightWithFont:tipL.font constrainedToSize:CGSizeMake(kScreen_Width - 60, CGFLOAT_MAX)];
        _payV.frame = CGRectMake(0, 0, kScreen_Width - 30, height);
        _payTipV = [EAXibTipView instancetypeWithXibView:_payV];
    }
    _payNameL.text = _nameF.text;
    _payIdentityL.text = _identityF.text;
    [_payTipV showInView:kKeyWindow];
}
- (IBAction)dismissPayTipV:(id)sender {
    [_payTipV dismiss];
}
- (IBAction)goToPay:(id)sender {
    _info.name = _nameF.text;
    _info.identity = _identityF.text;
    NSDictionary *params = @{@"name": _info.name,
                             @"identity": _info.identity};
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] post_GenerateIdentityMartOrder:params block:^(id data, NSError *error) {
        if (data) {
            [weakSelf goToPayOrder:data];
        }
    }];
//    
//    //ToDo
////    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
////        [NSObject showHudTipStr:@"您还没有安装「微信」，无法完成支付"];
////        [self.payTipV dismiss];
////    }else{
//        WEAKSELF
//        [NSObject showHUDQueryStr:@"请稍等..."];
//        [[Coding_NetAPIManager sharedManager] post_GenerateIdentityOrderBlock:^(id data, NSError *error) {
//            [NSObject hideHUDQuery];
//            if (data) {
//                [weakSelf.payTipV dismiss];
//                PayReq *req = [PayReq new];
//                req.partnerId = data[@"partnerid"];
//                req.prepayId = data[@"prepayid"];
//                req.nonceStr = data[@"noncestr"];
//                req.timeStamp = [data[@"timestamp"] intValue];
//                req.package = data[@"package"];
//                req.sign = data[@"sign"];
//                [WXApi sendReq:req];
//            }
//        }];
////    }
}
    
- (void)goToPayOrder:(MPayOrder *)order{
    [_payTipV dismiss];
    
    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
    vc.curMPayOrder = order;
    WEAKSELF
    vc.paySuccessBlock = ^(MPayOrder *curMPayOrder){
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        [self afterPaySuccess];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark - handleSucessPay
//- (void)handlePayURL:(NSURL *)url{//微信支付回调
//    NSInteger resultCode = [[url queryParams][@"ret"] intValue];
//    if (resultCode == 0) {//支付成功，再次「提交审核」
//        [self bottomBtnClicked];
//    }else if (resultCode == -1){
//        [NSObject showHudTipStr:@"支付失败"];
//    }
//}

#pragma mark VC
- (void)goToAgreement{
    NSString *urlStr = @"https://dn-coding-net-production-public-file.qbox.me/%E8%BA%AB%E4%BB%BD%E8%AE%A4%E8%AF%81%E6%8E%88%E6%9D%83%E4%B8%8E%E6%89%BF%E8%AF%BA%E4%B9%A6_160816.pdf";
    [self goToWebVCWithUrlStr:urlStr title:@"身份认证授权与承诺书"];
}

- (void)goToStep2{
    IdentityStep2ViewController *vc = [IdentityStep2ViewController vcInStoryboard:@"UserInfo"];
    vc.info = _info;
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:vc animated:YES];
}


@end
