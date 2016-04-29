//
//  RewardPrivateFileCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateFileCell.h"

@interface RewardPrivateFileCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation RewardPrivateFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurFile:(MartFile *)curFile{
    if (![curFile isKindOfClass:[MartFile class]]) {
        _nameL.text = @"未知文件";
        return;
    }
    _curFile = curFile;
    _nameL.text = _curFile.filename;
}

+ (CGFloat)cellHeight{
    return 56;
}

@end
