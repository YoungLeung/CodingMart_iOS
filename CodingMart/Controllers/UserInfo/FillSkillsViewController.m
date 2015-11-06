//
//  FillSkillsViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillSkillsViewController.h"
#import "TableViewFooterButton.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EAMultiSelectView.h"
#import "Coding_NetAPIManager.h"
#import "UIPlaceHolderTextView.h"
#import "ActionSheetStringPicker.h"

@interface FillSkillsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *work_typeF;
@property (weak, nonatomic) IBOutlet UITextField *skillF;
@property (weak, nonatomic) IBOutlet UITextField *specialtyF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *work_expT;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *project_expT;
@property (weak, nonatomic) IBOutlet UITextField *first_linkF;
@property (weak, nonatomic) IBOutlet UITextField *second_linkF;
@property (weak, nonatomic) IBOutlet UITextField *third_linkF;
@property (weak, nonatomic) IBOutlet UITextField *current_jobF;
@property (weak, nonatomic) IBOutlet UITextField *career_yearsF;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;

@end



@implementation FillSkillsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"技能展示";
    [self p_setupEvents];
    [self refresh];
}
- (void)p_setupEvents{
    __weak typeof(self) weakSelf = self;
    [_specialtyF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.specialty = newText;
    }];
    [_work_expT.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.work_exp = newText;
    }];
    [_project_expT.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.project_exp = newText;
    }];
    [_first_linkF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.first_link = newText;
    }];
    [_second_linkF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.second_link= newText;
    }];
    [_third_linkF.rac_textSignal subscribeNext:^(NSString *newText){
        weakSelf.skills.third_link= newText;
    }];
    [RACObserve(self, skills.current_job) subscribeNext:^(NSNumber *obj) {
        weakSelf.current_jobF.text = [NSObject currentJobList][obj.integerValue];
    }];
    [RACObserve(self, skills.career_years) subscribeNext:^(NSNumber *obj) {
        weakSelf.career_yearsF.text = [NSObject careerYearsList][obj.integerValue];
    }];
    RAC(self, submitBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, skills.work_type_string),
                                                              RACObserve(self, skills.skill),
                                                              RACObserve(self, skills.work_exp),
                                                              RACObserve(self, skills.project_exp),
                                                              RACObserve(self, skills.current_job),
                                                              RACObserve(self, skills.career_years),
                                                              ] reduce:^id{
                                                                  return @([weakSelf.skills canPost]);
                                                              }];
}
- (void)refresh{
    self.skills = nil;
    [self.view beginLoading];
    [[Coding_NetAPIManager sharedManager] get_FillSkillsBlock:^(id data, NSError *error) {
        [self.view endLoading];
        self.skills = data? data: [FillSkills new];
    }];
}

- (void)setSkills:(FillSkills *)skills{
    _skills = skills;
    _work_typeF.text = _skills.work_type_string;
    _skillF.text = _skills.skill;
    _specialtyF.text = _skills.specialty;
    _work_expT.text = _skills.work_exp;
    _project_expT.text = _skills.project_exp;
    _first_linkF.text = _skills.first_link;
    _second_linkF.text = _skills.second_link;
    _third_linkF.text = _skills.third_link;
    
    _submitBtn.hidden = (_skills == nil);
    [self.tableView reloadData];
}

#pragma mark Btn
- (IBAction)submitBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"正在保存技能展示..."];
    [[Coding_NetAPIManager sharedManager] post_FillSkills:_skills block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"技能展示保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)showWorkExp:(id)sender {
    NSString *tipStr =
    @"【示例】\n\
    工作经历\n\
    公司名称：某某公司\n\
    职位名称：系统测试工程师\n\
    在职时间：2011.6-2015.4\n\
    岗位职责：负责公司分流器产品的功能测试、性能测试和现场应用测试等。\n\
    \n\
    公司名称：Coding\n\
    职位名称：项目经理\n\
    在职时间：2015.8至今\n\
    岗位职责：Coding码市v2版本测试和码市悬赏项目的跟进管理。";
    [self showTipStr:tipStr];
}
- (IBAction)showProjectExp:(id)sender {
    NSString *tipStr =
    @"【示例】\n\
    项目名称：IOS 端应用 —— Coding\n\
    项目周期：2014 年 8 月 - 2015 年 8 月\n\
    项目描述：Coding 的手机客户端。可以随时随地的查看 https://coding.net\n\
    上的精彩项目、任务动态、项目文档、项目代码。还有冒泡、话题、私 信等一些轻社交功能。\n\
    开发工具：Xcode\n\
    \n\
    主要贡献：\n\
    完成了 App 第一版的开发和上线流程，有了基本的项目、任务、冒泡、消息几大模块。\n\
    后续又添加了文档管理，代码预览、消息推送、两步验证等功能。\n\
    期间一直负责该 App 的维护和优化工作，还负责部分外部悬赏功能的沟通协调工作。\n\
    \n\
    技术问题及解决方案：\n\
    API 中，冒泡、私信、通知等内容，都是 HTML 字符串，需要做一下处理，把各种类型的资源都分类提取出来之后再分情况显示。\n\
    冒泡、讨论等 md 格式的文本，使用 WebView 显示的模式。WebView 中有些链接是站内链接，所以需要对链接跳转做一个分析之后再做进一步处理：是站内链接的话，就新建一个相应的原生页面；非站内链接的话，就直接在 WebView 中完成跳转。";
    [self showTipStr:tipStr];
}

