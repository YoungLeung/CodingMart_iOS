//
//  EAProjectUserContactCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/20.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectUserContactCell.h"

@interface EAProjectUserContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *qqL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;

@end

@implementation EAProjectUserContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurUser:(User *)curUser{
    _curUser = curUser;
    _phoneL.text = _curUser.phone ?: @"无";
    _qqL.text = _curUser.qq ?: @"无";
    _emailL.text = _curUser.email ?: @"无";
}

@end

