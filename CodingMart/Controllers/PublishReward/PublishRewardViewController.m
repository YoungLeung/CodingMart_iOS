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

@interface PublishRewardViewController ()
@property (strong, nonatomic) Reward *rewardToBePublished;
@property (strong, nonatomic) NSArray *typeList, *budgetList;
@property (assign, nonatomic) NSNumber *agreementChecked;

@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *budgetL;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *contact_nameF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobileF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobile_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *survey_extraF;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *agreementL;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;

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
    _budgetList = @[@"1万以下",
                    @"1-3万",
                    @"3-5万",
                    @"5万以上"];
    
    if (!_rewardToBePublished) {
        _rewardToBePublished = [Reward rewardToBePublished];
    }
    [self setupRAC];
    self.agreementChecked = @YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Login isLogin]) {
        [self.view removeBlankPageView];
    }else{
        [self.view configBlankPageImage:kBlankPageImageFail tipStr:@"您的网络好像出现了问题" buttonTitle:@"刷新一下" buttonBlock:nil];
    }
    self.tableView.scrollEnabled = [Login isLogin];
}

- (void)setupRAC{
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, rewardToBePublished.type) subscribeNext:^(NSNumber *type) {
            weakSelf.typeL.textColor = [UIColor colorWithHexString:type? @"0x000000": @"0xCCCCCC"];
            weakSelf.typeL.text = type? [[NSObject rewardTypeLongDict] findKeyFromStrValue:type.stringValue]: @"请选择";
    }];
    [RACObserve(self, rewardToBePublished.budget) subscribeNext:^(NSNumber *budget) {
        weakSelf.budgetL.textColor = [UIColor colorWithHexString:budget? @"0x000000": @"0xCCCCCC"];
        weakSelf.budgetL.text = budget? weakSelf.budgetList[budget.integerValue]: @"请选择";
    }];
    
    _nameF.text = _rewardToBePublished.name;
    _descriptionTextView.text = _rewardToBePublished.description_mine;
    _contact_nameF.text = _rewardToBePublished.contact_name;
    _contact_mobileF.text = _rewardToBePublished.contact_mobile;
    _survey_extraF.text = _rewardToBePublished.survey_extra;
    
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
    [_contact_mobileF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile = newText;
    }];
    [_contact_mobile_codeF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile_code = newText;
    }];

    [_survey_extraF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.survey_extra = newText;
    }];
    [RACObserve(self, agreementChecked) subscribeNext:^(NSNumber *agreementChecked) {
        [weakSelf.checkBtn setImage:[UIImage imageNamed:(agreementChecked.boolValue? @"checkbox_checked": @"checkbox_check")] forState:UIControlStateNormal];
    }];
    [_agreementL addLinkToStr:@"《码市用户权责条款议》" value:nil hasUnderline:YES clickedBlock:^(id value) {
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
                                                                RACObserve(self, rewardToBePublished.contact_mobile),
                                                                RACObserve(self, rewardToBePublished.contact_mobile_code),
                                                                RACObserve(self, agreementChecked)]
                                                       reduce:^id(NSNumber *type,
                                                                  NSNumber *budget,
                                                                  NSString *name,
                                                                  NSString *description_mine,
                                                                  NSString *contact_name,
                                                                  NSString *contact_mobile,
                                                                  NSString *contact_mobile_code,
                                                                  NSNumber *agreementChecked){
                                                           return @(type && budget && name.length > 0 && description_mine.length > 0 && contact_name.length > 0 && contact_mobile.length > 0 && contact_mobile_code.length > 0 && agreementChecked.boolValue);
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
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"码市用户权责条款议"];
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

- (IBAction)checkBtnClicked:(id)sender {
    self.agreementChecked = @(!self.agreementChecked.boolValue);
}

- (IBAction)nextStepBtnClicked:(id)sender {
    if ([Login isLogin]) {
        NSString *typeStr = [[NSObject rewardTypeLongDict] findKeyFromStrValue:_rewardToBePublished.type.stringValue];
        NSString *budgetStr = _budgetList[_rewardToBePublished.budget.integerValue];
        [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"发布悬赏_%@_%@_点击提交", typeStr, budgetStr]];
        
        [NSObject showHUDQueryStr:@"正在发布悬赏..."];
        [[Coding_NetAPIManager sharedManager] post_Reward:_rewardToBePublished block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [self publishSucessed];
            }
        }];
    }else{
        LoginViewController *vc = [LoginViewController storyboardVCWithUser:_rewardToBePublished.contact_mobile];
        vc.loginSucessBlock = ^(){
            [self nextStepBtnClicked:nil];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
}

- (void)publishSucessed{    
    if (![_rewardToBePublished.id isKindOfClass:[NSNumber class]]) {
        [Reward deleteCurDraft];
    }
    
    if (self.navigationController.viewControllers.firstObject == self) {
        [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
            [UIViewController updateTabVCListWithSelectedIndex:2];
        }];
        return;
    }
    
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

#pragma mark Table
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 0: 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, (indexPath.section == 0 && indexPath.row ==0)? 15: kScreen_Width, 0, 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *list;
        NSInteger curRow;
        if (indexPath.row == 0) {
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
            curRow = _rewardToBePublished.budget? _rewardToBePublished.budget.integerValue: 0;
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            NSNumber *selectedRow = selectedIndex.firstObject;
            if (indexPath.row == 0) {
                NSString *value = [[NSObject rewardTypeLongDict] objectForKey:list[selectedRow.integerValue]];
                weakSelf.rewardToBePublished.type = @(value.integerValue);
            }else{
                weakSelf.rewardToBePublished.budget = selectedRow;
            }
        } cancelBlock:nil origin:self.view];
    }
}

@end
