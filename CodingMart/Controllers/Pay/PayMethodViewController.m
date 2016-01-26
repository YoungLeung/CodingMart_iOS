//
//  PayMethodViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "Coding_NetAPIManager.h"
#import "PayMethodRewardCell.h"
#import "PayMethodTipCell.h"
#import "PayMethodItemCell.h"
#import "PayMethodInputCell.h"
#import "PayMethodRemarkCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PayResultViewController.h"

@interface PayMethodViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *myTableView;

@property (assign, nonatomic) NSUInteger choosedIndex;
@property (strong, nonatomic) NSString *inputPrice;
@end

@implementation PayMethodViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Pay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PayMethodViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.choosedIndex = [self p_canOpenAliPay]? 0: [self p_canOpenWeiXin]? 1: 2;
}

- (void)setCurReward:(Reward *)curReward{
    _curReward = curReward;
    
//    _curReward.price = @(8000);
//    _curReward.balance = @(500);
    
    self.inputPrice = self.curReward.balance.stringValue;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self refresh];
//}
//
//- (void)refresh{
//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] get_RewardPrivateDetailWithId:self.curReward.id.integerValue block:^(id data, NSError *error) {
//        if (data) {
//            weakSelf.curReward = data;
//            [weakSelf.myTableView reloadData];
//        }
//    }];
//}

#pragma mark - app url
- (BOOL)p_canOpenWeiXin{
    return [self p_canOpen:@"weixin://"];
}

- (BOOL)p_canOpenAliPay{
    return [self p_canOpen:@"alipay://"];
}

- (BOOL)p_canOpen:(NSString*)url{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}
#pragma mark - TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if (section == 0) {
        height = 0;
    }else if (section == 1){
        height = 40;
    }else{
        height = 25;
        height += [[self p_lastHeaderTipStr] getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)];
    }
    return height;
}

- (NSString *)p_lastHeaderTipStr{
    NSString *tipStr =
    _choosedIndex == 2? @"抱歉，目前只支持线下转账方式，您在转账的时候请务必写上备注信息，谢谢配合！":
    _curReward.balance.integerValue > 5000? @"支持多次付款，本次付款金额不能少于 ￥5,000":
    @"待支付款项不大于 ￥5,000，需一次付清";
    return tipStr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *tipStr = nil;
    if (section == 1) {
        tipStr = @"支付方式";
    }else if (section == 2){
        tipStr = [self p_lastHeaderTipStr];
    }
    UIView *headerV;
    if (tipStr.length > 0) {
        headerV = [UIView new];
        headerV.backgroundColor = [UIColor clearColor];
        UILabel *headerL = [UILabel new];
        headerL.font = [UIFont systemFontOfSize:12];
        headerL.textColor = [UIColor colorWithHexString:@"0x999999"];
        headerL.numberOfLines = 0;
        headerL.text = tipStr;
        [headerV addSubview:headerL];
        [headerL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerV).offset(15);
            make.left.equalTo(headerV).offset(15);
            make.right.equalTo(headerV).offset(-15);
        }];
    }
    return headerV;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRows;
    if (section == 0) {
        numOfRows = [_curReward hasPaidSome]? 2: 1;
    }else if (section == 1){
        numOfRows = 3;
    }else{
        numOfRows = 1;
    }
    return numOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        height = indexPath.row == 0? [PayMethodRewardCell cellHeight]: [PayMethodTipCell cellHeight];
    }else if (indexPath.section == 1){
        height = [PayMethodItemCell cellHeight];
    }else{
        height = _choosedIndex < 2? [PayMethodInputCell cellHeight]: [PayMethodRemarkCell cellHeight];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PayMethodRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodRewardCell forIndexPath:indexPath];
            cell.curReward = _curReward;
            return cell;
        }else{
            PayMethodTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodTipCell forIndexPath:indexPath];
            cell.balanceStr = _curReward.format_price;
            return cell;
        }
    }else if (indexPath.section == 1){
        PayMethodItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@_%ld", kCellIdentifier_PayMethodItemCellPrefix, (long)indexPath.row] forIndexPath:indexPath];
        cell.isChoosed = _choosedIndex == indexPath.row;
        return cell;
    }else{
        if (_choosedIndex < 2) {
            PayMethodInputCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodInputCell forIndexPath:indexPath];
            cell.textF.text = _inputPrice;
            cell.textF.userInteractionEnabled = !(_curReward.balance && _curReward.balance.integerValue < 5000);
            __weak typeof(self) weakSelf = self;
            [cell.textF.rac_textSignal subscribeNext:^(NSString *value) {
                weakSelf.inputPrice = value;
            }];
            return cell;
        }else{
            PayMethodRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodRemarkCell forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:(indexPath.section == 0 && indexPath.row == 0? 0: 15) hasSectionLine:indexPath.section != 2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.choosedIndex = indexPath.row;
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - Btn

- (IBAction)payBtnClicked:(UIButton *)sender {
    PayResultViewController *vc = [PayResultViewController storyboardVC];
    vc.curReward = _curReward;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
