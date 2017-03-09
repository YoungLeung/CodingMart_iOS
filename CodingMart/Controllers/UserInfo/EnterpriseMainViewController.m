//
// Created by chao chen on 2017/3/3.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import "EnterpriseMainViewController.h"
#import "FillUserInfoViewController.h"
#import "Coding_NetAPIManager.h"
#import "EnterpriseCertificate.h"
#import "IdentityViewController.h"
#import "IdentityResultViewController.h"

@interface EnterpriseMainViewController ()
@property(weak, nonatomic) IBOutlet UIImageView *baseInfoCheck;
@property(weak, nonatomic) IBOutlet UIImageView *enterpriseInfoCheck;
@end

@implementation EnterpriseMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bindUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id data, NSError *error) {
        [weakSelf bindUI];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FillUserInfoViewController *vc = [FillUserInfoViewController vcInStoryboard:@"UserInfo"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            NSNumber *baseInfo = [FillUserInfo dataCached][@"info_complete"];
            if (!baseInfo.boolValue) {
                [NSObject showHudTipStr:@"请先完善账户信息！"];
                return;
            }

            [[Coding_NetAPIManager sharedManager] get_EnterpriseAuthentication:^(id data, NSError *error) {
                UIViewController *vc;
                if (data) {
                    EnterpriseCertificate *certificate = (EnterpriseCertificate *) data;
                    vc = [IdentityResultViewController vcInStoryboard:certificate];
                } else {
                    vc = [IdentityViewController vcWithIdetityDict:nil];
                }
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60];
}

- (void)bindUI {
    NSDictionary *info = [FillUserInfo dataCached];
    NSNumber *baseInfo = info[@"info_complete"];
    NSNumber *ceritificate = info[@"enterpriseCertificate"];
    _baseInfoCheck.image = [UIImage imageNamed:baseInfo.boolValue? @"fill_checked": @"fill_unchecked"];
    _enterpriseInfoCheck.image = [UIImage imageNamed:ceritificate.boolValue? @"fill_checked": @"fill_unchecked"];

}


@end
