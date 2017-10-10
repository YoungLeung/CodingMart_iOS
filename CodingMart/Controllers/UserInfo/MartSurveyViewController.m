//
//  MartSurveyViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_SurveyTipCell_Error @"SurveyTipCell_Error"
#define kCellIdentifier_SurveyTipCell_Passed @"SurveyTipCell_Passed"
#define kCellIdentifier_SurveyTipCell_Tip @"SurveyTipCell_Tip"


#import "MartSurveyViewController.h"
#import "SurveyQuestionCell.h"
#import "Coding_NetAPIManager.h"

@interface MartSurveyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomV;

@end

@implementation MartSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshUI];
}

- (void)refreshUI{
    [_myTableView reloadData];
    [_bottomBtn setTitle:_survey.isAnswering? @"提交": @"重新答题" forState:UIControlStateNormal];
    _bottomV.hidden = _bottomBtn.hidden = _survey.isPassed;
    _myTableView.contentInset = UIEdgeInsetsMake(0, 0, _survey.isPassed? -_bottomV.height: 0, 0);
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0? 2:
            _survey.questions.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0? _survey.isPassed? kCellIdentifier_SurveyTipCell_Passed: kCellIdentifier_SurveyTipCell_Error: kCellIdentifier_SurveyTipCell_Tip forIndexPath:indexPath];
        if (indexPath.row == 0 && !_survey.isPassed) {
            UILabel *tipL = [cell.contentView viewWithTag:100];
            tipL.text = [NSString stringWithFormat:@"您有 %@ 个问题回答错误，请找到回答错误的问题并查看正确答案，然后重新答题。", _survey.score.wrong];
        }
        return cell;
    }else{
        SurveyQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SurveyQuestionCell forIndexPath:indexPath];
        [cell setQuestion:_survey.questions[indexPath.row] isAnswering:_survey.isAnswering];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && _survey.isAnswering) {
            cellHeight = 0;
        }else{
            NSString *tipStr = indexPath.row == 0? _survey.isPassed? @"您已经通过本次秘笈测试，马上开始报名码市的项目吧！": [NSString stringWithFormat:@"您有 %@ 个问题回答错误，请找到回答错误的问题并查看正确答案，然后重新答题。", _survey.score.wrong]: @"测试中所指的「开发者」包括：产品经理、项目顾问、UI 设计师、软件工程师、测试工程师。「开发者」是个统称。";
            UIFont *font = [UIFont systemFontOfSize:indexPath.row == 0? 14: 13];
            CGFloat offsetY = indexPath.row == 0? 20: 35;
            cellHeight = [tipStr getHeightWithFont:font constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)] + offsetY;
        }
    }else{
        cellHeight = [SurveyQuestionCell cellHeightWithObj:_survey.questions[indexPath.row] isAnswering:_survey.isAnswering];
    }
    return cellHeight;
}

#pragma mark Action
- (IBAction)bottomBtnClicked:(id)sender {
    if (!_survey.isAnswering) {
        _survey.isAnswering = YES;
        [self refreshUI];
    }else if (![_survey isAllAnswered]){
        [NSObject showHudTipStr:@"请完成所有答题"];
    }else{
        WEAKSELF
        [NSObject showHUDQueryStr:@"请稍等..."];
        [[Coding_NetAPIManager sharedManager] post_MartSurvey:_survey block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                weakSelf.survey = data;
                if (weakSelf.survey.isPassed) {
                    [NSObject showHudTipStr:@"您已经通过本次秘笈测试"];
                }
                [weakSelf refreshUI];
            }
        }];
    }
}


@end
