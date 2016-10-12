//
//  ProjectIndustryCellTableViewCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ProjectIndustryCell.h"

@interface ProjectIndustryCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation ProjectIndustryCell

- (void)setProIndustry:(ProjectIndustry *)proIndustry{
    _proIndustry = proIndustry;
    _nameL.text = proIndustry.name;
}

- (void)setIsChoosed:(BOOL)isChoosed{
    _isChoosed = isChoosed;
    self.accessoryType = _isChoosed? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
}
@end
