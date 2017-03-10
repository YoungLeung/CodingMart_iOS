//
//  RootMessageViewController.m
//  CodingMart
//
//  Created by chao chen on 2017/2/13.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "RootMessageViewController.h"
#import "Coding_NetAPIManager.h"
//#import "PrivateMessages.h"
#import "ConversationCell.h"
//#import "ConversationViewController.h"
#import "ToMessageCell.h"
#import "SVPullToRefresh.h"
#import "NotificationViewController.h"

@interface RootMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation RootMessageViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RootMessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    添加myTableView
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[ConversationCell class] forCellReuseIdentifier:kCellIdentifier_Conversation];
        [tableView registerClass:[ToMessageCell class] forCellReuseIdentifier:kCellIdentifier_ToMessage];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        {
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.rdv_tabBarController.tabBar.frame), 0);
            tableView.contentInset = insets;
            tableView.scrollIndicatorInsets = insets;
        }
        tableView;
    });
    [_myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    __weak typeof(self) weakSelf = self;
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore];
    }];
    
    [self.myTableView eaTriggerPullToRefresh];
    [self.myTableView setContentOffset:CGPointMake(0, -44)];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh{
//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] request_UnReadNotificationsWithBlock:^(id data, NSError *error) {
//        if (data) {
//            weakSelf.notificationDict = [NSMutableDictionary dictionaryWithDictionary:data];
//            [weakSelf.myTableView reloadData];
//            [weakSelf.myTableView configBlankPage:EaseBlankPageTypeMessageList hasData:(weakSelf.myPriMsgs.list.count > 0) hasError:(error != nil) offsetY:(3 * [ToMessageCell cellHeight]) reloadButtonBlock:^(id sender) {
//                [weakSelf refresh];
//            }];
//        }
//    }];
//    [[UnReadManager shareManager] updateUnRead];
//    
//    if (_myPriMsgs.isLoading) {
//        return;
//    }
//    _myPriMsgs.willLoadMore = NO;
//    [self sendRequest_PrivateMessages];
}

- (void)refreshMore{
//    if (_myPriMsgs.isLoading || !_myPriMsgs.canLoadMore) {
//        return;
//    }
//    _myPriMsgs.willLoadMore = YES;
//    [self sendRequest_PrivateMessages];
}

- (void)sendRequest_PrivateMessages{
//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] request_PrivateMessages:_myPriMsgs andBlock:^(id data, NSError *error) {
//        [weakSelf.refreshControl endRefreshing];
//        [weakSelf.myTableView.infiniteScrollingView stopAnimating];
//        if (data) {
//            [weakSelf.myPriMsgs configWithObj:data];
//            [weakSelf.myTableView reloadData];
//            weakSelf.myTableView.showsInfiniteScrolling = weakSelf.myPriMsgs.canLoadMore;
//            [weakSelf.myTableView configBlankPage:EaseBlankPageTypeMessageList hasData:(weakSelf.myPriMsgs.list.count > 0) hasError:(error != nil) offsetY:(3 * [ToMessageCell cellHeight]) reloadButtonBlock:^(id sender) {
//                [weakSelf refresh];
//            }];
//        }
//    }];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 2;
//    if (_myPriMsgs.list) {
//        row += [_myPriMsgs.list count];
//    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        ToMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ToMessage forIndexPath:indexPath];
        cell.type = indexPath.row;
        cell.unreadCount = @(rand() % 3);
        if (indexPath.row == 0) {
            
        }else{
            
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:75 hasSectionLine:NO];
        return cell;
    }else{
        ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Conversation forIndexPath:indexPath];
//        PrivateMessage *msg = [_myPriMsgs.list objectAtIndex:indexPath.row-3];
//        cell.curPriMsg = msg;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:75 hasSectionLine:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if (indexPath.row < 3) {
        cellHeight = [ToMessageCell cellHeight];
    }else{
        cellHeight = [ConversationCell cellHeight];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 2) {
        NotificationViewController *vc = [NotificationViewController storyboardVC];
        [self.navigationController pushViewController:vc animated:YES];

//        TipsViewController *vc = [[TipsViewController alloc] init];
//        vc.myCodingTips = [CodingTips codingTipsWithType:indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        PrivateMessage *curMsg = [_myPriMsgs.list objectAtIndex:indexPath.row-3];
//        ConversationViewController *vc = [[ConversationViewController alloc] init];
//        User *curFriend = curMsg.friend;
//        
//        vc.myPriMsgs = [PrivateMessages priMsgsWithUser:curFriend];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
