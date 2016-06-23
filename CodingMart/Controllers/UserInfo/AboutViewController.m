//
//  AboutViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "AboutViewController.h"
#import "UITTTAttributedLabel.h"
#import "MartShareView.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionL;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"关于页面"];
    _versionL.text = [NSString stringWithFormat:@"V%@", [NSObject appVersion]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){//推荐给好友
        [MartShareView showShareViewWithObj:nil];
    }else{//去评分
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60];
}

@end
