//
//  EAProjectPrivatePhaseHolderCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivatePhaseHolderCell.h"

@interface EAProjectPrivatePhaseHolderCell ()
@property (weak, nonatomic) IBOutlet UILabel *tipContentL;
@property (weak, nonatomic) IBOutlet UILabel *tipBottomL;

@end

@implementation EAProjectPrivatePhaseHolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (void)setProM:(EAProjectModel *)proM{
    _proM = proM;
    _tipContentL.text = _proM.ownerIsMe? @"开发者暂时未提交阶段划分，请尽快联系开发者沟通具体需求与开发计划。": @"恭喜，你已经成为本项目的开发者。请你与需求方沟通具体要求，并尽快建立阶段划分。";
    _tipBottomL.hidden = _proM.ownerIsMe;
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 200;
    return size;
}

@end
