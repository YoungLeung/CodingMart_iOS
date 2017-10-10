//
//  PublishRewardViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PublishRewardViewController.h"
#import "UIPlaceHolderTextView.h"
#import "UITTTAttributedLabel.h"
#import "TableViewFooterButton.h"

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ActionSheetStringPicker.h"
#import "PhoneCodeButton.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"
#import "LoginViewController.h"
#import "PublishedRewardsViewController.h"
#import "CountryCodeListViewController.h"
#import "EATipView.h"
#import "LoginViewController.h"
#import "ProjectIndustryListViewController.h"
#import "RootQuoteViewController.h"
#include "MartWebViewController.h"
#include "UIViewController+Common.h"
#import "EnterpriseMainViewController.h"
#import "MPayRewardOrderPayViewController.h"
#import "CodingSetting.h"
#import "Login.h"
#import "User.h"

@interface PublishRewardViewController ()
@property (strong, nonatomic) Reward *rewardToBePublished;
@property (strong, nonatomic) NSArray *typeList;

@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *topWarnL;
@property (weak, nonatomic) IBOutlet UIView *topV;

@property (weak, nonatomic) IBOutlet UITextField *typeL;
@property (weak, nonatomic) IBOutlet UITextField *budgetF;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *industryNameL;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *contact_nameF;
@property (weak, nonatomic) IBOutlet UITextField *contact_emailF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobileF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobile_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *agreementL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *budgetTipL;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;

@property (weak, nonatomic) IBOutlet UIImageView *developer_type_team_checkV;
@property (weak, nonatomic) IBOutlet UIImageView *developer_type_personal_checkV;
@property (weak, nonatomic) IBOutlet UIButton *developer_roleB;
@property (weak, nonatomic) IBOutlet UILabel *developer_roleL;
@property (weak, nonatomic) IBOutlet UIImageView *bargain_checkV;
@property (weak, nonatomic) IBOutlet UITextField *durationF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *rewardDemandTextView;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *payTipL;
@property (weak, nonatomic) IBOutlet UILabel *promoteL;
@property (weak, nonatomic) IBOutlet UIView *promoteV;


@property (assign, nonatomic) BOOL isPhoneNeeded, isRewardNew, isAgreeTIAOKUAN;

@property (strong, nonatomic) NSArray<RewardRoleType *> *roleTypes;
@property (strong, nonatomic) CodingSetting *setting;
@end

@implementation PublishRewardViewController

+ (instancetype)storyboardVCWithReward:(Reward *)rewardToBePublished{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PublishReward" bundle:nil];
    PublishRewardViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishRewardViewController"];
    vc.rewardToBePublished = rewardToBePublished;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _typeList = @[@"Web 网站",
                  @"APP 开发",
                  @"微信公众号",
                  @"HTML5 应用",
                  @"小程序",
                  @"其他"];
    
    if (!_rewardToBePublished) {
        _rewardToBePublished = [Reward rewardToBePublished];
        _isRewardNew = YES;
    }
    _isPhoneNeeded = [Login isLogin];
    _isAgreeTIAOKUAN = YES;
    [self bindHeaderUI];
    self.tableView.tableFooterView.hidden = YES;
    [self refresh];
}

- (void)refresh{
    [self.view beginLoading];
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_SettingBlock:^(CodingSetting *data, NSError *error) {
        [weakSelf.view endLoading];
        if (!error) {
            [self.view removeBlankPageView];
            weakSelf.setting = data;
        }else{
            [self.view configBlankPageErrorBlock:^(id sender) {
                [weakSelf refresh];
            }];
        }
    }];
}

- (void)setSetting:(CodingSetting *)setting{
    _setting = setting;
    self.tableView.tableFooterView.hidden = (_setting == nil);
    [self.tableView reloadData];
    if (_setting) {
        [self setupRAC];
    }
}

- (void)bindHeaderUI{
    _topV.hidden = YES;
    [self setTopVHeigh:0];

    if ([Login isLogin]) {
        User *user = [Login curLoginUser];
        if ([user isEnterpriseSide] && ![user isPassedEnterpriseIdentity]) {
            _topV.hidden = NO;
            [self setTopVHeigh:35];
            WEAKSELF
            [_topWarnL addLinkToStr:@"去认证" value:nil hasUnderline:NO clickedBlock:^(id value) {
                [weakSelf goToEnterpriseMain];
            }];
            return;
        }
    }
}

