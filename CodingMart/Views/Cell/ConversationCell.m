//
//  ConversationCell.m
//  CodingMart
//
//  Created by Ease on 2017/3/10.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "ConversationCell.h"

@interface ConversationCell ()
@property (strong, nonatomic) UIImageView *userIconView;
@property (strong, nonatomic) UILabel *name, *msg, *time;

@end

@implementation ConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, ([ConversationCell cellHeight]-48)/2, 48, 48)];
            [_userIconView doCircleFrame];
            [self.contentView addSubview:_userIconView];
        }
        if (!_name) {
            _name = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 150, 25)];
            _name.font = [UIFont systemFontOfSize:17];
            _name.textColor = kColorText22;
            _name.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_name];
        }
        if (!_time) {
            _time = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 100-kPaddingLeftWidth, 8, 100, 25)];
            _time.font = [UIFont systemFontOfSize:12];
            _time.textColor = kColorTextLight99;
            _time.textAlignment = NSTextAlignmentRight;
            _time.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_time];
        }
        if (!_msg) {
            _msg = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, kScreen_Width-75-30 -kPaddingLeftWidth, 25)];
            _msg.font = [UIFont systemFontOfSize:15];
            _msg.backgroundColor = [UIColor clearColor];
            _msg.textColor = kColorTextLight99;
            [self.contentView addSubview:_msg];
        }
    }
    return self;
}

- (void)setCurConversation:(EAConversation *)curConversation{
    _curConversation = curConversation;
    if (!_curConversation) {
        return;
    }
    [_userIconView sd_setImageWithURL:[_curConversation.icon urlImageWithCodePathResize:2 * 50] placeholderImage:[UIImage imageNamed:_curConversation.isTribe? @"messageGroup": @"placeholder_user"]];
    _name.text = _curConversation.nick;
//    _msg.text = [_curConversation isTribe]? _curConversation.contact.desc: [_curConversation.lastMsg hasMedia]? @"[图片]": _curConversation.lastMsg.content;
    _msg.text = [_curConversation.lastMsg hasMedia]? @"[图片]": _curConversation.lastMsg.content;
    _time.text = [_curConversation.lastMsg.timMsg.timestamp stringDisplay_MMdd];
    NSInteger unReadNum = [_curConversation.timCon getUnReadMessageNum];
    NSString *badgeTip = unReadNum > 99? @"99+": unReadNum > 0? [NSString stringWithFormat:@"%@", @(unReadNum)]: @"";
    [self.contentView addBadgeTip:badgeTip withCenterPosition:CGPointMake(kScreen_Width-25, CGRectGetMaxY(_time.frame) +10)];
}

+ (CGFloat)cellHeight{
    return 61;
}
@end
