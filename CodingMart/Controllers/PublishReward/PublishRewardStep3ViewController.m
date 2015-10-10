//
//  PublishRewardStep3ViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishRewardStep3ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TableViewFooterButton.h"

@interface PublishRewardStep3ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *line1V;
@property (weak, nonatomic) IBOutlet UIImageView *line2V;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;

@property (weak, nonatomic) IBOutlet UITextField *contact_nameF;
@property (weak, nonatomic) IBOutlet UITextField *contact_mobileF;
@property (weak, nonatomic) IBOutlet UITextField *contact_emailF;


@end

@implementation PublishRewardStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = kColorTableSectionBg;
    UIImage *line_dot_image = [UIImage imageNamed:@"line_dot"];
    line_dot_image = [line_dot_image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode: UIImageResizingModeTile];
    _line1V.image = _line2V.image = line_dot_image;
    
    self.title = @"发布悬赏";
    [self p_setupTextEvents];
    RAC(self.nextStepBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, rewardToBePublished.contact_name),
                                                                RACObserve(self, rewardToBePublished.contact_mobile),
                                                                RACObserve(self, rewardToBePublished.contact_email)
                                                                ] reduce:^id(NSString *contact_name, NSString *contact_mobile, NSString *contact_email){
                                                                    BOOL enabled = YES;
                                                                    enabled = (contact_name.length > 0 && contact_mobile.length > 0 && contact_email.length > 0);
                                                                    return @(enabled);
                                                                }];

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

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    if (section > 0) {
        headerV = [UIView new];
    }
    return headerV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionH = 0;
    if (section > 0) {
        sectionH = 10;
    }
    return sectionH;
}
#pragma mark Text M
- (void)p_setupTextEvents{
    _contact_nameF.text = _rewardToBePublished.contact_name;
    _contact_mobileF.text = _rewardToBePublished.contact_mobile;
    _contact_emailF.text = _rewardToBePublished.contact_email;
    
    __weak typeof(self) weakSelf = self;
    [_contact_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_name = newText;
    }];
    [_contact_mobileF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_mobile = newText;
    }];
    [_contact_emailF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.contact_email = newText;
    }];
}
#pragma mark Btn
- (IBAction)nextStepBtnClicked:(id)sender {
    NSLog(@"登录或者提交");
}

@end
