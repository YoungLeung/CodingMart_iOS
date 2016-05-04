//
//  HelpCenterViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "MartWebViewController.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *linkList = @[@"/help?type=common",
                              @"/help?type=guide",
                              @"/help?type=customer",
                              @"/help?type=developer"];
        if (indexPath.row < linkList.count) {
            NSString *titleStr = nil;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            for (UIView *subV in cell.contentView.subviews) {
                if ([subV isKindOfClass:[UILabel class]]) {
                    titleStr = [(UILabel *)subV text];
                    break;
                }
            }
            [self goToWebVCWithUrlStr:linkList[indexPath.row] title:titleStr];
        }
    }
}

@end
