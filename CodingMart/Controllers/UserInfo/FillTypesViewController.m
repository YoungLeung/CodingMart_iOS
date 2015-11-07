//
//  FillTypesViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillTypesViewController.h"
#import "FillUserInfoViewController.h"
#import "FillSkillsViewController.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"

@interface FillTypesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userinfoCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *skillsCheckV;
@property (strong, nonatomic) User *curUser;
@end

@implementation FillTypesViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillTypesViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"完善资料";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_curUser) {
        self.curUser = [Login curLoginUser];
    }else{
        [self refresh];
    }

}

- (void)refresh{
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        if (data) {
            self.curUser = data;
        }
    }];
}

- (void)setCurUser:(User *)curUser{
    _curUser = curUser;
    _userinfoCheckV.image = [UIImage imageNamed:_curUser.fullInfo.boolValue? @"fill_checked": @"fill_unchecked"];
    _skillsCheckV.image = [UIImage imageNamed:_curUser.fullSkills.boolValue? @"fill_checked": @"fill_unchecked"];
}

#pragma mark Table M

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if (!self.curUser.fullInfo.boolValue) {
            [NSObject showHudTipStr:@"请先完善个人信息"];
            return;
        }
        FillSkillsViewController *vc = [FillSkillsViewController storyboardVC];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
