//
//  RootPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootPriceViewController.h"
#import "ChooseSystemPayView.h"
#import "User.h"
#import "Coding_NetAPIManager.h"

@interface RootPriceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startSystemButton;
@property (strong, nonatomic) ChooseSystemPayView *chooseSystemPayView;
@end

@implementation RootPriceViewController

+ (instancetype)storyboardVC {
    BOOL firstUse = [User payedForPriceSystem];
    if (!firstUse) {
        // 第一次使用
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PriceSystem" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"RootPriceViewController"];
    } else {
        // 第二次使用
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PriceSystem" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"ChooseProjectViewController"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL firstUse = [User payedForPriceSystem];
    if (firstUse) {
        // 第一次使用
        __weak typeof(self)weakSelf = self;
        
        dispatch_queue_t queen = dispatch_queue_create("checkPay", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(queen, ^{
//            [weakSelf checkPayed];
        });
        
        dispatch_async(queen, ^{
            
        });

    } else {
        // 第二次使用
        
    }
}

// 检查有没有支付过1元
- (void)checkPayed {
    [[Coding_NetAPIManager sharedManager] get_payedBlock:^(id data, NSError *error) {
        if (data) {
            NSDictionary *dictionary = [data objectForKey:@"data"];
            [User payedForPriceSystemData:dictionary];
            NSLog(@"1");
        }
    }];
}

#pragma mark - First Time
- (IBAction)startButtonPress:(id)sender {
    self.chooseSystemPayView = [[ChooseSystemPayView alloc] init];
}

#pragma mark - Second Time

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
