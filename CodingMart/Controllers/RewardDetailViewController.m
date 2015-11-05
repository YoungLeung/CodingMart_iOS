//
//  RewardDetailViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/29.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardDetailViewController.h"
#import "Coding_NetAPIManager.h"
#import "RewardDetail.h"
#import "Login.h"
#import "LoginViewController.h"
#import "FillTypesViewController.h"
#import "RewardApplyViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface RewardDetailViewController ()
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) RewardDetail *rewardDetal;
@property (strong, nonatomic) UIView *bottomV;
@property (strong, nonatomic) UILabel *topTipL;
@end

@implementation RewardDetailViewController


+ (instancetype)vcWithReward:(Reward *)reward{
    RewardDetailViewController *vc = [self new];
    vc.curReward = reward;
    return vc;
}
+ (instancetype)vcWithRewardId:(NSUInteger)rewardId{
    Reward *reward = [Reward rewardWithId:rewardId];
    return [self vcWithReward:reward];
}

- (void)setCurReward:(Reward *)curReward{
    _curReward = curReward;
    self.curUrlStr = [NSString stringWithFormat:@"/p/%@", _curReward.id.stringValue];
    if (_curReward.title.length > 0) {
        self.titleStr = _curReward.title;
    }
}

- (void)setRewardDetal:(RewardDetail *)rewardDetal{
    _rewardDetal = rewardDetal;
    self.titleStr = _rewardDetal.reward.title;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleRefresh];
}

- (void)handleRefresh{
    [super handleRefresh];
    
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data0, NSError *error0) {//更新 Login_User 的数据
        [[Coding_NetAPIManager sharedManager] get_RewardDetailWithId:_curReward.id.integerValue block:^(id data, NSError *error) {//获取详细数据
            if (data) {
                weakSelf.rewardDetal = data;
                [weakSelf refreshNativeView];
            }
        }];
    }];
}
- (void)refreshNativeView{
    UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
    if (_rewardDetal.reward.status.integerValue == 5) {//招募中的 Reward
        //顶部提示
        if ([Login isLogin]) {
            User *loginUser = [Login curLoginUser];
            if (!loginUser.fullInfo.boolValue ||
                !loginUser.fullSkills.boolValue ||
                !loginUser.status.boolValue) {
                if (!_topTipL) {
                    _topTipL = [UILabel new];
                    _topTipL.textAlignment = NSTextAlignmentCenter;
                    _topTipL.backgroundColor = [UIColor colorWithHexString:@"0xF2DEDE"];
                    _topTipL.textColor = [UIColor colorWithHexString:@"0xC55351"];
                    _topTipL.font = [UIFont systemFontOfSize:12];
                    __weak typeof(self) weakSelf = self;
                    _topTipL.userInteractionEnabled = YES;
                    [_topTipL bk_whenTapped:^{
                        [weakSelf bottomBtnClicked:nil];
                    }];
                    [self.view addSubview:_topTipL];
                    [_topTipL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.right.equalTo(self.view);
                        make.height.mas_equalTo(27);
                    }];
                }
                _topTipL.text = (!loginUser.fullInfo.boolValue || !loginUser.fullSkills.boolValue)? @"未完善个人资料不能参与悬赏，去完善 >>": @"您的账号还未激活，请前往 Coding 网站激活 ";
            }else{
                [_topTipL removeFromSuperview];
            }
        }
        //底部按钮
        contentInset.bottom = 64;
        if (!_bottomV) {
            _bottomV = [UIView new];
            _bottomV.backgroundColor = self.view.backgroundColor;
            [_bottomV addLineUp:YES andDown:NO andColor:[UIColor colorWithHexString:@"0xDDDDDD"]];
            [self.view addSubview:_bottomV];
            [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(64);
            }];
        }
        [[_bottomV subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }];
        UIButton *button = [self p_bottomBtnWithStatus:_rewardDetal.joinStatus];
        [_bottomV addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        
//        if (rand()%2) {
//            UIButton *button = [self p_joinBtn];
//            [_bottomV addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(10, 15, 10, 15));
//            }];
//        }else{
//            UIButton *button1 = [self p_canceledBtn];
//            UIButton *button2 = [self p_rejectedBtn];
//            [_bottomV addSubview:button1];
//            [_bottomV addSubview:button2];
//            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.bottomV).offset(15);
//                make.right.equalTo(button2.mas_left).offset(-15);
//                make.width.top.bottom.equalTo(button2);
//            }];
//            [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.bottomV).offset(-15);
//                make.top.equalTo(self.bottomV).offset(10);
//                make.bottom.equalTo(self.bottomV).offset(-10);
//            }];
//        }
    }else{
        [_topTipL removeFromSuperview];
        [_bottomV removeFromSuperview];
        contentInset.bottom = 0;
    }
    self.webView.scrollView.contentInset = contentInset;
}

