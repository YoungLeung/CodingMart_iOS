//
//  SettingNotificationViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "SettingNotificationViewController.h"
#import "SettingNotificationInfo.h"
#import "Coding_NetAPIManager.h"

@interface SettingNotificationViewController ()
@property (strong, nonatomic) SettingNotificationInfo *settingInfo;

@property (weak, nonatomic) IBOutlet UISwitch *myJoinedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *myPublishedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *freshPublishedSwitch;

@end

@implementation SettingNotificationViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"推送消息设置";
    [[Coding_NetAPIManager sharedManager] get_SettingNotificationInfoWithBlock:^(id data, NSError *error) {
        self.settingInfo = data? data: [SettingNotificationInfo defaultInfo];
    }];
}

- (void)setSettingInfo:(SettingNotificationInfo *)settingInfo{
    _settingInfo = settingInfo;
    
    _myJoinedSwitch.on = settingInfo.myJoined.boolValue;
    _myPublishedSwitch.on = settingInfo.myPublished.boolValue;
    _freshPublishedSwitch.on = settingInfo.freshPublished.boolValue;
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (sender == _myJoinedSwitch) {
        params[@"myJoined"] = @(!_settingInfo.myJoined.boolValue);
    }else if (sender == _myPublishedSwitch){
        params[@"myPublished"] = @(!_settingInfo.myPublished.boolValue);
    }else if (sender == _freshPublishedSwitch){
        params[@"freshPublished"] = @(!_settingInfo.freshPublished.boolValue);
    }
    [[Coding_NetAPIManager sharedManager] post_SettingNotificationParams:params andBlock:^(id data, NSError *error) {
        NSString *key = params.allKeys.firstObject;
        NSNumber *value = params[key];
        if (!error) {
            [self.settingInfo setValue:value forKeyPath:key];
        }else{
            [sender setOn:!value.boolValue animated:YES];
        }
    }];
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
@end
