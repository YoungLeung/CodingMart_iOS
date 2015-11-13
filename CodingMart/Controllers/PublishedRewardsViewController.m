//
//  PublishedRewardsViewController.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishedRewardsViewController.h"
#import "Coding_NetAPIManager.h"

@interface PublishedRewardsViewController ()
@property (strong, nonatomic) NSArray *rewardList;

@end

@implementation PublishedRewardsViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PublishedRewardsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我发布的悬赏";
}
- (void)refresh{
    [[Coding_NetAPIManager sharedManager] get_JoinedRewardListBlock:^(id data, NSError *error) {
        if (data) {
            self.rewardList = data;
            [self refreshUI];
        }
    }];
}

- (void)refreshUI{
    
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

@end
