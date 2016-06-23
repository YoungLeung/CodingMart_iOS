//
//  RewardDetailHeaderView.m
//  CodingMart
//
//  Created by Ease on 16/5/24.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardDetailHeaderView.h"


@interface RewardDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgV;

@end

@implementation RewardDetailHeaderView
+ (instancetype)viewWithReward:(Reward *)reward{
    RewardDetailHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"RewardDetailHeaderView" owner:self options:nil] firstObject];
    [view setWidth:kScreen_Width];
    view.curReward = reward;
    return view;
}


- (void)setCurReward:(Reward *)curReward{
    _curReward = curReward;
    [_curReward prepareToDisplay];
    
    _nameL.text = _curReward.name;
    _idL.text = [NSString stringWithFormat:@" No.%@  ", _curReward.id.stringValue];
    _roleTypesL.text = _curReward.roleTypesDisplay;
    UIColor *diffColor = [UIColor colorWithHexString:@"0xF5A623"];
    [_priceL setAttrStrWithStr:[NSString stringWithFormat:@"金额：%@", _curReward.format_price] diffColorStr:_curReward.format_price diffColor:diffColor];
    [_typeL setAttrStrWithStr:[NSString stringWithFormat:@"类型：%@", _curReward.typeDisplay] diffColorStr:_curReward.typeDisplay diffColor:diffColor];
    [_durationL setAttrStrWithStr:[NSString stringWithFormat:@"周期：%@ 天", _curReward.duration.stringValue] diffColorStr:_curReward.duration.stringValue diffColor:diffColor];
    _statusImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"status_%@", _curReward.status.stringValue]];
}

@end
