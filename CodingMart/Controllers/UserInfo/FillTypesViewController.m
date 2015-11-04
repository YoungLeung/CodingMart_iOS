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

@interface FillTypesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userinfoCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *skillsCheckV;

@end

@implementation FillTypesViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillTypesViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"完善资料";
    [self refresh];
}

- (void)refresh{
    [NSObject showHUDQueryStr:nil];
    [[Coding_NetAPIManager sharedManager] get_VerifyInfoBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            self.info = data;
        }
    }];
}

- (void)setInfo:(VerifiedInfo *)info{
    _info = info;
    
    _userinfoCheckV.image = [UIImage imageNamed:_info.userinfo.boolValue? @"fill_checked": @"fill_unchecked"];
    _skillsCheckV.image = [UIImage imageNamed:_info.skills.boolValue? @"fill_checked": @"fill_unchecked"];
}

#pragma mark Table M
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
@end
