//
//  CodingMarkTestViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "CodingMarkTestViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "CodingMarkServerWebViewController.h"
#import "Coding_NetAPIManager.h"
#import "ExamViewController.h"
#import "UITTTAttributedLabel.h"

#define kHeardImgRatio 297/580
#define kHeardImgheight (kScreen_Width-20)*kHeardImgRatio

@interface CodingMarkTestViewController ()
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *confirmationBtn;
- (IBAction)tapAction:(id)sender;

@end

@implementation CodingMarkTestViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"CodingMarkTestViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"码市测试";
    
    WEAKSELF
    [_contentL addLinkToStr:@"《开发者服务指南》" value:nil hasUnderline:YES clickedBlock:^(id value) {
        CodingMarkServerWebViewController *av =[CodingMarkServerWebViewController new];
        [weakSelf.navigationController pushViewController:av animated:YES];
    }];
    
    if (self.hasPassTheTesting){
        [self.confirmationBtn setTitle:@"查看答案" forState:UIControlStateNormal];
    }
}

- (IBAction)tapAction:(id)sender
{
    [NSObject showHUDQueryStr:@"正在加载试题..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager]get_CodingExamTesting:^(id data, NSError *error)
    {
        [NSObject hideHUDQuery];
        if (!error)
        {
            ExamViewController *av =[ExamViewController new];
            av.viewerModel=weakSelf.hasPassTheTesting;
            av.dataSource=data;
            [weakSelf.navigationController pushViewController:av animated:YES];
        }
        
    }];
}
@end
