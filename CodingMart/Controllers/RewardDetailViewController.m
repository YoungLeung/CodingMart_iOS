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
#import "MartShareView.h"
#import "FunctionTipsManager.h"

@interface RewardDetailViewController ()
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) RewardDetail *rewardDetal;
@property (strong, nonatomic) UIView *bottomV;
@property (strong, nonatomic) UILabel *topTipL;
@property (strong, nonatomic) UIButton *rightNavBtn;

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
//    if (_curReward.title.length > 0) {
//        self.titleStr = _curReward.title;
//    }
}

- (void)setRewardDetal:(RewardDetail *)rewardDetal{
    _rewardDetal = rewardDetal;
//    self.titleStr = _rewardDetal.reward.title;
}

- (void)viewDidLoad{
    self.titleStr = @"悬赏详情";
    [super viewDidLoad];
    if (!_rightNavBtn) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_rightNavBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_more"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
    }
    if ([FunctionTipsManager needToTip:kFunctionTipStr_ShareR]) {
        [_rightNavBtn addBadgeTip:kBadgeTipStr withCenterPosition:CGPointMake(25, 0)];
    }
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
                _topTipL.text = (!loginUser.fullInfo.boolValue || !loginUser.fullSkills.boolValue)? @"未完善个人资料不能参与悬赏，去完善 >>": @"您的账号还未激活，请前往 Coding 网站激活";
            }else{
                [_topTipL removeFromSuperview];
            }
        }
        //底部 按钮 + 状态
        contentInset.bottom = 50;
        if (!_bottomV) {
            _bottomV = [UIView new];
            _bottomV.backgroundColor = self.view.backgroundColor;
            [_bottomV addLineUp:YES andDown:NO andColor:[UIColor colorWithHexString:@"0xDDDDDD"]];
            [self.view addSubview:_bottomV];
            [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(50);
            }];
        }
        [[_bottomV subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]] || [obj isKindOfClass:[UILabel class]]) {
                [obj removeFromSuperview];
            }
        }];
        UIButton *bottomBtn = [self p_bottomBtnWithStatus:_rewardDetal.joinStatus];
        if (bottomBtn) {
            [_bottomV addSubview:bottomBtn];
            CGFloat btnLeftInset = _rewardDetal.joinStatus.integerValue == JoinStatusNotJoin? 15: (CGRectGetWidth(self.view.frame) - 15 - 110);//110
            [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(8, btnLeftInset, 8, 15));
            }];
        }
        UILabel *bottomL = [self p_bottomLWithStatus:_rewardDetal.joinStatus];
        if (bottomL) {
            [_bottomV addSubview:bottomL];
            [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(8, 15, 8, 140));
            }];
        }
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
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:colorHexStr];
    return button;
}

- (UIButton *)p_bottomBtnWithStatus:(NSNumber *)joinStatus{
    UIButton *bottomBtn = nil;
    switch (joinStatus.integerValue) {
        case JoinStatusFresh:
            bottomBtn = [self p_bottomBtnWithTitle:@"编辑" bgColorHexStr:@"0x3BBD79"];
            break;
        case JoinStatusChecked:
        case JoinStatusSucessed:
            break;
        case JoinStatusFailed:
            bottomBtn = [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x3BBD79"];
            break;
        case JoinStatusCanceled:
            bottomBtn = [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x3BBD79"];
            break;
        default:
            bottomBtn = [self p_bottomBtnWithTitle:@"参与悬赏" bgColorHexStr:@"0x3BBD79"];
            break;
    }
    return bottomBtn;
}

- (UILabel *)p_bottomLWithStatus:(NSNumber *)joinStatus{
    if (joinStatus.integerValue == JoinStatusNotJoin) {
        return nil;
    }
    UILabel *bottomL = [UILabel new];
    NSString *valueStr, *colorHexStr;
    switch (joinStatus.integerValue) {
        case JoinStatusFresh:
            valueStr = @"待审核";
            colorHexStr = @"0x727F8D";
            break;
        case JoinStatusChecked:
            valueStr = @"已审核";
            colorHexStr = @"0xF5A623";
            break;
        case JoinStatusSucessed:
            valueStr = @"已通过";
            colorHexStr = @"0x2FAEEA";
            break;
        case JoinStatusFailed:
            valueStr = @"已拒绝";
            colorHexStr = @"0xE84D60";
            break;
        case JoinStatusCanceled:
            valueStr = @"已取消";
            colorHexStr = @"0x99999";
            break;
        default:
            break;
    }
    NSString *titleStr =@"审核状态：";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", titleStr, valueStr]];
    [attrString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0x666666"]}
                        range:NSMakeRange(0, titleStr.length)];
    [attrString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:colorHexStr]}
                        range:NSMakeRange(titleStr.length, valueStr.length)];
    bottomL.attributedText = attrString;
    return bottomL;
}

- (void)bottomBtnClicked:(UIButton *)sender{
    if ([Login isLogin]) {
        User *loginUser = [Login curLoginUser];
        if (!loginUser.fullInfo.boolValue || !loginUser.fullSkills.boolValue) {//未完善个人资料
            FillTypesViewController *vc = [FillTypesViewController storyboardVC];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (!loginUser.status.boolValue){//未激活
//            [self goToWebVCWithUrlStr:@"https://coding.net/login?phone=phone" title:@"激活账号"];
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
            [weakSelf bottomBtnClicked:nil];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
    NSLog(@"bottomBtnClicked : %@", sender.titleLabel.text);
}

- (void)navBtnClicked:(id)sender{
    NSObject *shareObj = _rewardDetal.reward? _rewardDetal.reward: _curReward? _curReward: nil;
    if (shareObj) {
        if ([FunctionTipsManager needToTip:kFunctionTipStr_ShareR]) {
            [FunctionTipsManager markTiped:kFunctionTipStr_ShareR];
            [_rightNavBtn removeBadgeTips];
        }
        [MartShareView showShareViewWithObj:shareObj];
    }
}

@end
