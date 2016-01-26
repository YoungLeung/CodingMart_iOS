//
//  PayResultViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayResultViewController.h"
#import "RewardPrivateViewController.h"
#import "MartWebViewController.h"

@interface PayResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentPaidL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *totalPaidL;

@end

@implementation PayResultViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Pay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PayResultViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Btn 

- (IBAction)recordBtnClicked:(id)sender {
    NSString *path = [NSString stringWithFormat:@"/reward/%@/activity", _curReward.id.stringValue];
    [self goToWebVCWithUrlStr:path title:@"项目动态"];
}

- (IBAction)rewardDetailBtnClicked:(id)sender {
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:_curReward];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
