//
//  FeedBackViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kTypeButtonTag_Start 1000

#import "FeedBackViewController.h"
#import "FeedBackInfo.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIViewController+BackButtonHandler.h"
#import "UIImageView+WebCache.h"
#import "FeedBackTypeButton.h"

@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *gkF;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet UITextView *contentF;
@property (weak, nonatomic) IBOutlet UITextField *j_captchaF;
@property (weak, nonatomic) IBOutlet UIView *j_captchaBgView;
@property (weak, nonatomic) IBOutlet UIImageView *j_captchaImgV;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;
@property (strong, nonatomic) IBOutletCollection(FeedBackTypeButton) NSArray *typeButtonList;
@property (strong, nonatomic) IBOutlet UIView *secH1;
@property (strong, nonatomic) IBOutlet UIView *secH2;


@property (strong, nonatomic) FeedBackInfo *feedBackInfo;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.feedBackInfo = [FeedBackInfo makeFeedBack];
    [_j_captchaBgView doBorderWidth:0.5 color:[UIColor colorWithHexString:@"0xCCCCCC"] cornerRadius:1.0];
    [_contentF doBorderWidth:0.5 color:[UIColor colorWithHexString:@"0xDDDDDD"] cornerRadius:1];
    _contentF.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
    [_j_captchaF doBorderWidth:0.5 color:[UIColor colorWithHexString:@"0xDDDDDD"] cornerRadius:1];
    for (FeedBackTypeButton *typeBtn in _typeButtonList) {
        [typeBtn setTitle:[[self typeDisplayList] objectAtIndex:typeBtn.tag - kTypeButtonTag_Start] forState:UIControlStateNormal];
        typeBtn.checked = NO;
    }

    __weak typeof(self) weakSelf = self;
    [_j_captchaBgView bk_whenTapped:^{
        [weakSelf refreshCaptchaImage];
    }];
//    RAC(self.submitBtn, enabled) = [RACSignal combineLatest:@[_nameF.rac_textSignal,
//                                                              _gkF.rac_textSignal,
//                                                              _emailF.rac_textSignal,
//                                                              _contentF.rac_textSignal,
//                                                              _j_captchaF.rac_textSignal,
//                                                              ]
//                                                     reduce:^id(NSString *name,
//                                                                NSString *phone,
//                                                                NSString *email,
//                                                                NSString *content,
//                                                                NSString *j_captcha
//                                                                ){
//                                                         BOOL enabled = YES;
//                                                         enabled = (name.length > 0 && phone.length > 0 && email.length > 0 && content.length > 0 && j_captcha.length > 0);
//                                                         return @(enabled);
//                                                     }];
    
    [self refreshCaptchaImage];
}

- (void)setFeedBackInfo:(FeedBackInfo *)feedBackInfo{
    _feedBackInfo = feedBackInfo;
    _nameF.text = _feedBackInfo.name;
    _gkF.text = _feedBackInfo.global_key ?: _feedBackInfo.phone ?: _feedBackInfo.email;
    _emailF.text = _feedBackInfo.email;
    _contentF.text = _feedBackInfo.content;
    _j_captchaF.text = _feedBackInfo.j_captcha;
}
#pragma mark Navigation
- (BOOL)navigationShouldPopOnBackButton{
    if (_contentF.text.length <= 0) {
        return YES;
    }
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"退出编辑后内容将会被清空" buttonTitles:@[@"退出编辑"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }] showInView:self.view];
    return NO;
}

#pragma mark Btn
- (NSArray *)typeValueList{
    NSArray *list;
    if (!list) {
        list = @[@"SUGGESTION",
                 @"COMPLAINT",
                 @"PROJECT",
                 @"BUG",
                 @"OTHER",
                 ];
    }
    return list;
}

- (NSArray *)typeDisplayList{
    NSArray *list;
    if (!list) {
        list = @[@"意见与建议",
                 @"投诉",
                 @"项目纠纷",
                 @"BUG 反馈",
                 @"其他",
                 ];
    }
    return list;
}

- (IBAction)typeButtonClicked:(FeedBackTypeButton *)sender {
    sender.checked = !sender.checked;
}

- (IBAction)submitBtnClicked:(id)sender {
    _feedBackInfo.name = _nameF.text;
    _feedBackInfo.global_key = _gkF.text;
    _feedBackInfo.email = _emailF.text;
    _feedBackInfo.content = _contentF.text;
    _feedBackInfo.j_captcha = _j_captchaF.text;
    
    NSMutableArray *typeList = @[].mutableCopy;
    for (FeedBackTypeButton *typeBtn in _typeButtonList) {
        if (typeBtn.checked) {
            [typeList addObject:[[self typeValueList] objectAtIndex:typeBtn.tag - kTypeButtonTag_Start]];
        }
    }
    _feedBackInfo.typeList = typeList.copy;
    
    NSString *tipStr = [_feedBackInfo hasErrorTip];
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"帮助与反馈_提交意见反馈"];
    [NSObject showHUDQueryStr:@"正在发送..."];
    [[Coding_NetAPIManager sharedManager] post_FeedBack:_feedBackInfo block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertView bk_showAlertViewWithTitle:@"提交成功" message:@"非常感谢您的反馈！码市顾问将会在 1 - 2 个工日内与你联系" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] handler:nil];
//            [NSObject showHudTipStr:@"反馈成功"];
        }else{
            [self refreshCaptchaImage];
        }
    }];
}
- (void)refreshCaptchaImage{
    __weak typeof(self) weakSelf = self;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/feedback/captcha" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if ([data isKindOfClass:[NSDictionary class]] && data[@"image"]) {
            NSString *imageStr = data[@"image"];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[imageStr componentsSeparatedByString:@","].lastObject options:0];
            weakSelf.j_captchaImgV.image = [UIImage imageWithData:imageData];
        }
    }];
}
#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 0? _secH1: _secH2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);//隐藏掉它
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
