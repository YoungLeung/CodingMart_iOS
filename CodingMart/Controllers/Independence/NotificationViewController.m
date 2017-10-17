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
#import "SVPullToRefresh.h"
#import "MartNotifications.h"

@interface NotificationViewController ()
@property (strong, nonatomic) MartNotifications *notifications;
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
    _notifications = [MartNotifications martNotificationsOnlyUnRead:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    WEAKSELF;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore:YES];
    }];
    [self refresh];
}

- (void)rightBarButtonItemClicked{
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[_notifications.onlyUnRead? @"显示全部通知": @"仅显示未读通知", @"标记所有为已读"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            weakSelf.notifications = [MartNotifications martNotificationsOnlyUnRead:!weakSelf.notifications.onlyUnRead];
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
    [self refreshMore:NO];
}

- (void)refreshMore:(BOOL)loadMore{
    if (_notifications.isLoading) {
        return;
    }
    if (_notifications.list <= 0 && !self.tableView.pullRefreshCtrl.isRefreshing) {
        [self.view beginLoading];
    }
    _notifications.willLoadMore = loadMore;
    [[Coding_NetAPIManager sharedManager] get_Notifications:_notifications block:^(id data, NSError *error) {
        [self.view endLoading];
        [self.tableView.pullRefreshCtrl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = self.notifications.canLoadMore;
        [self.tableView reloadData];
        [self configBlankPageHasError:error != nil hasData:self.notifications.list.count > 0];
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
            [self.notifications.list enumerateObjectsUsingBlock:^(MartNotification *obj, NSUInteger idx, BOOL *stop) {
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
    return self.notifications.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MartNotification *curN = self.notifications.list[indexPath.row];
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
    return [NotificationCell cellHeightWithObj:self.notifications.list[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MartNotification *curN = self.notifications.list[indexPath.row];
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
