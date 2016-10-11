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
#import "QuickLoginViewController.h"

@interface PublishRewardViewController ()
@property (strong, nonatomic) Reward *rewardToBePublished;
@property (strong, nonatomic) NSArray *typeList, *budgetList;

@property (weak, nonatomic) IBOutlet UITextField *typeL;
@property (weak, nonatomic) IBOutlet UITextField *budgetL;
@property (weak, nonatomic) IBOutlet UITextField *nameF;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *contact_nameF;
@property (weak, nonatomic) IBOutlet UITextField *contact_emailF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobileF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobile_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *agreementL;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;

@property (assign, nonatomic) BOOL isPhoneNeeded;

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
                  @"移动应用 App",
                  @"微信开发",
                  @"HTML5 应用",
                  @"咨询",
                  @"其他"];
    _budgetList = @[@"2万以下",
                    @"2-5万",
                    @"5-10万",
                    @"10万以上"];
    
    if (!_rewardToBePublished) {
        _rewardToBePublished = [Reward rewardToBePublished];
    }
    _isPhoneNeeded = [Login isLogin];
    [self setupRAC];
}

- (void)setupRAC{
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, rewardToBePublished.type) subscribeNext:^(NSNumber *type) {
            weakSelf.typeL.textColor = [UIColor colorWithHexString:type? @"0x000000": @"0xCCCCCC"];
            weakSelf.typeL.text = type? [[NSObject rewardTypeLongDict] findKeyFromStrValue:type.stringValue]: @"请选择";
    }];
    [RACObserve(self, rewardToBePublished.budget) subscribeNext:^(NSNumber *budget) {
        weakSelf.budgetL.textColor = [UIColor colorWithHexString:budget? @"0x000000": @"0xCCCCCC"];
        weakSelf.budgetL.text = budget? weakSelf.budgetList[budget.integerValue% 10]: @"请选择";
    }];
    
    _nameF.text = _rewardToBePublished.name;
    _descriptionTextView.text = _rewardToBePublished.description_mine;
    _contact_nameF.text = _rewardToBePublished.contact_name;
    _contact_emailF.text = _rewardToBePublished.contact_email;
    _contact_mobileF.text = _rewardToBePublished.contact_mobile;
    
    [_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        self.fd_interactivePopDisabled = newText.length > 0;
        weakSelf.rewardToBePublished.name = newText;
    }];
    [_descriptionTextView.rac_textSignal subscribeNext:^(NSString *newText){
        self.fd_interactivePopDisabled = newText.length > 0;
        weakSelf.rewardToBePublished.description_mine = newText;
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

    [_agreementL addLinkToStr:@"《码市用户权责条款》" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToPublishAgreement];
    }];

    RAC(self, fd_interactivePopDisabled) = [RACSignal combineLatest:@[_nameF.rac_textSignal, _descriptionTextView.rac_textSignal] reduce:^id(NSString *name, NSString *description){
        return @(name.length > 0 || description.length > 0);
    }];
    RAC(self, nextStepBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, rewardToBePublished.type),
                                                                RACObserve(self, rewardToBePublished.budget),
                                                                RACObserve(self, rewardToBePublished.name),
                                                                RACObserve(self, rewardToBePublished.description_mine),
                                                                RACObserve(self, rewardToBePublished.contact_name),
                                                                RACObserve(self, rewardToBePublished.contact_email),
                                                                RACObserve(self, rewardToBePublished.contact_mobile),
                                                                RACObserve(self, rewardToBePublished.contact_mobile_code)]
                                                       reduce:^id(NSNumber *type,
                                                                  NSNumber *budget,
                                                                  NSString *name,
                                                                  NSString *description_mine,
                                                                  NSString *contact_name,
                                                                  NSString *contact_email,
                                                                  NSString *contact_mobile,
                                                                  NSString *contact_mobile_code){
                                                           return @(type && budget && name.length > 0 && description_mine.length > 0 && contact_name.length > 0 && contact_email.length > 0 &&
                                                                    (!_isPhoneNeeded || (contact_mobile.length > 0 && contact_mobile_code.length > 0)));
                                                       }];
}

#pragma mark Nav_Back
- (BOOL)navigationShouldPopOnBackButton{
    if ([_rewardToBePublished.id isKindOfClass:[NSNumber class]]) {
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
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"publish_agreement" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"码市用户权责条款"];
}

#pragma mark - Button

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
@"简介 \n\
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
    EATipView *tipV = [EATipView instancetypeWithTitle:@"项目描述范例" tipStr:tipStr];
    [tipV showInView:kKeyWindow];
}

- (IBAction)nextStepBtnClicked:(id)sender {
    if ([Login isLogin]) {
        NSString *typeStr = [[NSObject rewardTypeLongDict] findKeyFromStrValue:_rewardToBePublished.type.stringValue];
        NSString *budgetStr = _budgetList[_rewardToBePublished.budget.integerValue% 10];
        [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"发布需求_%@_%@_点击提交", typeStr, budgetStr]];
        [NSObject showHUDQueryStr:@"正在发布需求..."];
        [[Coding_NetAPIManager sharedManager] post_Reward:_rewardToBePublished block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [self publishSucessed];
            }
        }];
    }else{
        WEAKSELF;
        QuickLoginViewController *vc = [QuickLoginViewController storyboardVCWithPhone:_rewardToBePublished.contact_mobile];
        vc.loginSucessBlock = ^(){
            User *curUser = [Login curLoginUser];
            weakSelf.rewardToBePublished.contact_mobile = curUser.phone;
            [weakSelf nextStepBtnClicked:nil];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
}

- (void)publishSucessed{    
    if (![_rewardToBePublished.id isKindOfClass:[NSNumber class]]) {
        [Reward deleteCurDraft];
    }
    if ([Login curLoginUser].loginIdentity.integerValue != 2) {
        [self changeTabVCList];
    }else if (![(RootTabViewController *)self.rdv_tabBarController checkUpdateTabVCListWithSelectedIndex:2]){
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

- (void)changeTabVCList{
    [NSObject showHUDQueryStr:@"正在切换视图..."];
    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:@2 andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [UIViewController updateTabVCListWithSelectedIndex:2];
        }
    }];
}

#pragma mark Table
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
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
        titleL.text = @"联系信息";
        return headerV;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 15: 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum;
    if (section == 0) {
        rowNum = 4;
    }else{
        rowNum = _isPhoneNeeded? 4: 2;
    }
    return rowNum;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.row == 0 || (indexPath.section == 1 && indexPath.row == 1)) {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *list;
        NSInteger curRow;
        if (indexPath.row == 1) {
            list = _typeList;
            if (_rewardToBePublished.type) {
                NSString *key = [[NSObject rewardTypeLongDict] findKeyFromStrValue:_rewardToBePublished.type.stringValue];
                curRow = [list indexOfObject:key];
                if (curRow == NSNotFound) {
                    curRow = 1;
                }
            }else{
                curRow = 0;
            }
        }else{
            list = _budgetList;
            curRow = _rewardToBePublished.budget? _rewardToBePublished.budget.integerValue% 10: 0;
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            NSNumber *selectedRow = selectedIndex.firstObject;
            if (indexPath.row == 1) {
                NSString *value = [[NSObject rewardTypeLongDict] objectForKey:list[selectedRow.integerValue]];
                weakSelf.rewardToBePublished.type = @(value.integerValue);
            }else{
                weakSelf.rewardToBePublished.budget = @(selectedRow.integerValue + 10);
            }
        } cancelBlock:nil origin:self.view];
    }
}

@end
