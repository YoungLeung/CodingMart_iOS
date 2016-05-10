//
//  RewardPrivateDetailCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateDetailCell.h"
#import "UITTTAttributedLabel.h"

@interface RewardPrivateDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *sampleL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *fileL;

@end

@implementation RewardPrivateDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    _descriptionL.text = _rewardP.basicInfo.format_contentMedia.contentDisplay;
    _durationL.text = [NSString stringWithFormat:@"%@ 天", _rewardP.basicInfo.duration.stringValue];
    
    NSString *sampleStr = _rewardP.basicInfo.first_sample;
    if (_rewardP.basicInfo.second_sample.length > 0) {
        if (sampleStr.length > 0) {
            sampleStr = [sampleStr stringByAppendingFormat:@", %@", _rewardP.basicInfo.second_sample];
        }else{
            sampleStr = _rewardP.basicInfo.second_sample;
        }
    }
    _sampleL.text = sampleStr.length > 0? sampleStr: @"无";
    
    NSString *fileStr = _rewardP.basicInfo.first_attach_file.filename;
    if (_rewardP.basicInfo.second_attach_file.filename.length > 0) {
        fileStr = [fileStr stringByAppendingFormat:@", %@", _rewardP.basicInfo.second_attach_file.filename];
    }else{
        fileStr = _rewardP.basicInfo.second_attach_file.filename;
    }
    _fileL.text = fileStr.length > 0? fileStr: @"无";
    [self p_addLinkToFile:_rewardP.basicInfo.first_attach_file];
    [self p_addLinkToFile:_rewardP.basicInfo.second_attach_file];
}

- (void)p_addLinkToFile:(MartFile *)file{
    WEAKSELF;
    if (file) {
        [_fileL addLinkToStr:file.filename value:file hasUnderline:YES clickedBlock:^(id value) {
            if (weakSelf.fileClickedBlock) {
                weakSelf.fileClickedBlock(value);
            }
        }];
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        CGFloat contentWidth = kScreen_Width - 15* 2 - 15* 2 - 70;
        CGFloat descriptionHeight = [rewardP.basicInfo.format_contentMedia.contentDisplay getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        descriptionHeight = MAX(descriptionHeight, 20);
        cellHeight = descriptionHeight + 180;
    }
    return cellHeight;
}

@end
