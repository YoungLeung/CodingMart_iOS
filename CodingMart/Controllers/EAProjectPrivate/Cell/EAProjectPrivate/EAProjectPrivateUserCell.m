//
//  EAProjectPrivateUserCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateUserCell.h"

@interface EAProjectPrivateUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;

@end

@implementation EAProjectPrivateUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (void)setProM:(EAProjectModel *)proM{
    _proM = proM;
    BOOL ownerIsMe = _proM.ownerIsMe;
    User *curUser = ownerIsMe? _proM.applyer.user: _proM.owner;
    [_iconV sd_setImageWithURL:[curUser.avatar urlImageWithCodePathResizeToView:_iconV] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _nameL.text = curUser.name;
    _typeL.text = ownerIsMe? @"开发者": @"需求方";
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 60;
    return size;
}

@end
