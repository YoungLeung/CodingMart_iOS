//
// Created by chao chen on 2017/3/3.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import "InvoiceAmoutViewController.h"
#import "Coding_NetAPIManager.h"
#import "UIViewController+Common.h"
#import "UITTTAttributedLabel.h"
#import "FillUserInfo.h"

@interface InvoiceAmoutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *bottomTip;

@end

@implementation InvoiceAmoutViewController

+ (id)vcWithIdetityDict{
    UIViewController *vc = [[InvoiceAmoutViewController class] vcInStoryboard:@"UserInfo"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    [_bottomTip addLinkToStr:@"联系客服" value:nil hasUnderline:NO clickedBlock:^(id value) {
        [weakSelf goToTalk];
    }];
    
    [[Coding_NetAPIManager sharedManager] get_InvoiceAmout:^(id data, NSError *error) {
        _amount.text = ((NSNumber *) data).stringValue;
    }];
    
}

@end
