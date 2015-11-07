//
//  FillUserInfoViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillUserInfoViewController.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LocationViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface FillUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_code_separatorLC;
@property (weak, nonatomic) IBOutlet UITextField *qqNumF;
@property (weak, nonatomic) IBOutlet UITextField *locationF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneVerifiedL;
@property (weak, nonatomic) IBOutlet UIView *codeLineV;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;

@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;

@property (strong, nonatomic) FillUserInfo *userInfo, *originalUserInfo;
@end


@implementation FillUserInfoViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"个人信息";
    _phone_code_separatorLC.constant = 0.5;
    [self p_setupEvents];
    [self refresh];
}

- (void)p_setupEvents{
    __weak typeof(self) weakSelf = self;
    [_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.userInfo.name = newText;
    }];
    [_emailF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.userInfo.email = newText;
    }];
    [_phoneF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.userInfo.mobile = newText;
        if (newText.length > 0) {
            BOOL isVerified = [newText isEqualToString:weakSelf.originalUserInfo.mobile];//已验证
            weakSelf.phoneVerifiedL.hidden = !isVerified;
            weakSelf.codeBtn.hidden = isVerified;
            weakSelf.codeF.hidden = isVerified;
            weakSelf.codeLineV.hidden = isVerified;
        }else{//电话号码空白
            weakSelf.phoneVerifiedL.hidden =
            weakSelf.codeBtn.hidden =
            weakSelf.codeF.hidden =
            weakSelf.codeLineV.hidden = YES;
        }
    }];
    [_codeF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.userInfo.code = newText;
    }];
    [_qqNumF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.userInfo.qq= newText;
    }];
    RAC(self, submitBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, userInfo.name),
                                                              RACObserve(self, userInfo.email),
                                                              RACObserve(self, userInfo.mobile),
                                                              RACObserve(self, userInfo.qq),
                                                              RACObserve(self, userInfo.province),
                                                              RACObserve(self, userInfo.city),
                                                              RACObserve(self, userInfo.district),
                                                              RACObserve(self, userInfo.code),
                                                              ] reduce:^id{
                                                                  BOOL canPost = NO;
                                                                  if ([weakSelf.userInfo canPost:weakSelf.originalUserInfo]) {
                                                                      if ([weakSelf.userInfo.mobile isEqualToString:weakSelf.originalUserInfo.mobile]) {
                                                                          canPost = YES;
                                                                      }else{
                                                                          canPost = weakSelf.userInfo.code.length > 0;
                                                                      }
                                                                  }
                                                                  return @(canPost);
                                                              }];
}

- (void)refresh{
    self.userInfo = nil;
    [self.view beginLoading];
    [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id data, NSError *error) {
        [self.view endLoading];
        self.userInfo = data[@"data"][@"info"]? [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"][@"info"]]: [FillUserInfo new];
        self.originalUserInfo = data[@"data"][@"info"]? [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"][@"info"]]: [FillUserInfo new];
    }];
}

- (void)setUserInfo:(FillUserInfo *)userInfo{
    _userInfo = userInfo;
    
    _nameF.text = _userInfo.name;
    _emailF.text = _userInfo.email;
    _phoneF.text = _userInfo.mobile;
    _phoneVerifiedL.hidden = (_userInfo.mobile.length == 0);
    _qqNumF.text = _userInfo.qq;
    if (_userInfo.district_name.length > 0) {
        _locationF.text = [NSString stringWithFormat:@"%@ - %@ - %@", _userInfo.province_name, _userInfo.city_name, _userInfo.district_name];
    }else if (_userInfo.city_name.length > 0){
        _locationF.text = [NSString stringWithFormat:@"%@ - %@", _userInfo.province_name, _userInfo.city_name];
    }else{
        _locationF.text = @"";
    }
    
    _submitBtn.hidden = (_userInfo == nil);
    [self.tableView reloadData];
}

#pragma mark Navigation
- (BOOL)navigationShouldPopOnBackButton{
    [self.view endEditing:YES];
    if ([_userInfo isSameTo:_originalUserInfo]) {
        return YES;
    }else{
        __weak typeof(self) weakSelf = self;
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"返回后，修改的数据将不会被保存" buttonTitles:@[@"确定返回"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }] showInView:self.view];
        return NO;
    }
}

#pragma mark Btn
- (void)p_setButton:(UIButton *)button toEnabled:(BOOL)enabled{
    UIColor *foreColor = [UIColor colorWithHexString:enabled? @"0x2FAEEA": @"0xCCCCCC"];
    button.backgroundColor = foreColor;
    button.enabled = enabled;
    if (enabled) {
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
    }else if ([button.titleLabel.text isEqualToString:@"发送验证码"]){
        [button setTitle:@"正在发送..." forState:UIControlStateNormal];
    }
}

- (IBAction)codeBtnClicked:(id)sender {
    [self p_setButton:_codeBtn toEnabled:NO];
    [[Coding_NetAPIManager sharedManager] post_LoginVerifyCodeWithMobile:_userInfo.mobile block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self startUpTimer];
        }else{
            [self p_setButton:self.codeBtn toEnabled:YES];
        }
    }];
}

- (IBAction)submitBtnClicked:(id)sender {
    if ([_userInfo.mobile isEqualToString:_originalUserInfo.mobile]) {
        _userInfo.code = nil;
    }
    [NSObject showHUDQueryStr:@"正在保存个人信息..."];
    [[Coding_NetAPIManager sharedManager] post_FillUserInfo:_userInfo block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"个人信息保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark verify_codeBtn Timer
- (void)startUpTimer{
    _durationToValidity = 60;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    [self p_setButton:self.codeBtn toEnabled:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    [self p_setButton:_codeBtn toEnabled:YES];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        _codeBtn.titleLabel.text = [NSString stringWithFormat:@"%.0f 秒", _durationToValidity];//防止 button_title 闪烁
        [_codeBtn setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _userInfo? 1: 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
}

#pragma mark Sugue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    LocationViewController *vc = segue.destinationViewController;
    NSMutableArray *curSelectedList = @[].mutableCopy;
    if (_userInfo.province) {
        curSelectedList[0] = _userInfo.province;
        if (_userInfo.city) {
            curSelectedList[1] = _userInfo.city;
            if (_userInfo.district) {
                curSelectedList[2] = _userInfo.district;
            }
        }
    }
    vc.originalSelectedList = curSelectedList;
    __weak typeof(self) weakSelf = self;
    vc.complateBlock = ^(NSArray *selectedList){
        [weakSelf locationsSelected:selectedList];
    };
}
- (void)locationsSelected:(NSArray *)selectedList{
    if (selectedList.count >= 3) {
        _userInfo.province = selectedList[0][@"id"];
        _userInfo.province_name = selectedList[0][@"name"];
        _userInfo.city = selectedList[1][@"id"];
        _userInfo.city_name = selectedList[1][@"name"];
        _userInfo.district = selectedList[2][@"id"];
        _userInfo.district_name = selectedList[2][@"name"];
        
        _locationF.text = [NSString stringWithFormat:@"%@ - %@ - %@", _userInfo.province_name, _userInfo.city_name, _userInfo.district_name];
    }else{
        _userInfo.province = selectedList[0][@"id"];
        _userInfo.province_name = selectedList[0][@"name"];
        _userInfo.city = selectedList[1][@"id"];
        _userInfo.city_name = selectedList[1][@"name"];
        
        _locationF.text = [NSString stringWithFormat:@"%@ - %@", _userInfo.province_name, _userInfo.city_name];
    }
}
@end
