//
//  ActivityListCell.m
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ActivityListCell.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "NSDate+Helper.h"

@interface ActivityListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userV;
@property (weak, nonatomic) IBOutlet UIImageView *lineUpV;
@property (weak, nonatomic) IBOutlet UIImageView *lineDownV;
@property (weak, nonatomic) IBOutlet UIImageView *lineIconV;
@property (weak, nonatomic) IBOutlet UIImageView *bgV;
@property (weak, nonatomic) IBOutlet UILabel *userL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) Activity *curActivity;
@end

@implementation ActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WEAKSELF;
    void (^userBlock)() = ^(){
        if (weakSelf.userBlock) {
            weakSelf.userBlock(weakSelf.curActivity.user);
        }
    };
    [_userV bk_whenTapped:userBlock];
    [_userL bk_whenTapped:userBlock];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithActivity:(Activity *)curActivity haveRead:(BOOL)haveRead isTop:(BOOL)top isBottom:(BOOL)bottom{
    _curActivity = curActivity;
    
    [_userV sd_setImageWithURL:[_curActivity.user.avatar urlImageWithCodePathResize:60] placeholderImage:nil];
    _lineUpV.hidden = top;
    _lineDownV.hidden = bottom;
    _lineIconV.image = [UIImage imageNamed:haveRead? @"activity_read": @"activity_unread"];
    _userL.text = _curActivity.user.name;
    _contentL.text = _curActivity.action_msg;
    _timeL.text = [_curActivity.activity.created_at stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[Activity class]]) {
        Activity *curActivity = (Activity *)obj;
        cellHeight += [curActivity.action_msg getHeightWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake((kScreen_Width - 75 - 20) - 15 - 10, CGFLOAT_MAX)];
        cellHeight += 8* 2;
        cellHeight += 10+ 20+ 10+ 10;
    }
    return cellHeight;
}
@end
