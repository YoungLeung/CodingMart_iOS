//
//  AboutViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "AboutViewController.h"
#import "UITTTAttributedLabel.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"关于页面"];
    
    self.title = @"关于码市";
    [_footerL addLinkToStr:@"400-026-3464" whithValue:@"400-026-3464" andBlock:^(id value) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000263464"]];
    }];
    _versionL.text = [NSString stringWithFormat:@"V%@", [NSObject appVersion]];
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
