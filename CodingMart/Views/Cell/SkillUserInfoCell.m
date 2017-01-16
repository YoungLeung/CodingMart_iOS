//
//  SkillUserInfoCell.m
//  CodingMart
//
//  Created by Ease on 16/8/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillUserInfoCell.h"
#import "ActionSheetStringPicker.h"

@interface SkillUserInfoCell ()
@property (weak, nonatomic) IBOutlet UITextField *freeTimeF;
@property (weak, nonatomic) IBOutlet UITextField *rewardRoleF;
@property (weak, nonatomic) IBOutlet UISwitch *acceptNewRewardAllNotificationSwitch;

@end

@implementation SkillUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserInfo:(FillUserInfo *)userInfo{
    _userInfo = userInfo;
    _freeTimeF.text = [_userInfo free_time_display];
    _rewardRoleF.text = [_userInfo reward_role_display];
    _acceptNewRewardAllNotificationSwitch.on = _userInfo.acceptNewRewardAllNotification.boolValue;
}

- (IBAction)acceptNewRewardAllNotificationSwitchValueChanged:(UISwitch *)sender {
    self.userInfo.acceptNewRewardAllNotification = @(sender.on);
    [self goToUpdateUserInfoFreeTime];
}

- (IBAction)roleBtnClicked:(id)sender {
    if (_updateUserInfoRoleBlock) {
        _updateUserInfoRoleBlock();
    }
//    WEAKSELF;
//    NSInteger initialRow = _userInfo.reward_role? _userInfo.reward_role.integerValue: 0;
//    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[FillUserInfo reward_role_display_list]] initialSelection:@[@(initialRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
//        weakSelf.userInfo.reward_role = selectedIndex.firstObject;
//        weakSelf.rewardRoleF.text = [weakSelf.userInfo reward_role_display];
//        [weakSelf goToUpdateUserInfoFreeTime];
//    } cancelBlock:nil origin:kKeyWindow];
}

- (IBAction)timeBtnClicked:(id)sender {
    WEAKSELF;
    NSInteger initialRow = _userInfo.free_time? _userInfo.free_time.integerValue: 0;
    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[FillUserInfo free_time_display_list]] initialSelection:@[@(initialRow)] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
        weakSelf.userInfo.free_time = selectedIndex.firstObject;
        weakSelf.freeTimeF.text = [weakSelf.userInfo free_time_display];
        [weakSelf goToUpdateUserInfoFreeTime];
    } cancelBlock:nil origin:kKeyWindow];
}

- (void)goToUpdateUserInfoFreeTime{
    if (_updateUserInfoFreeTimeBlock) {
        _updateUserInfoFreeTimeBlock(_userInfo);
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[FillUserInfo class]]) {
        FillUserInfo *info = obj;
        cellHeight = info.acceptNewRewardAllNotification.boolValue? 270: 175;
    }
    return cellHeight;
}
@end
