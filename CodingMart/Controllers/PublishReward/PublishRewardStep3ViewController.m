//
//  PublishRewardStep3ViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishRewardStep3ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TableViewFooterButton.h"
#import "LoginViewController.h"
#import "Login.h"
#import "Coding_NetAPIManager.h"
#import "PublishedRewardsViewController.h"
#import "UserInfoViewController.h"

@interface PublishRewardStep3ViewController ()
@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;

@property (weak, nonatomic) IBOutlet UITextField *contact_nameF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobileF;
@property (weak, nonatomic) IBOutlet UITextField *contact_emailF;


@end

@implementation PublishRewardStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布悬赏";
    UIView *tableHeaderView = self.tableView.tableHeaderView;
    tableHeaderView.height = 0.35 * kScreen_Width;
    self.tableView.tableHeaderView = tableHeaderView;
    
    [self p_setupTextEvents];
    RAC(self.nextStepBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, rewardToBePublished.contact_name),
                                                                RACObserve(self, rewardToBePublished.contact_mobile),
                                                                RACObserve(self, rewardToBePublished.contact_email)
                                                                ] reduce:^id(NSString *contact_name, NSString *contact_mobile, NSString *contact_email){
                                                                    BOOL enabled = YES;
                                                                    enabled = (contact_name.length > 0 && contact_mobile.length > 0 && contact_email.length > 0);
                                                                    return @(enabled);
                                                                }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark Text M
- (void)p_setupTextEvents{
    _contact_nameF.text = _rewardToBePublished.contact_name;
    _contact_mobileF.text = _rewardToBePublished.contact_mobile;
    _contact_emailF.text = _rewardToBePublished.contact_email;
    
    __weak typeof(self) weakSelf = self;
    [_contact_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_name = newText;
    }];
    [_contact_mobileF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile = newText;
    }];
    [_contact_emailF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_email = newText;
    }];
}
#pragma mark Btn
- (IBAction)nextStepBtnClicked:(id)sender {
    if ([Login isLogin]) {
        [NSObject showHUDQueryStr:@"正在发布悬赏..."];
        [[Coding_NetAPIManager sharedManager] post_Reward:_rewardToBePublished block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [self publishSucessed];
            }
        }];
    }else{
        LoginViewController *vc = [LoginViewController storyboardVCWithType:LoginViewControllerTypeLoginAndRegister mobile:_rewardToBePublished.contact_mobile];
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
        UserInfoViewController *userVC = [UserInfoViewController storyboardVC];
        PublishedRewardsViewController *publishedVC = [PublishedRewardsViewController storyboardVC];
        [nav pushViewController:userVC animated:NO];
        [nav pushViewController:publishedVC animated:YES];
        
//        kTipAlert(@"悬赏发布成功！\n可以去到「个人中心」-「我发布的悬赏」中查找");
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
