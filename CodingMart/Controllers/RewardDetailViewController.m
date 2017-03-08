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
#import "RewardDetailHeaderView.h"

@interface RewardDetailViewController ()
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) RewardDetail *rewardDetal;
@property (strong, nonatomic) UIView *bottomV;
@property (strong, nonatomic) UILabel *topTipL;
@property (strong, nonatomic) UIButton *rightNavBtn;
@property (strong, nonatomic) RewardDetailHeaderView *headerV;
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
    self.curUrlStr = [NSString stringWithFormat:@"/project/%@", _curReward.id.stringValue];
}

- (void)viewDidLoad{
    self.titleStr = @"项目详情";
    [super viewDidLoad];
    if (!_rightNavBtn) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_rightNavBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_share"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
    }
    if (!_headerV) {
        _headerV = [RewardDetailHeaderView viewWithReward:_curReward];
        [self.webView.scrollView addSubview:_headerV];
        
        UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
        contentInset.top = _headerV.height;
        self.webView.scrollView.contentInset = contentInset;
        [_headerV setY:-_headerV.height];
        [self.webView.scrollView.pullRefreshCtrl setY:self.webView.scrollView.pullRefreshCtrl.y - _headerV.height];
    }
    if (![FunctionTipsManager isAppUpdate] && ![Login curLoginUser].isDemandSide) {//开发者才显示
        [MartFunctionTipView showFunctionImages:@[@"guidance_dev_reward_public"] onlyOneTime:YES];
    }
    [self handleRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshReward];
}

- (void)handleRefresh{
    [super handleRefresh];
    [self refreshReward];
}

- (void)refreshReward{
    __weak typeof(self) weakSelf = self;
    void (^queryDetailBlock)() = ^(){
        [[Coding_NetAPIManager sharedManager] get_RewardDetailWithId:_curReward.id.integerValue block:^(id data, NSError *error) {//获取详细数据
            if (data) {
                weakSelf.rewardDetal = data;
                [weakSelf refreshNativeView];
            }
        }];
    };
    if ([Login isLogin]) {
        [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data0, NSError *error0) {//更新 Login_User 的数据
            if (!error0) {
                queryDetailBlock();
            }
        }];
    }else{
        queryDetailBlock();
    }
}

- (void)refreshNativeView{
    _headerV.curReward = _rewardDetal.reward;
    UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
    if (_rewardDetal.reward.status.integerValue == 5 && ![[Login curLoginUser] isDemandSide]) {//招募中的 Reward
        //顶部提示
        if ([Login isLogin]) {
            User *loginUser = [Login curLoginUser];
            if (![loginUser canJoinReward]) {
                if (!_topTipL) {
                    _topTipL = [UILabel new];
                    _topTipL.textAlignment = NSTextAlignmentCenter;
                    _topTipL.backgroundColor = [UIColor colorWithHexString:@"0xF2DEDE"];
                    _topTipL.textColor = [UIColor colorWithHexString:@"0xC55351"];
                    _topTipL.font = [UIFont systemFontOfSize:14];
                    _topTipL.adjustsFontSizeToFitWidth = YES;
                    _topTipL.minimumScaleFactor = 0.5;
                    __weak typeof(self) weakSelf = self;
                    _topTipL.userInteractionEnabled = YES;
                    [_topTipL bk_whenTapped:^{
                        [weakSelf bottomBtnClicked:nil];
                    }];
                    [self.view addSubview:_topTipL];
                    [_topTipL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(self.view);
                        make.height.mas_equalTo(40);
                        make.top.equalTo(self.view).offset([self navBottomY]);
                    }];
                }
                _topTipL.text = ![loginUser canJoinReward]? @"您还不是认证码士，请前往完善开发者信息>>": @"您的账号还未激活，请前往 Coding 网站激活";
                [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(40, 0, 0, 0));
                }];
            }else{
                [_topTipL removeFromSuperview];
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
            }
        }
        //底部 按钮 + 状态
        contentInset.bottom = 60;
        if (!_bottomV) {
            _bottomV = [UIView new];
            _bottomV.backgroundColor = self.view.backgroundColor;
            [_bottomV addLineUp:YES andDown:NO andColor:[UIColor colorWithHexString:@"0xDDDDDD"]];
            [self.view addSubview:_bottomV];
            [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(60);
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
                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(10, btnLeftInset, 10, 15));
            }];
        }
        UILabel *bottomL = [self p_bottomLWithStatus:_rewardDetal.joinStatus];
        if (bottomL) {
            [_bottomV addSubview:bottomL];
            [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(10, 15, 10, 140));
            }];
        }
    }else{
        [_topTipL removeFromSuperview];
        [_bottomV removeFromSuperview];
        contentInset.bottom = 0;
    }
    [self.webView.scrollView changeContentInset:contentInset];
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
        case JoinStatusChecked:
            bottomBtn = [self p_bottomBtnWithTitle:@"编辑申请内容" bgColorHexStr:@"0x4289DB"];
            break;
        case JoinStatusSucessed:
            break;
        case JoinStatusFailed:
            bottomBtn = [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x4289DB"];
            break;
        case JoinStatusCanceled:
            bottomBtn = [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x4289DB"];
            break;
        default:
            bottomBtn = [self p_bottomBtnWithTitle:@"参与项目" bgColorHexStr:@"0x4289DB"];
            break;
    }
    bottomBtn.enabled = [[Login curLoginUser] canJoinReward];
    bottomBtn.alpha = bottomBtn.enabled? 1.0: 0.5;
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
            valueStr = @"审核中";
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
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"项目详情_%@", sender.titleLabel.text]];
    if ([Login isLogin]) {
        if (![[Login curLoginUser] canJoinReward]) {//未完善个人资料
            FillTypesViewController *vc = [FillTypesViewController storyboardVC];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//去提交
            if (_rewardDetal) {
                if (_rewardDetal.reward.roleTypesNotCompleted.count <= 0) {
                    [NSObject showHudTipStr:@"该项目所有角色都已招募完毕"];
                }else{
                    RewardApplyViewController *vc = [RewardApplyViewController storyboardVC];
                    vc.rewardDetail = _rewardDetal;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }else{
        __weak typeof(self) weakSelf = self;
        LoginViewController *vc = [LoginViewController storyboardVCWithUserStr:nil];
        vc.loginSucessBlock = ^(){
            [weakSelf bottomBtnClicked:nil];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
}

- (void)navBtnClicked:(id)sender{
    NSObject *shareObj = _rewardDetal.reward? _rewardDetal.reward: _curReward? _curReward: nil;
    if (shareObj) {
        [MartShareView showShareViewWithObj:shareObj];
    }
}

#pragma mark Super
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *curURLStr = request.URL.absoluteString;
    if (![curURLStr isEqual:self.request.URL.absoluteString]) {
        if (![curURLStr isEqualToString:@"about:blank"] &&
            [curURLStr rangeOfString:@"supportbox/index"].location == NSNotFound) {//http://codemart.kf5.com/supportbox/index
            UIViewController *vc = [UIViewController analyseVCFromLinkStr:request.URL.absoluteString];
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
    }
    return YES;
}

@end
