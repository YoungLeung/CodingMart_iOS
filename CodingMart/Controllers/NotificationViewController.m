//
//  NotificationViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/2.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "NotificationViewController.h"
#import "Coding_NetAPIManager.h"
#import "NotificationCell.h"
#import "MartNotification.h"

@interface NotificationViewController ()
@property (strong, nonatomic) NSArray<MartNotification *> *dataList;
@property (assign, nonatomic) BOOL onlyUnread;
@end

@implementation NotificationViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    
    [self refresh];
}

- (void)rightBarButtonItemClicked{
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[_onlyUnread? @"显示全部通知": @"仅显示未读通知", @"标记所有为已读"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            weakSelf.onlyUnread = !weakSelf.onlyUnread;
            weakSelf.dataList = nil;
            [weakSelf.tableView reloadData];
            [weakSelf refresh];
        }else{
            if (index == 1) {
                [weakSelf p_markReadAll];
            }
        }
    }] showInView:self.view];
}

- (void)refresh{
    [[Coding_NetAPIManager sharedManager] get_NotificationUnRead:_onlyUnread block:^(id data, NSError *error) {
        [self.tableView.pullRefreshCtrl endRefreshing];
        if (data) {
            self.dataList = data;
            [self.tableView reloadData];
        }
        [self configBlankPageHasError:error != nil hasData:self.dataList.count > 0];
    }];
}
- (void)configBlankPageHasError:(BOOL)hasError hasData:(BOOL)hasData{
    __weak typeof(self) weakSelf = self;
    if (hasData) {
        [self.tableView removeBlankPageView];
    }else if (hasError){
        [self.tableView configBlankPageErrorBlock:^(id sender) {
            [weakSelf refresh];
        }];
    }else{
        [self.tableView configBlankPageImage:kBlankPageImageNotification tipStr:@"您还没有收到任何通知"];
    }

}

- (void)p_markReadAll{
    [[Coding_NetAPIManager sharedManager] post_markNotificationBlock:^(id data, NSError *error) {
        if (data) {
            [self.dataList enumerateObjectsUsingBlock:^(MartNotification *obj, NSUInteger idx, BOOL *stop) {
                obj.status = @(YES);
            }];
            [self.tableView reloadData];
        }
    }];
}
- (void)p_markN:(MartNotification *)curN{
    [[Coding_NetAPIManager sharedManager] post_markNotification:curN.id block:^(id data, NSError *error) {
        if (data) {
            curN.status = @(YES);
            [self.tableView reloadData];
        }
    }];
}

#pragma mark TableM
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MartNotification *curN = self.dataList[indexPath.row];
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:curN.hasReason? kCellIdentifier_NotificationCell_0: kCellIdentifier_NotificationCell_1 forIndexPath:indexPath];
    cell.notification = curN;
    cell.linkStrBlock = ^(NSString *linkStr){
        if (!curN.status.boolValue) {
            [self p_markN:curN];
        }
        [self goToLinkStr:linkStr];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NotificationCell cellHeightWithObj:self.dataList[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MartNotification *curN = self.dataList[indexPath.row];
    if (!curN.status.boolValue) {
        [self p_markN:curN];
    }
}

- (void)goToLinkStr:(NSString *)linkStr{
    UIViewController *vc = [UIViewController analyseVCFromLinkStr:linkStr];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
