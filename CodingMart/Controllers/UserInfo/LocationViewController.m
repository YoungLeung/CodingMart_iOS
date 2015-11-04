//
//  LocationViewController.m
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationCell.h"
#import "Coding_NetAPIManager.h"
#import "UIViewController+BackButtonHandler.h"

@interface LocationViewController ()
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSNumber *originalSelectedID;
@property (strong, nonatomic) NSDictionary *selectedPlace;
@property (assign, nonatomic) NSUInteger curLevel;
@end

@implementation LocationViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (_selectedList.count <= 0) {
        _selectedList = [NSMutableArray new];
        _curLevel = 1;
        _params = @{@"parent": @(0),
                    @"level": @(_curLevel)};
        self.title = @"选择地区";
    }else{
        NSDictionary *place = [_selectedList lastObject];
        _curLevel = _selectedList.count +1;
        _params = @{@"parent": place[@"id"],
                    @"level": @(_curLevel)};
        self.title = place[@"name"];
    }
    if (_originalSelectedList.count >= _curLevel) {
        _originalSelectedID = _originalSelectedList[_curLevel - 1];
    }
    if (_selectedList.count >= _curLevel) {
        _selectedPlace = _selectedList[_curLevel - 1];
    }
    if (_dataList.count <= 0) {
        [self refresh];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)refresh{
    [NSObject showHUDQueryStr:nil];
    [[Coding_NetAPIManager sharedManager] get_LocationListWithParams:_params block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            self.dataList = data;
            [self.tableView reloadData];
        }
    }];
}

- (BOOL)navigationShouldPopOnBackButton{
    [_selectedList removeObject:_selectedList.lastObject];
    return YES;
}
#pragma mark Table M
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"全部";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LocationCell forIndexPath:indexPath];
    NSDictionary *place = _dataList[indexPath.row];
    cell.leftL.text = place[@"name"];
    cell.accessoryType = _curLevel < 3? UITableViewCellAccessoryDisclosureIndicator: UITableViewCellAccessoryNone;
    if (_selectedPlace) {
        cell.rightL.text = [_selectedPlace[@"id"] isEqualToNumber:place[@"id"]]? @"已选地区": @"";
    }else{
        cell.rightL.text = [_originalSelectedID isEqualToNumber:place[@"id"]]? @"已选地区": @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedPlace = _dataList[indexPath.row];
    _selectedList[_curLevel - 1] = _selectedPlace;
    
    if (_curLevel == 3) {
        [self complate];
    }else{
        NSDictionary *params = @{@"parent": _selectedPlace[@"id"],
                    @"level": @(_curLevel +1)};
        [NSObject showHUDQueryStr:nil];
        [[Coding_NetAPIManager sharedManager] get_LocationListWithParams:params block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [self goToNextWithData:data];
            }
        }];
    }
}

- (void)goToNextWithData:(NSArray *)data{
    if (data.count > 0) {
        LocationViewController *vc = [LocationViewController storyboardVC];
        vc.dataList = data;
        vc.originalSelectedList = _originalSelectedList;
        vc.selectedList = _selectedList;
        vc.complateBlock = _complateBlock;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self complate];
    }
}

- (void)complate{
    if (self.complateBlock) {
        self.complateBlock(self.selectedList);
    }
    NSUInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[(count - 1) - _curLevel];
    [self.navigationController popToViewController:vc animated:YES];
}
@end
