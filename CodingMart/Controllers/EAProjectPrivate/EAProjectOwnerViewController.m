//
//  EAProjectOwnerViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectOwnerViewController.h"
#import "EAProjectUserContactCell.h"

@interface EAProjectOwnerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation EAProjectOwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_iconV sd_setImageWithURL:[_curProM.owner.avatar urlImageWithCodePathResizeToView:_iconV] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _nameL.text = _curProM.owner.name;
}

#pragma mark Table Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [UIView new];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kLine_MinHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerV = [UIView new];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kLine_MinHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EAProjectUserContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[EAProjectUserContactCell className] forIndexPath:indexPath];
    cell.curUser = _curProM.owner;
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:[EAProjectUserContactCell className] configuration:^(EAProjectUserContactCell *cell) {
        cell.curUser = _curProM.owner;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
