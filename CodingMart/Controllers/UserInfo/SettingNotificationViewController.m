//
//  SettingNotificationViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "SettingNotificationViewController.h"

@implementation SettingNotificationViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"推送消息设置";
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
@end
