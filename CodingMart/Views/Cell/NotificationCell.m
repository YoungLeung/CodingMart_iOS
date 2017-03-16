//
//  NotificationCell.m
//  CodingMart
//
//  Created by Ease on 16/3/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "NotificationCell.h"
#import "NSDate+Helper.h"
#import "UITTTAttributedLabel.h"

@interface NotificationCell ()
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *contentMainL;
@property (weak, nonatomic) IBOutlet UILabel *contentResonL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *tipV;

@end

@implementation NotificationCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (void)setNotification:(MartNotification *)notification{
    _notification = notification;
    BOOL hasRead = _notification.status.boolValue;
    
    _contentMainL.textColor = [UIColor colorWithHexString:@"0x222222"];
    _contentResonL.textColor = [UIColor colorWithHexString:@"0x666666"];

//    _contentMainL.textColor = [UIColor colorWithHexString:hasRead? @"0x999999": @"0x222222"];
//    _contentResonL.textColor = [UIColor colorWithHexString:hasRead? @"0x999999": @"0x666666"];
    _contentMainL.text = _notification.contentMain;
    _contentResonL.text = _notification.contentReason;
    _timeL.text = [_notification.created_at stringWithFormat:@"yyyy-MM-dd HH:mm"];
    _tipV.hidden = hasRead;
    if (_notification.htmlMedia.mediaItems.count > 0) {
        __weak typeof(self) weakSelf = self;
        for (HtmlMediaItem *item in _notification.htmlMedia.mediaItems) {
            [_contentMainL addLinkToStr:item.displayStr value:item.href hasUnderline:NO clickedBlock:^(id value) {
                if (weakSelf.linkStrBlock) {
                    weakSelf.linkStrBlock(value);
                }
            }];
        }
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[MartNotification class]]) {
        MartNotification *notification = (MartNotification *)obj;
        cellHeight += notification.hasReason? 55: 50;
        CGFloat contentWidth = kScreen_Width - 15*2 - 8 - 8;
        cellHeight += [notification.contentMain getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        if (notification.contentReason.length > 0) {
            cellHeight += [notification.contentReason getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        }
    }
    return cellHeight;
}
@end
