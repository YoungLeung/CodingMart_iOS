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

#define kHeardImgRatio 297/580
#define kHeardImgheight (kScreen_Width-20)*kHeardImgRatio

@interface CodingMarkTestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hearImg;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmationBtn;
- (IBAction)tapAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end

@implementation CodingMarkTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"码市测试";
    
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI
{
    self.imgHeight.constant=kHeardImgheight;
    
    UIFont *textFont =[UIFont fontWithName:@"HelveticaNeue" size:18];
    UIColor *nameCorlor=[UIColor colorWithHexString:@"3BBD79"];
    self.confirmationBtn.layer.masksToBounds=YES;
    self.confirmationBtn.layer.cornerRadius=5;

   
        
    WEAKSELF
    NSDictionary*styleDic = @{@"body":textFont,
                              @"from":[WPAttributedStyleAction styledActionWithAction:^{
//                                          KAlert(@"点我！");
                                  CodingMarkServerWebViewController *av =[CodingMarkServerWebViewController new];
                                  [weakSelf.navigationController pushViewController:av animated:YES];
                               }],
                              @"link": nameCorlor};
    
    NSString* textLabelCont=@"请您认真阅读<from>《开发者服务指南》</from>, 了解作为开发者如何规范地在 Coding 码市平台上参与悬赏。 阅读完成后，请参与如下的测试问卷，以便于 Coding 码市知悉您对码市平台开发流程的学习成果。 通过本次秘笈测试，您就可以报名码市的悬赏了！";
    self.contentLabel.attributedText = [textLabelCont attributedStringWithStyleBook:styleDic];
    self.contentLabel.numberOfLines = 0;
    
//    [self.hearImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(20);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.height.equalTo(@(kHeardImgheight));
//    }];
//
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.hearImg.mas_bottom).offset(10);
//        make.left.equalTo(self.hearImg.mas_left);
//        make.right.equalTo(self.hearImg.mas_right);
//        make.height.equalTo(@(200));
//    }];
//    
//    [self.confirmationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.equalTo(@45);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
//    }];
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
            av.dataSource=data;
            [weakSelf.navigationController pushViewController:av animated:YES];
        }
        
    }];
}
@end
