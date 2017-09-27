//
//  FillProjectSkillViewController.m
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FillProjectSkillViewController.h"
#import "UIPlaceHolderTextView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSDate+Helper.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "Coding_NetAPIManager.h"
#import "ProjectIndustryListViewController.h"

@interface FillProjectSkillViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *startL;
@property (weak, nonatomic) IBOutlet UITextField *finishL;
@property (weak, nonatomic) IBOutlet UITextField *projectTypeF;
@property (weak, nonatomic) IBOutlet UITextField *industryF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionT;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *dutyT;
@property (weak, nonatomic) IBOutlet UITextField *linkF;

@property (strong, nonnull) IBOutletCollection(UILabel) NSArray *fileLabelList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *fileLinkBtnList;
@property (strong, nonnull) IBOutletCollection(UIButton) NSArray *filedeleteBtnList;

@end

@implementation FillProjectSkillViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillProjectSkillViewController"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (!_pro) {
        self.pro = [SkillPro new];
    }
    BOOL isNewPro = ![_pro.id isKindOfClass:[NSNumber class]];
    self.title = isNewPro? @"添加项目经验": @"编辑项目经验";
    self.navigationItem.rightBarButtonItem = isNewPro? nil: [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];

    [self setupRACUI];
}

- (void)rightBarButtonItemClicked{
    WEAKSELF;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确认删除项目经验？删除后无法恢复。" buttonTitles:nil destructiveTitle:@"删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [weakSelf deletePro];
        }
    }] showInView:self.view];
}

- (void)deletePro{
    [NSObject showHUDQueryStr:@"正在移除项目经验..."];
    [[Coding_NetAPIManager sharedManager] post_DeleteSkillPro:_pro.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"项目经验已移除"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setupRACUI{
    WEAKSELF;

    _nameF.text = _pro.project_name;
    _descriptionT.text = _pro.description_mine;
    _dutyT.text = _pro.duty;
    _linkF.text = _pro.link;
    
    [_nameF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.pro.project_name = value;
    }];
    [RACObserve(self, pro.start_time_numerical) subscribeNext:^(NSString *dateStr) {
        weakSelf.startL.text = dateStr;
    }];
    [RACObserve(self, pro.until_now) subscribeNext:^(id x) {
        weakSelf.finishL.text = weakSelf.pro.until_now.boolValue? @"至今": weakSelf.pro.finish_time_numerical;
    }];
    [_descriptionT.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.pro.description_mine = value;
    }];
    [_dutyT.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.pro.duty = value;
    }];
    [_linkF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.pro.link = value;
    }];
    [RACObserve(self, pro.industryName) subscribeNext:^(NSString *value) {
        weakSelf.industryF.text = value;
    }];
    [RACObserve(self, pro.projectTypeName) subscribeNext:^(NSString *value) {
        weakSelf.projectTypeF.text = value;
    }];
    [self updateFileList];
}

- (void)updateFileList{
    WEAKSELF;
    [_pro.files enumerateObjectsUsingBlock:^(MartFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < weakSelf.fileLabelList.count) {
            UILabel *fileL = weakSelf.fileLabelList[idx];
            fileL.text = obj.filename;
        }
    }];
}

#pragma mark Btn
- (IBAction)startBtnClicked:(id)sender {
    [self.view endEditing:YES];
    WEAKSELF;
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"起始时间" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate dateFromString:_pro.start_time_numerical withFormat:@"yyyy-MM-dd"] ?:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        weakSelf.pro.start_time_numerical = [selectedDate stringWithFormat:@"yyyy-MM-dd"];
    } cancelBlock:nil origin:self.view];
    picker.maximumDate = [NSDate date];
    [picker showActionSheetPicker];
}

- (IBAction)finishBtnClicked:(id)sender {
    [self.view endEditing:YES];
    WEAKSELF;
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"结束时间" datePickerMode:UIDatePickerModeDate selectedDate:_pro.until_now.boolValue? [NSDate date]: [NSDate dateFromString:_pro.finish_time_numerical withFormat:@"yyyy-MM-dd"] ?:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        weakSelf.pro.finish_time_numerical = [selectedDate stringWithFormat:@"yyyy-MM-dd"];
        weakSelf.pro.until_now = @(NO);
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        if (picker.cancelButtonClicked) {
            weakSelf.pro.until_now = @(YES);
        }
    } origin:self.view];
    picker.maximumDate = [NSDate date];
    [picker setCancelButtonTitle:@"至今"];
    [picker showActionSheetPicker];
}

- (IBAction)fileLinkBtnClicked:(id)sender {
    NSUInteger index = [_fileLinkBtnList indexOfObject:sender];
    MartFile *file = _pro.files[index];
    [self goToWebVCWithUrlStr:file.url title:file.filename];
}

- (IBAction)fileDeleteBtnClicked:(id)sender {
    NSUInteger index = [_filedeleteBtnList indexOfObject:sender];
    [_pro.files removeObjectAtIndex:index];
    
    [self updateFileList];//更新数据
    [self.tableView reloadData];//更新行数
}

- (IBAction)saveBtnClicked:(id)sender {
    NSString *tipStr = nil;
    NSString *someThingEmpty = (_pro.project_name.length <= 0? @"项目名称":
                                !_pro.projectType? @"项目类型":
                                _pro.start_time_numerical.length <= 0? @"起始时间":
                                (_pro.finish_time_numerical.length <= 0 && !_pro.until_now.boolValue)? @"结束时间":
                                _pro.industry.length <= 0? @"行业标签":
                                _pro.description_mine.length <= 0? @"项目描述":
                                _pro.duty.length <= 0? @"我的职责": nil);
    if (someThingEmpty) {
        tipStr = [NSString stringWithFormat:@"请填写%@", someThingEmpty];
    }else if (_pro.description_mine.length < 100 || _pro.description_mine.length > 2000){
        tipStr = @"项目描述应为 100 - 2000 字";
    }else if (_pro.duty.length < 50 || _pro.duty.length > 1000){
        tipStr = @"我的职责应为 50 - 1000 字";
    }else if (!_pro.until_now.boolValue && [_pro.start_time compare:_pro.finish_time] == NSOrderedDescending){
        tipStr = @"项目结束时间不得早于起始时间";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    
    [NSObject showHUDQueryStr:@"正在保存项目..."];
    [[Coding_NetAPIManager sharedManager] post_SkillPro:_pro block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"项目保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7+ _pro.files.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row == 0 ) {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {//项目类型
        NSArray *list = @[@"Web 网站",
                          @"APP 开发",
                          @"微信公众号",
                          @"HTML5 应用",
                          @"其他"];
        NSInteger curRow = 0;
        if (_pro.projectTypeName) {
            curRow = [list indexOfObject:_pro.projectTypeName];
            curRow = curRow != NSNotFound? curRow: 0;
        }
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[list] initialSelection:@[@(curRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            weakSelf.pro.projectTypeName = selectedValue.firstObject;
            weakSelf.pro.projectType = @[@1,
                                         @2,
                                         @3,
                                         @4,
                                         @5][[(NSNumber *)selectedIndex.firstObject integerValue]];
        } cancelBlock:nil origin:self.view];
    }else if (indexPath.row == 3){
        ProjectIndustryListViewController *vc = [ProjectIndustryListViewController vcInStoryboard:@"UserInfo"];
        vc.skillPro = _pro;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