- (void)setTopVHeigh:(CGFloat) heigh{
    CGRect frame = _topV.frame;
    frame.size.height = heigh;
    _topV.frame = frame;
}

- (void)goToEnterpriseMain{
    UIViewController *vc = [[EnterpriseMainViewController class] vcInStoryboard:@"UserInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupRAC{
    self.fd_interactivePopDisabled = NO;
    _nameF.text = _rewardToBePublished.name;
    _budgetF.text = _rewardToBePublished.price.stringValue;
    _descriptionTextView.text = _rewardToBePublished.description_mine;
    _contact_nameF.text = _rewardToBePublished.contact_name;
    _contact_emailF.text = _rewardToBePublished.contact_email;
    _contact_mobileF.text = _rewardToBePublished.contact_mobile;
    _durationF.text = _rewardToBePublished.duration.stringValue;
    _rewardDemandTextView.text = _rewardToBePublished.rewardDemand;
    
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, rewardToBePublished.type) subscribeNext:^(NSNumber *type) {
        weakSelf.typeL.text = type? [[NSObject rewardTypeLongDict] findKeyFromStrValue:type.stringValue]: @"";
    }];
//    [RACObserve(self, rewardToBePublished.budget) subscribeNext:^(NSNumber *budget) {
//        weakSelf.budgetF.text = budget.stringValue;
//    }];
    [RACObserve(self, rewardToBePublished.industryName) subscribeNext:^(NSString *value) {
        weakSelf.industryNameL.text = value;
    }];
    [RACObserve(self, rewardToBePublished.bargain) subscribeNext:^(NSNumber *bargain) {
        weakSelf.bargain_checkV.image = [UIImage imageNamed:bargain.boolValue? @"publish_checked": @"publish_uncheck"];
    }];
    [RACObserve(self, rewardToBePublished.roleTypes) subscribeNext:^(NSArray *list) {
        RewardRoleType *roleType = list.firstObject;
        weakSelf.developer_type_team_checkV.image = [UIImage imageNamed:weakSelf.rewardToBePublished.isDeveloperTeam? @"publish_checked": @"publish_uncheck"];
        weakSelf.developer_type_personal_checkV.image = [UIImage imageNamed:weakSelf.rewardToBePublished.isDeveloperPersonal? @"publish_checked": @"publish_uncheck"];
        weakSelf.developer_roleB.hidden = !weakSelf.rewardToBePublished.isDeveloperPersonal;
        weakSelf.developer_roleL.text = weakSelf.rewardToBePublished.isDeveloperPersonal? roleType.name : @"请选择角色";
    }];

    [_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.name = newText;
    }];
    [_descriptionTextView.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.description_mine = newText;
    }];

    [_budgetF.rac_textSignal subscribeNext:^(NSString *newText){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        weakSelf.rewardToBePublished.price = [f numberFromString:newText];
    }];

    [_contact_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_name = newText;
    }];
    [_contact_emailF.rac_textSignal subscribeNext:^(NSString *newText) {
        weakSelf.rewardToBePublished.contact_email = newText;
    }];
    [_contact_mobileF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile = newText;
    }];
    [_contact_mobile_codeF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile_code = newText;
    }];
    [_durationF.rac_textSignal subscribeNext:^(NSString *newText){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        weakSelf.rewardToBePublished.duration = [f numberFromString:newText];
    }];
    [_rewardDemandTextView.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.rewardDemand = newText;
    }];

    [_agreementL addLinkToStr:@"《码市用户权责条款》" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToPublishAgreement];
    }];
    [_budgetTipL addLinkToStr:@"操作文档" value:nil hasUnderline:NO clickedBlock:^(id value) {
        MartWebViewController *vc = [[MartWebViewController alloc] initWithUrlStr:@"/help/question/16"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.nextStepBtn setTitle:
     [[Login curLoginUser] isEnterpriseSide]? @"发布":
     _rewardToBePublished.need_pay_prepayment.boolValue?
     _setting.project_publish_payment.floatValue > .1? @"付款并发布": @"发布"
                              :@"提交" forState:UIControlStateNormal];
    _priceL.text = [NSString stringWithFormat:@"￥%.1f", _setting.project_publish_payment.floatValue];
    _promoteL.text = _setting.project_publish_payment_color;
    _promoteV.hidden = _promoteL.text.length == 0;
    if (_setting.project_publish_payment_deadline) {
        NSString *tipStr = [NSString stringWithFormat:@"%@%@", _setting.project_publish_payment_tip, _setting.project_publish_payment_deadline];
        [_payTipL setAttrStrWithStr:tipStr diffColorStr:_setting.project_publish_payment_deadline diffColor:[UIColor colorWithHexString:@"0xF75288"]];
    }else{
        _payTipL.text = _setting.project_publish_payment_tip;
    }
}

#pragma mark Nav_Back
- (BOOL)navigationShouldPopOnBackButton{
    if (!_isRewardNew) {
        return YES;
    }
    if (_rewardToBePublished.name.length <= 0 && _rewardToBePublished.description_mine.length <= 0) {
        return YES;
    }
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"是否需要保存草稿？" buttonTitles:@[@"保存并退出"] destructiveTitle:@"删除并退出" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index < 2) {
            if (index == 0) {
                [Reward saveDraft:weakSelf.rewardToBePublished];
            }else{
                [Reward deleteCurDraft];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }] showInView:self.view];
    return NO;
}

