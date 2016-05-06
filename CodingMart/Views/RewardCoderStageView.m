//
//  RewardCoderStageView.m
//  CodingMart
//
//  Created by Ease on 16/4/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardCoderStageView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface RewardCoderStageView ()
@property (weak, nonatomic) IBOutlet UIView *headerV;
@property (weak, nonatomic) IBOutlet UILabel *stage_noL;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UILabel *documentL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIView *statusTipV;
@property (weak, nonatomic) IBOutlet UIImageView *statusTipBGV;
@property (weak, nonatomic) IBOutlet UILabel *statusTipL;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@property (weak, nonatomic) IBOutlet UIButton *documentBtn;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@end

@implementation RewardCoderStageView

+ (instancetype)viewWithStage:(RewardMetroRoleStage *)stage{
    RewardCoderStageView *view = [[[NSBundle mainBundle] loadNibNamed:@"RewardCoderStageView" owner:self options:nil] firstObject];
    view.curStage = stage;
    return view;
}

- (void)setCurStage:(RewardMetroRoleStage *)curStage{
    _curStage = curStage;

    WEAKSELF;

    _headerV.backgroundColor = [UIColor colorWithHexString:_curStage.status.integerValue < 3? @"0x4289DB": @"0xC9D6E5"];
    _stage_noL.text = _curStage.stage_no;
    _arrowImageV.transform = CGAffineTransformMakeRotation(_curStage.isExpand? 0: M_PI);
    [_headerV bk_whenTapped:^{
        if (weakSelf.headerTappedBlock) {
            weakSelf.headerTappedBlock(weakSelf.curStage);
        }
    }];
    if (!_curStage.isExpand) {
        return;
    }
    _descriptionL.text = _curStage.stage_task;
    _documentL.text = _curStage.stage_file_desc;
    _dateL.text = _curStage.deadline;
    _priceL.text = _curStage.format_price;
    
    NSArray *statusDisplayList = @[@"待交付", @"待验收", @"验收未通过", @"已验收", @"已付款"];
    NSArray *statusColorList = @[@"0xF5A623", @"0xF5A623", @"0xE84D60", @"0x4289DB", @"0x4289DB"];
    NSInteger status = _curStage.status.integerValue;
    _statusL.text = statusDisplayList.count > status? statusDisplayList[status]: @"未知";
    if (statusColorList.count > status) {
        _statusL.textColor = [UIColor colorWithHexString:statusColorList[status]];
    }
    
    NSString *tipStr = nil;
    NSString *leftTimeStr;
    
    NSTimeInterval deadline_check_timestamp = _curStage.deadline_check_timestamp.doubleValue;
    if (deadline_check_timestamp < 259200000.0* 10) {//30 天
        deadline_check_timestamp += _curStage.deadline_timestamp.doubleValue;
    }
    NSTimeInterval left_timestamp = deadline_check_timestamp - [NSDate date].timeIntervalSince1970;
    NSInteger day = floor(left_timestamp / 24);
    NSInteger hour = (NSInteger)left_timestamp % 24;
    leftTimeStr = day > 0? [NSString stringWithFormat:@"%ld 天 %ld 小时", (long)day, (long)hour]: [NSString stringWithFormat:@"%ld 小时", (long)hour];
    if (_curStage.isRewardOwner) {
        if (status == 1) {
            tipStr = [NSString stringWithFormat:@"还剩 %@", leftTimeStr];
        }
    }else{
        if (status == 0) {
            tipStr = [NSString stringWithFormat:@"还剩 %@", leftTimeStr];
        }else if (status == 2){
            tipStr = [NSString stringWithFormat:@"再次提交还剩 %@", leftTimeStr];
        }else if (status == 3){
            tipStr = @"该阶段款项将会在3天内到账";
        }
    }
    _statusTipBGV.image = [[UIImage imageNamed:@"reward_privete_tip_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    _statusTipL.text = tipStr;
    _statusTipV.hidden = !tipStr;
    
    
    _documentBtn.hidden = !(status != 2 && _curStage.stage_file.length > 0);
    _reasonBtn.hidden = !(status == 2 && _curStage.modify_file.length > 0);;
    _submitBtn.hidden = !(!_curStage.isRewardOwner && (status == 0 || status == 2));;
    _cancelBtn.hidden = !(!_curStage.isRewardOwner && status == 1);
    _passBtn.hidden = _rejectBtn.hidden = !(_curStage.isRewardOwner && status == 1);
    _bottomLineV.hidden = _submitBtn.hidden && _cancelBtn.hidden && _passBtn.hidden && _rejectBtn.hidden;
}

- (IBAction)actionBtnClicked:(UIButton *)sender {
    if (_buttonBlock) {
        _buttonBlock(_curStage, sender.tag);
    }
}

+ (CGFloat)heightWithObj:(id)obj{
    CGFloat height = 0;
    if ([obj isKindOfClass:[RewardMetroRoleStage class]]) {
        RewardMetroRoleStage *stage = obj;
        if (stage.isExpand) {
            NSInteger status = stage.status.integerValue;
            BOOL isRewardOwner = stage.isRewardOwner;
            if ((isRewardOwner && status == 1) ||//通过、拒绝
                (!isRewardOwner && (status == 0 || status == 1 || status == 2))) {//提交、撤销提交
                height = 290;
            }else{
                height = 230;
            }
        }else{
            height = 35;
        }
    }
    return height;
}

@end