- (UIButton *)p_bottomBtnWithTitle:(NSString *)title bgColorHexStr:(NSString *)colorHexStr{
    UIButton *button = [UIButton new];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3.0;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:colorHexStr];
    return button;
}

- (UIButton *)p_bottomBtnWithStatus:(NSNumber *)joinStatus{
    UIButton *bottomBtn;
    switch (joinStatus.integerValue) {
        case JoinStatusFresh:
        case JoinStatusChecked:
            bottomBtn = [self p_bottomBtnWithTitle:@"待审核" bgColorHexStr:@"0xBBCED7"];
            break;
        case JoinStatusSucessed:
            bottomBtn = [self p_bottomBtnWithTitle:@"已通过" bgColorHexStr:@"0x549FD5"];
            break;
        case JoinStatusFailed:
            bottomBtn = [self p_bottomBtnWithTitle:@"已拒绝" bgColorHexStr:@"0xE3706E"];
            break;
        case JoinStatusCanceled:
            bottomBtn = [self p_bottomBtnWithTitle:@"已取消" bgColorHexStr:@"0xDDDDDD"];
            break;
        default:
            bottomBtn = [self p_bottomBtnWithTitle:@"参与悬赏" bgColorHexStr:@"0x3BBD79"];
            break;
    }
    return bottomBtn;
}


//- (UIButton *)p_joinBtn{
//    return [self p_bottomBtnWithTitle:@"参与悬赏" bgColorHexStr:@"0x3BBD79"];
//}
//- (UIButton *)p_waitingBtn{
//    return [self p_bottomBtnWithTitle:@"待审核" bgColorHexStr:@"0xBBCED7"];
//}
//- (UIButton *)p_rejectedBtn{
//    return [self p_bottomBtnWithTitle:@"已拒绝" bgColorHexStr:@"0xE3706E"];
//}
//- (UIButton *)p_canceledBtn{
//    return [self p_bottomBtnWithTitle:@"已取消" bgColorHexStr:@"0xDDDDDD"];
//}
//- (UIButton *)p_reJoinBtn{
//    return [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x3BBD79"];
//}
//- (UIButton *)p_passedBtn{
//    return [self p_bottomBtnWithTitle:@"已通过" bgColorHexStr:@"0x549FD5"];
//}

- (void)bottomBtnClicked:(UIButton *)sender{
    if ([Login isLogin]) {
        User *loginUser = [Login curLoginUser];
        if (!loginUser.fullInfo.boolValue || !loginUser.fullSkills.boolValue) {//未完善个人资料
            FillTypesViewController *vc = [FillTypesViewController storyboardVC];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (!loginUser.status.boolValue){//未激活
            [self goToWebVCWithUrlStr:@"https://coding.net/login?phone=phone" title:@"激活账号"];
        }else{//去提交
            if (_rewardDetal) {
                RewardApplyViewController *vc = [RewardApplyViewController storyboardVC];
                vc.rewardDetail = _rewardDetal;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        __weak typeof(self) weakSelf = self;
        LoginViewController *vc = [LoginViewController storyboardVCWithType:LoginViewControllerTypeLoginAndRegister mobile:nil];
        vc.loginSucessBlock = ^(){
            [weakSelf handleRefresh];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
    NSLog(@"bottomBtnClicked : %@", sender.titleLabel.text);
}

@end
