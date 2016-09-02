//
//  RewardPrivateBasicInfoCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateBasicInfoCell.h"
#import "UITTTAttributedLabel.h"

@interface RewardPrivateBasicInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *budgetL;
@property (weak, nonatomic) IBOutlet UILabel *demandStatusL;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *demandFileL;

@end

@implementation RewardPrivateBasicInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardP:(RewardPrivate *)rewardP{
    
    NSDictionary *budgetDict = @{@0: @"1万以下",
                                 @1: @"1-3万",
                                 @2: @"3-5万",
                                 @3: @"5万以上",
                                 @10:   @"2万以下",
                                 @11:  @"2-5万",
                                 @12:  @"5-10万",
                                 @13:  @"10万以上"};
    _rewardP = rewardP;
    _idL.text = rewardP.basicInfo.id.stringValue;
    _typeL.text = rewardP.basicInfo.typeDisplay;
    _budgetL.text = budgetDict[rewardP.basicInfo.budget] ?: @"未填写";
    MartFile *require_doc_file = _rewardP.basicInfo.require_doc_file;
    _demandStatusL.text = !require_doc_file? @"还未确定": @"已有文档";
    _demandFileL.text = !require_doc_file? @"无": require_doc_file.filename;

    if (require_doc_file) {
        WEAKSELF;
        [_demandFileL addLinkToStr:require_doc_file.filename value:require_doc_file hasUnderline:YES clickedBlock:^(id value) {
            if (weakSelf.fileClickedBlock) {
                weakSelf.fileClickedBlock(value);
            }
        }];
    }
}

+ (CGFloat)cellHeight{
    return 230;
}

@end
