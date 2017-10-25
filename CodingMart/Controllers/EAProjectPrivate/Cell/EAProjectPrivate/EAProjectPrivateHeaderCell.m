//
//  EAProjectPrivateHeaderCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateHeaderCell.h"

@implementation EAProjectPrivateHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 50;
    return size;
}

@end
