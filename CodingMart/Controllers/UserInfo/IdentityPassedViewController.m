//
//  IdentityPassedViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "IdentityPassedViewController.h"
#import "UIImageView+WebCache.h"
#import "Login.h"
#import "UITTTAttributedLabel.h"
#import "EATipView.h"

@interface IdentityPassedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *identityNumL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *headerL;

@end

@implementation IdentityPassedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF
    [_headerL addLinkToStr:@"联系客服" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToTalk];
    }];

    _nameL.text = _info.name;
    NSString *displayStr = _info.identity;
    if (displayStr.length > 5) {
        displayStr = [displayStr stringByReplacingCharactersInRange:NSMakeRange(3, displayStr.length - 5) withString:@"*********"];
    }
    _identityNumL.text = displayStr;
    [self.tableView reloadData];
}

- (IBAction)goToAggrement:(id)sender {
    [self goToWebVCWithUrlStr:_info.agreementLinkStr title:@"身份认证授权与承诺书"];
}

#pragma mark Table

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
//    return _info.agreementLinkStr.length > 0? 155: 100;
}
@end