- (void)showTipStr:(NSString *)tipStr{
    if (tipStr.length <= 0) {
        return;
    }
    UIView *tipV = [[UIView alloc] initWithFrame:self.view.bounds];
    tipV.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    [tipV bk_whenTapped:^{
        [UIView animateWithDuration:0.3 animations:^{
            tipV.alpha = 0.0;
        } completion:^(BOOL finished) {
            [tipV removeFromSuperview];
            self.tableView.scrollEnabled = YES;
        }];
    }];
    UITextView *textV = [UITextView new];
    textV.backgroundColor = [UIColor clearColor];
    textV.editable = NO;
    textV.font = [UIFont systemFontOfSize:15];
    textV.textColor = [UIColor whiteColor];
    textV.text = tipStr;
    [RACObserve(textV, contentSize) subscribeNext:^(id x) {
        CGFloat diffY = MAX(0, (textV.size.height - textV.contentSize.height)/2);
        textV.contentInset = UIEdgeInsetsMake(diffY, 0, 0, 0);
    }];
    [tipV addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipV).insets(UIEdgeInsetsMake(0, 7, 0, 7));
    }];
    tipV.alpha = 0.0;
    
    [self.view addSubview:tipV];
    [UIView animateWithDuration:0.3 animations:^{
        tipV.alpha = 1.0;
        self.tableView.scrollEnabled = NO;
    }];
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _skills? 1: 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 3:
        case 4:
        case 6:
        case 7:
            cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);//隐藏掉它
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {//工作类型
        NSString *all_skill = @"Web 开发,后端开发,iOS 开发,Android 开发,需求分析,UI 设计";
        [EAMultiSelectView showInView:self.view
                            withTitle:@"选择能胜任的工作类型"
                             dataList:[all_skill componentsSeparatedByString:@","]
                         selectedList:[_skills.work_type_string componentsSeparatedByString:@","]
                      andConfirmBlock:^(NSArray *selectedList) {
                          weakSelf.skills.work_type_string = [selectedList componentsJoinedByString:@","];
                          weakSelf.work_typeF.text = weakSelf.skills.work_type_string;
                      }];
    }else if (indexPath.row == 1){//擅长技术
        NSString *all_work_type = @"Java,PHP,Ruby,Python,Go,C/C++,Objective-C,ASP.NET,C#,Perl,JavaScript,HTML/CSS,Android,iOS,Windows Phone,微信开发,网站开发,ERP/OA,即时通讯,端游开发,页游开发,手游开发,HTML5 游戏,算法,操作系统,编译器,硬件驱动,搜索技术,大数据,Docker,OpenStack,开源硬件";
        [EAMultiSelectView showInView:self.view withTitle:@"擅长的技术"
                             dataList:[all_work_type componentsSeparatedByString:@","]
                         selectedList:[_skills.skill componentsSeparatedByString:@","]
                      andConfirmBlock:^(NSArray *selectedList) {
                          weakSelf.skills.skill = [selectedList componentsJoinedByString:@","];
                          weakSelf.skillF.text = weakSelf.skills.skill;
                      }];
    }else if (indexPath.row == 6){//工作现状
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[NSObject currentJobList]] initialSelection:@[@(_skills.current_job.integerValue)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            weakSelf.skills.current_job = selectedIndex.firstObject;
        } cancelBlock:nil origin:self.view];
    }else if (indexPath.row == 7){//工作年限
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[NSObject careerYearsList]] initialSelection:@[@(_skills.career_years.integerValue)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            weakSelf.skills.career_years = selectedIndex.firstObject;
        } cancelBlock:nil origin:self.view];
    }
}
@end
