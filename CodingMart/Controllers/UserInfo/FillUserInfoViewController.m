//
//  FillUserInfoViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillUserInfoViewController.h"
#import "TableViewFooterButton.h"

@interface FillUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_code_separatorLC;

@property (weak, nonatomic) IBOutlet UITextField *qqNumF;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;

@end


@implementation FillUserInfoViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"个人信息";
    _phone_code_separatorLC.constant = 0.5;
    
}
#pragma mark Btn
- (IBAction)submitBtnClicked:(id)sender {
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
    }
}

@end
