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
#import "HBVLinkedTextView.h"

#define kHeardImgRatio 297/580
#define kHeardImgheight (kScreen_Width-20)*kHeardImgRatio

@interface CodingMarkTestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hearImg;
//@property (weak, nonatomic) IBOutlet WPHotspotLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmationBtn;
- (IBAction)tapAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet HBVLinkedTextView *contentTextView;

@end

@implementation CodingMarkTestViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"CodingMarkTestViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"码市测试";
    
    [self buildUI];
    
    if (self.hasPassTheTesting)
    {
        [NSObject showHudTipStr:@"您已经通过测试，可以查看答案"];
        [self.confirmationBtn setTitle:@"查看答案" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHasPassTheTesting:(BOOL)hasPassTheTesting
{
    _hasPassTheTesting=hasPassTheTesting;
}

-(void)buildUI
{
    self.imgHeight.constant=kHeardImgheight;
    
//    UIFont *textFont =[UIFont systemFontOfSize:17];
//    UIColor *nameCorlor=[UIColor colorWithHexString:@"3BBD79"];
    self.confirmationBtn.layer.masksToBounds=YES;
    self.confirmationBtn.layer.cornerRadius=5;
    
    NSString* textLabelCont=@"请您认真阅读《开发者服务指南》, 了解作为开发者如何规范地在 Coding 码市平台上参与悬赏。 阅读完成后，请参与如下的测试问卷，以便于 Coding 码市知悉您对码市平台开发流程的学习成果。 通过本次秘笈测试，您就可以报名码市的悬赏了！";
    
    self.contentTextView.font=[UIFont systemFontOfSize:17];
    self.contentTextView.text = textLabelCont;
    self.contentTextView.textAlignment=NSTextAlignmentLeft;
    
    NSString *stringToLink = @"《开发者服务指南》";
    
    
    NSMutableDictionary *highlightedAttributes=[@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                              NSForegroundColorAttributeName:[UIColor colorWithHexString:@"3BBD79"]}mutableCopy];

    
    //Pass in the string, attributes, and a tap handling block
    [self.contentTextView linkString:stringToLink
                   defaultAttributes:highlightedAttributes
               highlightedAttributes:highlightedAttributes
                          tapHandler:[self tapHandlerWithTitle:@"Link a single string"]];
   

}



- (LinkedStringTapHandler)tapHandlerWithTitle:(NSString *)title
{
    WEAKSELF
    LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
        
        CodingMarkServerWebViewController *av =[CodingMarkServerWebViewController new];
        [weakSelf.navigationController pushViewController:av animated:YES];
    };
    
    return exampleHandler;
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