#pragma mark Nav
- (void)goToPublishAgreement{
//    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"publish_agreement" ofType:@"html"];
//    [self goToWebVCWithUrlStr:pathForServiceterms title:@"码市用户权责条款"];
    [self goToWebVCWithUrlStr:@"/terms.html" title:@"码市用户权责条款"];
}

#pragma mark - Button

- (IBAction)agreeButtonClicked:(UIButton *)sender {
    _isAgreeTIAOKUAN = !_isAgreeTIAOKUAN;
    for (UIView *subV in sender.subviews) {
        if ([subV isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)subV setImage:[UIImage imageNamed:_isAgreeTIAOKUAN? @"publish_checked": @"publish_uncheck"]];
        }
    }
}


- (IBAction)countryCodeBtnClicked:(id)sender {
    CountryCodeListViewController *vc = [CountryCodeListViewController storyboardVC];
    WEAKSELF;
    vc.selectedBlock = ^(NSDictionary *countryCodeDict){
        weakSelf.rewardToBePublished.country = countryCodeDict[@"iso_code"];
        weakSelf.rewardToBePublished.phoneCountryCode = [NSString stringWithFormat:@"+%@", countryCodeDict[@"country_code"]];
        weakSelf.countryCodeL.text = weakSelf.rewardToBePublished.phoneCountryCode;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)codeBtnClicked:(PhoneCodeButton *)sender {
    if (![_rewardToBePublished.contact_mobile isPhoneNo]) {
        [NSObject showHudTipStr:@"手机号码格式错误"];
    }else{
        sender.enabled = NO;
        [[Coding_NetAPIManager sharedManager] post_UserInfoVerifyCodeWithMobile:_rewardToBePublished.contact_mobile phoneCountryCode:_rewardToBePublished.phoneCountryCode block:^(id data, NSError *error) {
            if (data) {
                [NSObject showHudTipStr:@"验证码发送成功"];
                [sender startUpTimer];
            }else{
                [sender invalidateTimer];
            }
        }];
    }
}

- (IBAction)descriptionTipBtnClicked:(id)sender {
    NSString *tipStr =
@"简介\n\
本项目是理财产品的手机 APP 开发,旨在为⽤用户提供便利的⼿机端理财产品； 产品主要功能为购买、交易理财产品。\n\
\n\
功能需求\n\
适配 iPhone 4s 及以上 iPhone 设备， iOS7.0 及以上版本。功能包含： 启动引导页、账户功能、交易功能、收益计算器、银行卡绑定、消息通知与推送。\n\
\n\
APP 架构\n\
APP 主要有“热门推荐”、“理财超市”、“我的资产”、“更多”等页面：\n\
[热门推荐] - 包含消息中心、轮播广告位、产品推荐等功能；\n\
[理财超市] - 包含由分段控制切换的三个页面，三个页面为三种不同类型产品的列表， 点击进入产品详情页；\n\
[我的资产] - 包含收益展示、图标展示资产明细、交易记录、银行卡管理、取现等功能。";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:5.0];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipStr length])];

    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:[tipStr rangeOfString:@"简介"]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:[tipStr rangeOfString:@"功能需求"]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:[tipStr rangeOfString:@"APP 架构"]];

    EATipView *tipV = [EATipView instancetypeWithTitle:@"项目描述范例" attrStr:attrStr];
    [tipV showInView:kKeyWindow];
}

