//
//  EAProjectPhaseDetailCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/20.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPhaseDetailCell.h"
#import "EAProjectPhaseEvaluationViewController.h"

@interface EAProjectPhaseDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *phaseNoL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *planDeliveryAtL;
@property (weak, nonatomic) IBOutlet UILabel *actualDeliveryAtL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceL;
@property (weak, nonatomic) IBOutlet UILabel *deliveryNoteL;
@property (weak, nonatomic) IBOutlet UILabel *evaluationL;
@property (weak, nonatomic) IBOutlet UIView *evaluationV;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;

@property (weak, nonatomic) IBOutlet UILabel *actualDeliveryAtTitleL;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceTitleL;

@property (strong, nonatomic) HCSStarRatingView *myRatingView;
@end

@implementation EAProjectPhaseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
    _myRatingView = [_evaluationV makeRatingViewWithSmallStyle:YES];
}

- (void)setPhaM:(EAPhaseModel *)phaM{
    _phaM = phaM;
    _phaseNoL.text = [NSString stringWithFormat:@"%@ 阶段", _phaM.phaseNo];
    NSDictionary *statusTextDict = @{@"CREATE": @"未启动",
                                     @"UNPAID": @"未启动",
                                     @"DEVELOPING": @"开发中",
                                     @"TERMINATED": @"已中止",
                                     @"CHECKING": @"待验收",
                                     @"FINISHED": @"已验收",
                                     @"EDIT_ADD": @"未启动",
                                     @"CHECK_FAILED": @"验收未通过",
                                     };
    NSDictionary *statusColorDict = @{@"CREATE": @"0xDDE3EB",
                                      @"UNPAID": @"0xDDE3EB",
                                      @"DEVELOPING": @"0x4289DB",
                                      @"TERMINATED": @"0x979FA8",
                                      @"CHECKING": @"0xE3935D",
                                      @"FINISHED": @"0x61C279",
                                      @"EDIT_ADD": @"0xDDE3EB",
                                      @"CHECK_FAILED": @"0xE72511",
                                      };
    _statusL.text = statusTextDict[_phaM.status];
    _statusL.textColor = [UIColor colorWithHexString:statusColorDict[_phaM.status]];
    _nameL.text = _phaM.name;
    _planDeliveryAtL.text = [_phaM.planDeliveryAt string_yyyy_MM_dd];
    _actualDeliveryAtL.text = [_phaM.actualDeliveryAt string_yyyy_MM_dd];
    _priceL.text = [NSString stringWithFormat:@"￥%@", _phaM.price];
    _actualPriceL.text = [NSString stringWithFormat:@"￥%@", _phaM.actualPrice];
    _deliveryNoteL.text = _phaM.deliveryNote ?: @"无";
    _evaluationL.text = _phaM.evaluation.averageRate.stringValue ?: @"未评分";
    self.myRatingView.value = _phaM.evaluation.averageRate.floatValue;
    
    _actualDeliveryAtL.hidden = _actualDeliveryAtTitleL.hidden = (_phaM.actualDeliveryAt == nil);
    _actualPriceL.hidden = _actualPriceTitleL.hidden = (_phaM.actualPrice == nil);
    _evaluationBtn.hidden = ![@[@"FINISHED", @"TERMINATED"] containsObject:_phaM.status];
}
- (IBAction)evaluationBtnClicked:(id)sender {
    if (!_phaM.evaluation.averageRate) {
//        [NSObject showHudTipStr:@"还未评分"];
    }else{
        EAProjectPhaseEvaluationViewController *vc = [EAProjectPhaseEvaluationViewController vcInStoryboard:@"EAProjectPrivate"];
        vc.evaM = _phaM.evaluation;
        [[UIViewController presentingVC].navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat contentWidth = kScreen_Width - 30;
    size.height = 380;
    size.height +=MAX(0, [_nameL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_deliveryNoteL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    return size;
}
@end

