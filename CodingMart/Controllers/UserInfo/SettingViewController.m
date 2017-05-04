//
//  SettingViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingViewController.h"
#import "Login.h"
#import "UIImageView+WebCache.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheL;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshUI];
}

- (void)refreshUI{
    _cacheL.text = [self p_diskCacheSizeStr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 20: 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 50.f;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cellHeight = 0;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        __weak typeof(self) weakSelf = self;
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"缓存数据有助于再次浏览或离线查看，你确定要清除缓存吗？" buttonTitles:nil destructiveTitle:@"确定清除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [weakSelf clearDiskCache];
            }
        }] showInView:self.view];
    }else if (indexPath.section == 2) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要退出当前账号" buttonTitles:nil destructiveTitle:@"确定退出" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [MobClick event:kUmeng_Event_UserAction label:@"设置_退出登录"];
                [Login doLogout];
                [UIViewController updateTabVCListWithSelectedIndex:NSIntegerMax];
            }
        }] showInView:self.view];
    }
}


- (void)clearDiskCache{
    [NSObject showHUDQueryStr:@"正在清除缓存..."];
    [NSObject deleteResponseCache];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [NSObject hideHUDQuery];
        [NSObject showHudTipStr:@"清除缓存成功"];
        [self refreshUI];
    }];
}

- (NSString *)p_diskCacheSizeStr{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    size += [NSObject getResponseCacheSize];
    return [NSString stringWithFormat:@"%.2f M", size/ 1024.0/ 1024.0];
}


@end
