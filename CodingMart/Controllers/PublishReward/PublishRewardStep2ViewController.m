//
//  PublishRewardStep2ViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishRewardStep2ViewController.h"
#import "PublishRewardStep3ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TableViewFooterButton.h"

@interface PublishRewardStep2ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *line1V;
@property (weak, nonatomic) IBOutlet UIImageView *line2V;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *durationF;
@property (weak, nonatomic) IBOutlet UITextField *first_sampleF;
@property (weak, nonatomic) IBOutlet UITextField *second_sampleF;


@end

@implementation PublishRewardStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = kColorTableSectionBg;
    UIImage *line_dot_image = [UIImage imageNamed:@"line_dot"];
    line_dot_image = [line_dot_image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode: UIImageResizingModeTile];
    _line1V.image = _line2V.image = line_dot_image;
    
    self.title = @"发布悬赏";
    
    [_descriptionTextView doBorderWidth:0.5 color:[UIColor colorWithHexString:@"0xDDDDDD"] cornerRadius:1];
    [self p_setupTextEvents];
    RAC(self.nextStepBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, rewardToBePublished.name),
                                                                RACObserve(self, rewardToBePublished.description_mine),
                                                                RACObserve(self, rewardToBePublished.duration)
                                                                ] reduce:^id(NSString *name, NSString *description_mine, NSNumber *duration){
                                                                    BOOL enabled = YES;
                                                                    if (name.length <= 0 || description_mine.length < 50) {
                                                                        enabled = NO;
                                                                    }
                                                                    if (duration.integerValue <= 0 || duration.integerValue > 999) {
                                                                        enabled = NO;
                                                                    }
                                                                    return @(enabled);
                                                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    
    PublishRewardStep3ViewController *vc = [segue destinationViewController];
    vc.rewardToBePublished = _rewardToBePublished;
}
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
    }
}

#pragma mark Text M
- (void)p_setupTextEvents{
    _nameF.text = _rewardToBePublished.name;
    _descriptionTextView.text = _rewardToBePublished.description_mine;
    _durationF.text = _rewardToBePublished.duration.stringValue;
    _first_sampleF.text = _rewardToBePublished.first_sample;
    _second_sampleF.text = _rewardToBePublished.second_sample;
    
    __weak typeof(self) weakSelf = self;
    [_nameF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.name = newText;
    }];
    [_descriptionTextView.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.description_mine = newText;
    }];
    [_durationF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.duration = @(newText.integerValue);
    }];
    [_first_sampleF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.first_sample = newText;
    }];
    [_second_sampleF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.rewardToBePublished.second_sample = newText;
    }];
}
@end
