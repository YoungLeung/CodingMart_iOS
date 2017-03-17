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
#import "NotificationViewController.h"

#import "Coding_NetAPIManager.h"
#import "Login.h"
#import "UnReadManager.h"

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

- (void)configBlankPageHasError:(BOOL)hasError hasData:(BOOL)hasData{
    if (hasData) {
        [self.view removeBlankPageView];
    }else if (hasError){//不处理，用户自己下拉刷新
    }else{
        [self.view configBlankPageImage:kBlankPageImageMessage tipStr:@"这里还没有消息"];
    }
    [self.view setBlankOffsetY:2 * [ToMessageCell cellHeight]];
}

#pragma mark onNewMessage
- (void)onNewMessage:(NSArray<TIMMessage *> *)msgs{
    NSArray *receiverList = [_conversationList valueForKey:@"uid"];
    BOOL needToRefreshConversationList = NO;
    for (TIMMessage *msg in msgs) {
        NSString *uid = msg.getConversation.getReceiver;
        if (![receiverList containsObject:uid]) {
            needToRefreshConversationList = YES;
            break;
        }
    }
    if (needToRefreshConversationList) {
        [self refresh];
    }else{
        [self.myTableView reloadData];
    }
}

#pragma mark Data
- (void)loginTimChat{
    WEAKSELF;
    [TIMManager loginBlock:^(NSString *errorMsg) {
        if (errorMsg.length > 0) {
            [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        }else{
            [weakSelf refresh];
        }
    }];
}

- (void)refresh{
    if ([TIMManager sharedInstance].getLoginStatus == TIM_STATUS_LOGOUT) {
        //登录
        [_myTableView eaTriggerPullToRefresh];
        [self loginTimChat];
    }else{
        //刷新对话列表
        WEAKSELF;
        [[Coding_NetAPIManager sharedManager] get_EAConversationListBlock:^(id data, NSError *error) {
            [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
            if (data) {
                weakSelf.conversationList = data;
                [weakSelf.myTableView reloadData];
            }
            [weakSelf configBlankPageHasError:(error != nil) hasData:(weakSelf.conversationList.count > 0)];
        }];
        //刷新未读通知
        [UnReadManager updateUnReadWidthQuery:YES block:^{
            [weakSelf.myTableView reloadData];
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
        if (indexPath.row == 0) {
            cell.unreadCount = [UnReadManager shareManager].systemUnreadNum;
        }else{
            cell.unreadCount = [UnReadManager shareManager].rewardUnreadNum;
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

//-----------------------------------Editing
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除会话";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row >= 2);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    EAConversation *eaCon = _conversationList[indexPath.row - 2];
    
    if ([[TIMManager sharedInstance] deleteConversation:eaCon.isTribe? TIM_GROUP: TIM_C2C receiver:eaCon.uid]) {
        NSMutableArray *conversationList = self.conversationList.mutableCopy;
        [conversationList removeObject:eaCon];
        self.conversationList = conversationList.copy;
        [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

//        空白页需要更新
        [self configBlankPageHasError:NO hasData:(self.conversationList.count > 0)];
    }else{
        [NSObject showHudTipStr:@"删除失败！"];
    }
}


@end
