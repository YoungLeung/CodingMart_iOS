//
//  MPayDepositViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayDepositViewController.h"
#import "Login.h"

@interface MPayDepositViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *alipayCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *wechatCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *bankCheckV;
@property (weak, nonatomic) IBOutlet UITextField *priceF;
@property (assign, nonatomic) NSInteger platformIndex;

@property (weak, nonatomic) IBOutlet UILabel *tipL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *contactL;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

//@property (strong, nonatomic) NSString *platform;//Weixin、
@end

@implementation MPayDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.platformIndex = 0;
    _remarkL.text = [NSString stringWithFormat:@"码市开发宝账户充值，充值账户：%@", [Login curLoginUser].global_key];
}

- (void)setPlatformIndex:(NSInteger)platformIndex{
    _platformIndex = platformIndex;
    _alipayCheckV.image = [UIImage imageNamed:_platformIndex == 0? @"pay_checked": @"pay_unchecked"];
    _wechatCheckV.image = [UIImage imageNamed:_platformIndex == 1? @"pay_checked": @"pay_unchecked"];
    _bankCheckV.image = [UIImage imageNamed:_platformIndex == 2? @"pay_checked": @"pay_unchecked"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomBtn.hidden = self.platformIndex == 2;
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1? 15: 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        height = 60;
    }else{
        if (indexPath.row == 0) {
            height = _platformIndex == 2? 0: 44;
        }else{
            if (_platformIndex == 2) {
                CGFloat tipLWidth = kScreen_Width - 2* (15 + 15 + 10);
                CGFloat textWidth = kScreen_Width - 2* (15 + 15);
                height = (15 + 10 +
                          [_tipL.text getHeightWithFont:_tipL.font constrainedToSize:CGSizeMake(tipLWidth, CGFLOAT_MAX)] +
                          10 + 15 +
                          50* 3 +
                          30 +
                          [_remarkL.text getHeightWithFont:_remarkL.font constrainedToSize:CGSizeMake(textWidth, CGFLOAT_MAX)] +
                          20 +
                          [_contactL.text getHeightWithFont:_contactL.font constrainedToSize:CGSizeMake(textWidth, CGFLOAT_MAX)] +
                          15);
            }else{
                height = 0;
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
    }else{
        if (_platformIndex != 2) {
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.platformIndex = indexPath.row;
    }
}

- (IBAction)bottomBtnClicked:(id)sender {
//    TODO
    [NSObject showHudTipStr:@"待开发"];
}
@end