- (IBAction)rewardDemandTipBtnClicked:(id)sender {
    NSString *tipStr =
@"招募要求\n\
1. 有 O2O、移动商城相关产品开发经验；\n\
2. 精通 Java 或 PHP，熟悉 jQuery、 JavaScript、Maven、Redis 等技术，熟练使用  MySQL、Oracle、SQLServer 等关系型数据库，熟悉 NoSQL 数据库如 mongo、redis 等；\n\
3. 参与项目的开发成员需要提前全面了解项目和代码管理工具 Coding 的使用方法；\n\
4. 深圳地区开发者优先；\n\
5. 时间较为自由充裕，可以在工作日的工作时间进行沟通交流。";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:5.0];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipStr length])];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:[tipStr rangeOfString:@"招募要求"]];
    EATipView *tipV = [EATipView instancetypeWithTitle:@"项目描述范例" attrStr:attrStr];
    [tipV showInView:kKeyWindow];
}

- (IBAction)developer_roleBClicked:(id)sender {
    if (_roleTypes.count > 0) {
        [self p_showRoleTypePicker];
    }else{
        [NSObject showHUDQueryStr:nil];
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] get_roleTypesBlock:^(NSArray<RewardRoleType *> *list, NSError *error) {
            [NSObject hideHUDQuery];
            if (list.count > 0) {
                NSMutableArray *listWithoutTeam = list.mutableCopy;
                for (RewardRoleType *tempT in list) {
                    if (tempT.isTeam) {
                        [listWithoutTeam removeObject:tempT];
                        break;
                    }
                }
                weakSelf.roleTypes = listWithoutTeam.copy;
                [weakSelf p_showRoleTypePicker];
            }
        }];
    }
}

- (void)p_showRoleTypePicker{
    if (_roleTypes.count > 0) {
        NSArray *list = [_roleTypes valueForKey:@"name"];
        __block NSInteger curRow = 0;
        if (_rewardToBePublished.roleTypes.count > 0) {
            RewardRoleType *curT = _rewardToBePublished.roleTypes.firstObject;
            [_roleTypes enumerateObjectsUsingBlock:^(RewardRoleType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([curT.id isEqualToNumber:obj.id]) {
                    curRow = idx;
                    *stop = YES;
                }
            }];
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:@"招募角色" rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            NSNumber *selectedRow = selectedIndex.firstObject;
            weakSelf.rewardToBePublished.roleTypes = @[_roleTypes[selectedRow.integerValue]].mutableCopy;
        } cancelBlock:nil origin:self.view];
    }
}

- (IBAction)bargainBClicked:(id)sender {
    self.rewardToBePublished.bargain = @(!self.rewardToBePublished.bargain.boolValue);
}

