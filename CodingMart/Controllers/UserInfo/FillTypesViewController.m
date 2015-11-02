//
//  FillTypesViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillTypesViewController.h"

@implementation FillTypesViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillTypesViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"完善资料";
}

#pragma mark Table M
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerV;
//    if (section > 0) {
//        headerV = [UIView new];
//    }
//    return headerV;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
@end
