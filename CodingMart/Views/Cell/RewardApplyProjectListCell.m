//
//  RewardApplyProjectListCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardApplyProjectListCell.h"
#import "NSDate+Helper.h"

@interface RewardApplyProjectListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation RewardApplyProjectListCell

- (void)setIsChoosed:(BOOL)isChoosed{
    self.accessoryType = isChoosed? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
}

- (void)setSkillPro:(SkillPro *)skillPro{
    _skillPro = skillPro;
    _nameL.text = _skillPro.project_name;
    _timeL.text = [NSString stringWithFormat:@"项目时间：%@ - %@", [_skillPro.start_time stringWithFormat:@"yyyy.MM"], _skillPro.until_now.boolValue? @"至今": [_skillPro.finish_time stringWithFormat:@"yyyy.MM"]];
}

+ (CGFloat)cellHeight{
    return 70;
}
@end
