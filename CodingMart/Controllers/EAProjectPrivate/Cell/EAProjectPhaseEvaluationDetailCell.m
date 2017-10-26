//
//  EAProjectPhaseEvaluationDetailCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/20.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPhaseEvaluationDetailCell.h"

@interface EAProjectPhaseEvaluationDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *deliverabilityRateL;
@property (weak, nonatomic) IBOutlet UIView *deliverabilityRateV;
@property (weak, nonatomic) IBOutlet UILabel *deliverabilityRateContentL;

@property (weak, nonatomic) IBOutlet UILabel *communicationRateL;
@property (weak, nonatomic) IBOutlet UIView *communicationRateV;
@property (weak, nonatomic) IBOutlet UILabel *communicationRateContentL;

@property (weak, nonatomic) IBOutlet UILabel *responsibilityRateL;
@property (weak, nonatomic) IBOutlet UIView *responsibilityRateV;
@property (weak, nonatomic) IBOutlet UILabel *responsibilityRateContentL;

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (strong, nonatomic) HCSStarRatingView *deliverabilityRatingView, *communicationRatingView, *responsibilityRatingView;
@end

@implementation EAProjectPhaseEvaluationDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
    
    _deliverabilityRatingView = [_deliverabilityRateV makeRatingViewWithSmallStyle:NO];
    _communicationRatingView = [_communicationRateV makeRatingViewWithSmallStyle:NO];
    _responsibilityRatingView = [_responsibilityRateV makeRatingViewWithSmallStyle:NO];
}

- (void)setEvaM:(EAPhaseEvaluationModel *)evaM{
    _evaM = evaM;
    
    _deliverabilityRateL.text = _evaM.deliverabilityRate.stringValue;
    self.deliverabilityRatingView.value = _evaM.deliverabilityRate.floatValue;
    _deliverabilityRateContentL.text = [self p_deliverabilityContentDict][_evaM.deliverabilityRate];

    _communicationRateL.text = _evaM.communicationRate.stringValue;
    self.communicationRatingView.value = _evaM.communicationRate.floatValue;
    _communicationRateContentL.text = [self p_communicationContentDict][_evaM.communicationRate];

    _responsibilityRateL.text = _evaM.responsibilityRate.stringValue;
    self.responsibilityRatingView.value = _evaM.responsibilityRate.floatValue;
    _responsibilityRateContentL.text = [self p_responsibilityContentDict][_evaM.responsibilityRate];

    _contentL.text = _evaM.content ?: @"无";
}

- (NSDictionary *)p_deliverabilityContentDict{
    return @{
             @1: @"技术能力差，在其它开发者或客户的协助下也不能完成相应的工作，有耽误项目进度的情况或不得不找其它开发者替代",
             @2: @"技术能力较弱，需要在其它开发者或需求方的协助下进行项目工作，有延期和不满足功能需求的情况，但在和客户协调后，交付可接受",
             @3: @"技术能力一般，基本能够达到项目要求，需要需求方的持续推进下能够完成阶段任务，质量基本能满足要求",
             @4: @"技术能力良好，能够满足项目要求，在需求方的跟进和督促下能够在各阶段按时交付，质量达到功能要求",
             @5: @"技术能力强，完全胜任项目要求，思维严谨，能自我把控项目质量和进度，按时或提前高质量完成项目",
             };
}
- (NSDictionary *)p_communicationContentDict{
    return @{
             @1: @"较少沟通、不及时反馈，甚至在客户多次催促的情况下也不能给出回应，或表达方式过于强势、固执和不配合",
             @2: @"不会主动沟通，在客户催促下才能给出回应，在协同开发过程中不能较好地配合，出现问题不及时提出",
             @3: @"沟通能力尚可，能对客户的意见和建议进行反馈和调整",
             @4: @"良好的沟通能力，能较好地配合客户方协同开发，遇到问题主动及时反馈，倾听客户意见并根据实际情况做出调整和回应",
             @5: @"出色的沟通能力，能主导与客户方的协作并主动推进项目，表达个人观点合理到位，在遇到研发过程中的矛盾甚至纠纷时能积极主动协调并较好地化解",
             };
    
}
- (NSDictionary *)p_responsibilityContentDict{
    return @{
             @1: @"实际能力与个人申请的描述严重不符，有蓄意编造的作假部分，承受不了压力，故意拖延，对于隐患，不主动暴露问题，敷衍了事，爱找借口，逃避责任",
             @2: @"实际能力与个人申请的描述不符，有较多夸大成分，遇到压力容易放弃，不催促就不会按时提交阶段成果，懒惰爱拖延",
             @3: @"实际能力与个人申请的描述有一定夸大成分，但尚可接受，抗压能力一般，能按照规定和规范履行责任",
             @4: @"实际能力与个人申请的描述基本一致，能承受一定的工作压力，目标导向，能尽最大努力完成预期目标",
             @5: @"诚实守信，实际能力与个人申请的描述相符，能承受较强的工作压力，对于潜在可能发生的问题能够较早提出并寻求解决方案，不回避问题，对承诺的事情能够积极兑现，出色完成预期目标",
             };
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat contentWidth = kScreen_Width - 30;
    size.height = 310;
    size.height +=MAX(0, [_deliverabilityRateContentL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_communicationRateContentL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_responsibilityRateContentL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    size.height +=MAX(0, [_contentL sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height - 20);
    return size;
}
@end
