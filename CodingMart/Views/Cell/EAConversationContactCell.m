//
//  EAConversationContactCell.m
//  CodingMart
//
//  Created by Ease on 2017/3/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAConversationContactCell.h"

@interface EAConversationContactCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation EAConversationContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_iconV doBorderWidth:.5 color:nil cornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurContact:(EAChatContact *)curContact{
    _curContact = curContact;
    
    [_iconV sd_setImageWithURL:[_curContact.icon urlImageWithCodePathResize:2 * 40] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _nameL.text = _curContact.nick;
}

+ (CGFloat)cellHeight{
    return 60;
}
@end
