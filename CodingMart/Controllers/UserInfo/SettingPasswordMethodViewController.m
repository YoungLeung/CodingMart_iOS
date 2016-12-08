//
//  SettingPasswordMethodViewController.m
//  CodingMart
//
//  Created by Ease on 2016/12/8.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingPasswordMethodViewController.h"
#import "CannotLoginViewController.h"

@interface SettingPasswordMethodViewController ()

@end

@implementation SettingPasswordMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置账号密码";
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
#pragma mark Table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        CannotLoginViewController *vc = [CannotLoginViewController vcInStoryboard:@"Login"];
        vc.userStr = _codingUser.email ?: _codingUser.email;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
