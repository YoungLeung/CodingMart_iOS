//
//  RootMessageViewController.m
//  CodingMart
//
//  Created by chao chen on 2017/2/13.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "RootMessageViewController.h"
#import "Coding_NetAPIManager.h"
#import "ConversationCell.h"
#import "ConversationViewController.h"
#import "ToMessageCell.h"
#import "SVPullToRefresh.h"
#import "NotificationViewController.h"

#import "Coding_NetAPIManager.h"
#import "Login.h"

@interface RootMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSArray *conversationList;
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
//    __weak typeof(self) weakSelf = self;
//    [_myTableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf refreshMore];
//    }];
//    _myTableView.showsInfiniteScrolling = NO;
}

- (void)tabBarItemClicked{
    CGFloat contentOffsetY_Top = -[self navBottomY];
    if (_myTableView.contentOffset.y > contentOffsetY_Top) {
        [_myTableView setContentOffset:CGPointMake(0, contentOffsetY_Top) animated:YES];
    }else if (!_myTableView.pullRefreshCtrl.isRefreshing){
        [_myTableView eaTriggerPullToRefresh];
        [self refresh];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refresh];
}

#pragma mark Data

- (void)loginTimChat{
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_LoginTimChatBlock:^(NSString *errorMsg) {
        if (errorMsg.length > 0) {
            [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        }else{
            [weakSelf refresh];
        }
    }];
}

- (void)refresh{
    if ([TIMManager sharedInstance].getLoginStatus != TIM_STATUS_LOGINED) {//登录并刷新对话列表
        [_myTableView triggerPullToRefresh];
        [self loginTimChat];
    }else{//刷新未读通知
        WEAKSELF;
        [[Coding_NetAPIManager sharedManager] get_EAConversationListBlock:^(id data, NSError *error) {
            [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
            if (data) {
                weakSelf.conversationList = data;
                [weakSelf.myTableView reloadData];
            }
        }];
    }
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 2;
    if (_conversationList) {
        row += [_conversationList count];
    }
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
        EAConversation *conversation = _conversationList[indexPath.row - 2];
        cell.curConversation = conversation;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:75 hasSectionLine:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if (indexPath.row < 2) {
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
    }else{
        ConversationViewController *vc = [ConversationViewController vcInStoryboard:@"Message"];
        vc.eaConversation = _conversationList[indexPath.row - 2];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
