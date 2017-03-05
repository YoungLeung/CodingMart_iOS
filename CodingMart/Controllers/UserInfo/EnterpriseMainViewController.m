//
// Created by chao chen on 2017/3/3.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import "EnterpriseMainViewController.h"
#import "FillUserInfoViewController.h"
#import "Coding_NetAPIManager.h"
#import "EnterpriseCertificate.h"

@interface EnterpriseMainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *baseInfoCheck;
@property (weak, nonatomic) IBOutlet UIImageView *enterpriseInfoCheck;
@end

@implementation EnterpriseMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WEAKSELF
    [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id data, NSError *error) {
        FillUserInfo *info = [FillUserInfo infoCached];


//        weakSelf.baseInfoCheck = [UIImage imageNamed:info.fullInfo.boolValue? @"fill_checked": @"fill_unchecked"];
//        weakSelf.baseInfoCheck = info.
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FillUserInfoViewController *vc = [FillUserInfoViewController vcInStoryboard:@"UserInfo"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            [[Coding_NetAPIManager sharedManager] get_EnterpriseAuthentication:^(id data, NSError *error) {
                if (data == nil) {
                    
                } else {

                }
                
            }];
        }
    }
}


@end
