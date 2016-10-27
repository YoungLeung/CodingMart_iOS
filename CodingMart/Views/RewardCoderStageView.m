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
@property (weak, nonatomic) IBOutlet UILabel *planDateL;
@property (weak, nonatomic) IBOutlet UILabel *planDaysL;
@property (weak, nonatomic) IBOutlet UILabel *factDateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *payedL;


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
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation RewardCoderStageView

+ (instancetype)viewWithStage:(RewardMetroRoleStage *)stage{
    RewardCoderStageView *view = [[[NSBundle mainBundle] loadNibNamed:@"RewardCoderStageView" owner:self options:nil] objectAtIndex:stage.isMpay? 0: 1];
    view.curStage = stage;
    return view;
}

- (void)setCurStage:(RewardMetroRoleStage *)curStage{
    _curStage = curStage;
    WEAKSELF;
    _headerV.backgroundColor = [UIColor colorWithHexString:![_curStage isFinished]? @"0x4289DB": @"0xC9D6E5"];
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
    BOOL isRewardOwner = _curStage.isRewardOwner;
    BOOL isStageOwner = _curStage.isStageOwner;
    
    _descriptionL.text = _curStage.stage_task;
    _documentL.text = _curStage.stage_file_desc;
    _planDateL.text = _curStage.isMpay? [NSString stringWithFormat:@"%@ - %@", _curStage.planStartAtFormat, _curStage.planFinishAtFormat]: _curStage.planFinishAtFormat;
    _planDaysL.text = _curStage.planDays.stringValue;
    _factDateL.text = [NSString stringWithFormat:@"%@ - %@", _curStage.factStartAtFormat.length > 0? _curStage.factStartAtFormat: @"", _curStage.factFinishAtFormat.length > 0? _curStage.factFinishAtFormat: @""];
    _priceL.text = (_curStage.isRewardOwner || _curStage.isStageOwner)? _curStage.format_price: @"￥--";
    _payedL.text = _curStage.payedText;
    
    static NSDictionary *statusColorDict;
    if (!statusColorDict) {
        statusColorDict = @{@1: @"0xF5A623",
                            @2: @"0xF5A623",
                            @3: @"0xF5A623",
                            @4: @"0x4289DB",
                            @5: @"0xE84D60",
                            @6: @"0xE84D60",
                            @7: @"0xE84D60"};
    }
    if (statusColorDict[_curStage.statusOrigin]) {
        _statusL.textColor = [UIColor colorWithHexString:statusColorDict[_curStage.statusOrigin]];
    }
    _statusL.text = _curStage.statusText;

    
    
    NSString *tipStr = nil;
    if ([_curStage needToPay]) {
        tipStr = isRewardOwner? @"支付后才能启动此阶段": isStageOwner? @"该阶段未支付，为保障您的利益，请在需求方支付当前阶段款后再进行阶段开发，请及时联系需求方": nil;
    }
    _statusTipL.text = tipStr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _statusTipBGV.image = [[UIImage imageNamed:_statusTipL.height > 20? @"reward_privete_tip_bg2": @"reward_privete_tip_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(_statusTipL.centerY + 5, 10, 5, 5)];
    });
    _statusTipV.hidden = !tipStr;
    
    _documentBtn.hidden = !(![_curStage isRejected] && _curStage.stage_file.length > 0);
    _reasonBtn.hidden = !([_curStage isRejected] && _curStage.modify_file.length > 0);;

    _payBtn.hidden = !([_curStage needToPay] && isRewardOwner);
    _submitBtn.hidden = ![_curStage canSubmitObj];
    _cancelBtn.hidden = !([_curStage canCancelObj] && !isRewardOwner);
    _passBtn.hidden = _rejectBtn.hidden = ![_curStage canAcceptAndRejectObj];
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
            if (stage.isMpay) {
                if ([stage canSubmitObj] || [stage canCancelObj] || [stage canAcceptAndRejectObj]) {
                    height = 325 + 60;
                }else{
                    height = 325;
                }
            }else{
                height = 237;
            }
        }else{
            height = 35;
        }
    }
    return height;
}

@end