- (IBAction)nextStepBtnClicked:(id)sender {
    if ([Login isLogin]) {
        NSString *tipStr = [self p_checkTip];
        if (!_topV.hidden) {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (tipStr){
            [NSObject showHudTipStr:tipStr];
        }else{
            [MobClick event:kUmeng_Event_UserAction label:@"发布需求_点击提交"];
            [NSObject showHUDQueryStr:@"正在发布需求..."];
            [[Coding_NetAPIManager sharedManager] post_Reward:_rewardToBePublished block:^(id data, NSError *error) {
                [NSObject hideHUDQuery];
                if (data) {
                    [self publishSucessed];
                }
            }];
        }
    }else{
        WEAKSELF;
        LoginViewController *vc = [LoginViewController storyboardVCWithUserStr:_rewardToBePublished.contact_mobile];
        vc.loginSucessBlock = ^(){
            User *curUser = [Login curLoginUser];
            weakSelf.rewardToBePublished.contact_mobile = curUser.phone;
            [weakSelf nextStepBtnClicked:nil];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
}

- (NSString *)p_checkTip{
    NSString *tipStr = nil;
    tipStr = (!_isAgreeTIAOKUAN? @"请同意遵守《码市用户权责条款》":
              !_rewardToBePublished.type? @"请选择您的项目类型":
              !_rewardToBePublished.roleTypes? @"请选择您招募的开发者类型":
              _rewardToBePublished.name.length <= 0? @"请填写项目名称":
              _rewardToBePublished.industry.length <= 0? @"请填写行业信息":
              !_rewardToBePublished.price? @"请填写项目金额":
              !_rewardToBePublished.duration? @"请填写期望交付周期":
              _rewardToBePublished.description_mine.length <= 0? @"请填写项目描述":
              _rewardToBePublished.rewardDemand.length <= 0? @"请填写招募要求":
              _rewardToBePublished.contact_name.length <= 0? @"请填写您的姓名":
              _rewardToBePublished.contact_email.length <= 0? @"请填写您的邮箱":
              (_isPhoneNeeded && _rewardToBePublished.contact_mobile.length <= 0)? @"请填写您的手机":
              (_isPhoneNeeded && _rewardToBePublished.contact_mobile_code.length <= 0)? @"请填写手机验证码":
              _rewardToBePublished.price.intValue < 1000? @"项目金额不能低于 1000":
              (_rewardToBePublished.isDeveloperPersonal && _rewardToBePublished.price.integerValue > 50000)? @"个人项目金额必须低于 50,000 元":
              (_rewardToBePublished.isDeveloperTeam && _rewardToBePublished.price.integerValue < 10000)? @"团队项目金额必须高于 10,000 元":

              nil);
    return tipStr;
}

- (void)publishSucessed{
    if (_isRewardNew) {
        [Reward deleteCurDraft];
    }
    if (![(RootTabViewController *)self.rdv_tabBarController checkUpdateTabVCListWithSelectedIndex:2]){
        if (_rewardToBePublished.need_pay_prepayment.boolValue && _setting.project_publish_payment.floatValue > .1 &&
            ![[Login curLoginUser] isEnterpriseSide]) {//跳转去支付
            [NSObject showHUDQueryStr:@"生成订单..."];
            WEAKSELF;
            [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithRewardId:_rewardToBePublished.id block:^(id data, NSError *error) {
                [NSObject hideHUDQuery];
                if (data) {
                    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
                    vc.curMPayOrder = data;
                    vc.curReward = weakSelf.rewardToBePublished;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }else{
            __block UIViewController *vc;
            [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[PublishedRewardsViewController class]]) {
                    vc = obj;
                    *stop = YES;
                }
            }];
            if (vc) {
                [self.navigationController popToViewController:vc animated:YES];
            }else{
                UINavigationController *nav = self.navigationController;
                [nav popToRootViewControllerAnimated:NO];
                PublishedRewardsViewController *publishedVC = [PublishedRewardsViewController storyboardVC];
                [nav pushViewController:publishedVC animated:YES];
            }
        }
    }
    [EATipView showAllowNotificationTipInView:kKeyWindow];
}

//- (void)changeTabVCList{
//    [NSObject showHUDQueryStr:@"正在切换视图..."];
//    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:@2 andBlock:^(id data, NSError *error) {
//        [NSObject hideHUDQuery];
//        if (data) {
//            [UIViewController updateTabVCListWithSelectedIndex:2];
//        }
//    }];
//}

#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _setting == nil? 0:
    [[Login curLoginUser] isEnterpriseSide]? 3:
    _rewardToBePublished.need_pay_prepayment.boolValue? 4: 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        UIView *headerV = [UIView new];
        UILabel *titleL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithHexString:@"0x999999"];
            label;
        });
        [headerV addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerV).offset(15);
            make.centerY.equalTo(headerV);
        }];
        titleL.text = section == 1? @"项目信息": @"联系信息";
        return headerV;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 1 || section == 2)? 44: 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum;
    if (section == 0) {
        rowNum = 3;
    }else if (section == 1){
        rowNum = 6;
    }else if (section == 2){
        rowNum = _isPhoneNeeded? 4: 2;
    }else{
        rowNum = 1;
    }
    return rowNum;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if ((indexPath.section == 0 && indexPath.row == 1) ||
        (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3)) ||
        (indexPath.section == 2 && indexPath.row != 2)) {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSArray *list = _typeList;
        NSInteger curRow = 0;
        if (_rewardToBePublished.type) {
            NSString *key = [[NSObject rewardTypeLongDict] findKeyFromStrValue:_rewardToBePublished.type.stringValue];
            curRow = [list indexOfObject:key];
            curRow = curRow != NSNotFound? curRow: 0;
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:@"项目类型" rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            NSNumber *selectedRow = selectedIndex.firstObject;
            NSString *value = [[NSObject rewardTypeLongDict] objectForKey:list[selectedRow.integerValue]];
            weakSelf.rewardToBePublished.type = @(value.integerValue);
        } cancelBlock:nil origin:self.view];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        self.rewardToBePublished.roleTypes = @[[RewardRoleType teamRoleType]].mutableCopy;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        if (!self.rewardToBePublished.isDeveloperPersonal) {
            [self developer_roleBClicked:nil];
        }
    }else if (indexPath.section == 1 && indexPath.row == 1){
        ProjectIndustryListViewController *vc = [ProjectIndustryListViewController vcInStoryboard:@"UserInfo"];
        vc.curReward = _rewardToBePublished;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
