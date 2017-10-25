//
//  EAProjectPrivateApplyCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateApplyCell.h"

@interface EAProjectPrivateApplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *markedV;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *messageL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UILabel *evaluationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIView *evaluationV;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *symbolV;

@property (strong, nonatomic) HCSStarRatingView *myRatingView;
@end

@implementation EAProjectPrivateApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
    _myRatingView = [_evaluationV makeRatingViewWithSmallStyle:YES];
}

- (void)setApplyM:(EAApplyModel *)applyM{
    _applyM = applyM;
    _markedV.hidden = !_applyM.marked.boolValue;
    [_iconV sd_setImageWithURL:[_applyM.user.avatar urlImageWithCodePathResizeToView:_iconV] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _nameL.text = _applyM.user.name;
    _timeL.text = [_applyM.createdAt stringTimesAgo];
    _messageL.text = _applyM.message;
    _infoL.text = [NSString stringWithFormat:@"%@ | %@", (_applyM.user.isDeveloperTeam? @"团队开发者": @"个人开发者"), _applyM.user.freeTime_Display];
    _evaluationL.text = _applyM.user.evaluation.stringValue;
    NSDictionary *statusTextDict = @{@"CHECKING": @"审核中",
                                     @"REJECTED": @"已拒绝",
                                     @"CANCELED": @"已取消"};
    NSDictionary *statusColorDict = @{@"CHECKING": @"0xEBBA59",
                                      @"REJECTED": @"0xDB5858",
                                      @"CANCELED": @"0x8796A8"};
    _statusL.text = statusTextDict[_applyM.status];
    _statusL.textColor = [UIColor colorWithHexString:statusColorDict[_applyM.status]];
    self.myRatingView.value = _applyM.user.evaluation.floatValue;
    if (_applyM.user.isDeveloperTeam) {//团队
        for (NSInteger index = 0; index < _symbolV.count; index++) {
            UIImageView *tempV = _symbolV[index];
            if (index == 0) {
                tempV.image = [UIImage imageNamed:[NSString stringWithFormat:@"team_vip_%@", _applyM.user.vipType ?: @"NOT_VIP"]];
            }
            tempV.hidden = index != 0;
        }
    }else{//个人
        NSInteger index = 0;
        UIImageView *tempV = _symbolV[index];
        tempV.hidden = YES;
        index++;
        if (_applyM.user.isDeveloperRenZheng) {
            tempV = _symbolV[index];
            tempV.image = [UIImage imageNamed:@"developer_renzheng"];
            tempV.hidden = NO;
            index++;
        }
        if (_applyM.user.isYouXuan) {
            tempV = _symbolV[index];
            tempV.image = [UIImage imageNamed:@"developer_youxuan"];
            tempV.hidden = NO;
            index++;
        }
        if (_applyM.user.isBaoZhengJin) {
            tempV = _symbolV[index];
            tempV.image = [UIImage imageNamed:@"developer_baozhengjin"];
            tempV.hidden = NO;
            index++;
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 125;
    return size;
}

@end

//{
//    "id": 6731,
//    "userId": 500012,
//    "rewardId": 3184,
//    "status": "PASSED",
//    "secret": "CHECKED",
//    "message": "ddddddddddddddddddddd",
//    "marked": true,
//    "remark": "dfdf",
//    "createdAt": "1508143360000",
//    "updatedAt": "1508207294000",
//    "goodAt": "PHP,",
//    "user": {...},
//    "reward": {...},
//    "roleTypeName": "iOS开发"
//}
