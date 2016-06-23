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
    [[Coding_NetAPIManager sharedManager] get_SettingNotificationInfoBlock:^(id data, NSError *error) {
        self.settingInfo = data? data: [SettingNotificationInfo defaultInfo];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BOOL isAllowedNotification = [UIDevice isAllowedNotification];
    _myJoinedSwitch.enabled =
    _myPublishedSwitch.enabled =
    _freshPublishedSwitch.enabled = isAllowedNotification;
    if (!isAllowedNotification) {
        kTipAlert(@"为了显示通知，您需要在\n「设置」->「通知」->「Coding」\n中启用通知才能接收到相应的通知");
    }
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
    [[Coding_NetAPIManager sharedManager] post_SettingNotificationParams:params block:^(id data, NSError *error) {
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
@end
