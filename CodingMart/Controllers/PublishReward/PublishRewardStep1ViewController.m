//
//  PublishRewardStep1ViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishRewardStep1ViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "PublishRewardStep2ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ActionSheetStringPicker.h"
#import "TableViewFooterButton.h"
#import "UIViewController+BackButtonHandler.h"


@interface PublishRewardStep1ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *docNotHaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *docHaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *pmNotNeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *pmNeedBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *budgetL;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *nextStepBtn;


@property (strong, nonatomic) NSArray *typeList, *budgetList;

@end

@implementation PublishRewardStep1ViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PublishReward" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PublishRewardStep1ViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布悬赏";
    UIView *tableHeaderView = self.tableView.tableHeaderView;
    tableHeaderView.height = 0.35 * kScreen_Width;
    self.tableView.tableHeaderView = tableHeaderView;
    
    _typeList = @[@"网站",
                  @"APP",
                  @"微信开发",
                  @"HTML5 应用",
                  @"其他"];
    _budgetList = @[@"1万以下",
                    @"1-3万",
                    @"3-5万",
                    @"5万以上"];
    
    if (!_rewardToBePublished) {
        _rewardToBePublished = [Reward rewardToBePublished];
    }
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, rewardToBePublished.require_clear) subscribeNext:^(NSNumber *require_clear) {
        [weakSelf p_setButton:_docNotHaveBtn toSelected:!require_clear.boolValue];
        [weakSelf p_setButton:_docHaveBtn toSelected:require_clear.boolValue];
    }];
    [RACObserve(self, rewardToBePublished.need_pm) subscribeNext:^(NSNumber *need_pm) {
        [weakSelf p_setButton:_pmNotNeedBtn toSelected:!need_pm.boolValue];
        [weakSelf p_setButton:_pmNeedBtn toSelected:need_pm.boolValue];
    }];
    [RACObserve(self, rewardToBePublished.type) subscribeNext:^(NSNumber *type) {
        if (type) {
            weakSelf.fd_interactivePopDisabled = YES;
            weakSelf.typeL.textColor = [UIColor blackColor];
            weakSelf.typeL.text = [[NSObject rewardTypeDict] findKeyFromStrValue:type.stringValue];
        }else{
            weakSelf.typeL.textColor = [UIColor colorWithHexString:@"0xCCCCCC"];
            weakSelf.typeL.text = @"请选择";
        }
    }];
    [RACObserve(self, rewardToBePublished.budget) subscribeNext:^(NSNumber *budget) {
        if (budget) {
            weakSelf.fd_interactivePopDisabled = YES;
            weakSelf.budgetL.textColor = [UIColor blackColor];
            weakSelf.budgetL.text = weakSelf.budgetList[budget.integerValue];
        }else{
            weakSelf.budgetL.textColor = [UIColor colorWithHexString:@"0xCCCCCC"];
            weakSelf.budgetL.text = @"请选择";
        }
    }];
    RAC(self.nextStepBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, rewardToBePublished.type),
                                                                RACObserve(self, rewardToBePublished.budget),
                                                                ] reduce:^id(NSNumber *type, NSNumber *budget){
                                                                    return @(type != nil && budget != nil);
                                                                }];
}


- (void)p_setButton:(UIButton *)button toSelected:(BOOL)seleted{
    UIColor *foreColor = [UIColor colorWithHexString:seleted? @"0x2FAEEA": @"0xCCCCCC"];
    [button doBorderWidth:1.0 color:foreColor cornerRadius:2.0];
    [button setTitleColor:foreColor forState:UIControlStateNormal];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PublishRewardStep2ViewController *vc = [segue destinationViewController];
    vc.rewardToBePublished = _rewardToBePublished;
}

- (BOOL)navigationShouldPopOnBackButton{
    if (!_rewardToBePublished.type && !_rewardToBePublished.budget) {
        return YES;
    }
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"是否需要保存草稿？" buttonTitles:@[@"保存并退出"] destructiveTitle:@"删除并退出" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index < 2) {
            if (index == 0) {
                [Reward saveDraft:weakSelf.rewardToBePublished];
            }else{
                [Reward deleteCurDraft];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }] showInView:self.view];
    return NO;
}

#pragma mark Btn
- (IBAction)docBtnClicked:(id)sender {
    if (sender == _docHaveBtn) {
        [NSObject showHudTipStr:@"暂时还不支持上传文档"];
    }
}

- (IBAction)pmBtnClicked:(id)sender {
    if ((sender == _pmNeedBtn && !_rewardToBePublished.need_pm.boolValue)
        || ((sender == _pmNotNeedBtn && _rewardToBePublished.need_pm.boolValue))) {
        _rewardToBePublished.need_pm = _rewardToBePublished.need_pm.boolValue? @0: @1;
    }
}


#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *list;
        NSInteger curRow;
        if (indexPath.row == 0) {
            list = _typeList;
            if (_rewardToBePublished.type) {
                NSString *key = [[NSObject rewardTypeDict] findKeyFromStrValue:_rewardToBePublished.type.stringValue];
                curRow = [list indexOfObject:key];
            }else{
                curRow = 0;
            }
        }else{
            list = _budgetList;
            curRow = _rewardToBePublished.budget? _rewardToBePublished.budget.integerValue: 0;
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            NSNumber *selectedRow = selectedIndex.firstObject;
            if (indexPath.row == 0) {
                NSString *value = [[NSObject rewardTypeDict] objectForKey:list[selectedRow.integerValue]];
                weakSelf.rewardToBePublished.type = @(value.integerValue);
            }else{
                weakSelf.rewardToBePublished.budget = selectedRow;
            }
        } cancelBlock:nil origin:self.view];
        
    }
    
}
@end
