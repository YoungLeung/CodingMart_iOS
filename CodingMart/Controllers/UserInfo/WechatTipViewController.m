//
//  WechatTipViewController.m
//  CodingMart
//
//  Created by Ease on 2016/11/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "WechatTipViewController.h"
#import "UIImageView+WebCache.h"

@interface WechatTipViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;

@end

@implementation WechatTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_qrCodeLinkStr.length > 0) {
        [_codeImageV sd_setImageWithURL:[NSURL URLWithString:_qrCodeLinkStr]];
    }
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