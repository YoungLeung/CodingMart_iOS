//
//  ConversationContactsViewController.m
//  CodingMart
//
//  Created by Ease on 2017/3/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "ConversationContactsViewController.h"
#import "EAConversationContactCell.h"
#import "ConversationViewController.h"
#import "Coding_NetAPIManager.h"

@interface ConversationContactsViewController ()

@end

@implementation ConversationContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"群成员（%@）", _eaConversation.contactList? @(_eaConversation.contactList.count): @"..."];
    
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    if (!_eaConversation.contactList) {
        [self refresh];
    }
}

- (void)refresh{
    if (!_eaConversation.contactList) {
        [self.view beginLoading];
    }
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_MemberOfConversation:_eaConversation.contact.objectId block:^(id data, NSError *error) {
        [self.view endLoading];
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.eaConversation.contactList = data;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _eaConversation.contactList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EAConversationContactCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EAConversationContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EAConversationContactCell forIndexPath:indexPath];
    cell.curContact = _eaConversation.contactList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);//默认左边空 70
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EAChatContact *curContact = _eaConversation.contactList[indexPath.row];
    TIMConversation *timCon = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:curContact.uid];
    EAConversation *eaCon = [EAConversation eaConWithTimCon:timCon];
    eaCon.contact = curContact;
    
    ConversationViewController *vc = [ConversationViewController vcInStoryboard:@"Message"];
    vc.eaConversation = eaCon;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
