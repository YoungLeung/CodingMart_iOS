//
//  RewardPrivateCoderStagesCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateCoderStagesCell.h"

@interface RewardPrivateCoderStagesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *assistantL;
@property (strong, nonatomic) NSMutableArray *stageVList;
@end

@implementation RewardPrivateCoderStagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurRole:(RewardMetroRole *)curRole{
    _curRole = curRole;
    _titleL.text = [NSString stringWithFormat:@"%@（%@）", _curRole.role_name, _curRole.name];
    
    _priceL.text = [NSString stringWithFormat:@"总金额：￥%@", (_curRole.isRewardOwner || _curRole.isStageOwner)? _curRole.total_price.stringValue: @"--"];
    _assistantL.text = [NSString stringWithFormat:@"阶段监理：%@", _curRole.assistant_name];
    
    if (!_stageVList) {
        _stageVList = @[].mutableCopy;
    }else if (_stageVList.count > _curRole.stages.count){
        NSArray *needToRemoveList = [_stageVList subarrayWithRange:NSMakeRange(_curRole.stages.count, _stageVList.count - _curRole.stages.count)];
        [needToRemoveList makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_stageVList removeObjectsInArray:needToRemoveList];
    }
    
    WEAKSELF;
    CGFloat curBottom = 80;
    for (int index = 0; index < _curRole.stages.count; index++) {
        RewardMetroRoleStage *curStage = _curRole.stages[index];
        RewardCoderStageView *stageV;
        if (_stageVList.count > index) {
            stageV = _stageVList[index];
            stageV.curStage = curStage;
        }else{
            stageV = [RewardCoderStageView viewWithStage:curStage];
            [_stageVList addObject:stageV];
        }
        stageV.buttonBlock = ^(RewardMetroRoleStage *stage, RewardCoderStageViewAction actionIndex){
            if (weakSelf.buttonBlock) {
                weakSelf.buttonBlock(weakSelf.curRole, stage, actionIndex);
            }
        };
        stageV.headerTappedBlock = ^(RewardMetroRoleStage *stage){
            if (weakSelf.stageHeaderTappedBlock) {
                weakSelf.stageHeaderTappedBlock(weakSelf.curRole, stage);
            }
        };
        curBottom += 15;
        CGFloat stageHeight = [RewardCoderStageView heightWithObj:curStage];
        stageV.frame = CGRectMake(15, curBottom, kScreen_Width - 15* 2, stageHeight);
        [self.contentView addSubview:stageV];
        curBottom += stageHeight;
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardMetroRole class]]) {
        cellHeight = 80;
        
        RewardMetroRole *curRole = obj;
        for (RewardMetroRoleStage *stage in curRole.stages) {
            cellHeight += 15 + [RewardCoderStageView heightWithObj:stage];
        }
        cellHeight += 15;
    }
    return cellHeight;
}

@end
