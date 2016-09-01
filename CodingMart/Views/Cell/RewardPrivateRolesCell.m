//
//  RewardPrivateRolesCell.m
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateRolesCell.h"

@interface RewardPrivateRolesCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *demandL;
@end

@implementation RewardPrivateRolesCell

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    
    _typeL.attributedText = [self typeAttrStr];
    _priceL.attributedText = [self priceAttrStr];
    _demandL.text = _rewardP.basicInfo.rewardDemand;
}

- (NSAttributedString *)typeAttrStr{
    if (_rewardP.basicInfo.roles.count <= 0) {
        return nil;
    }
    NSArray *valueList = [_rewardP.basicInfo.roles valueForKey:@"name"];
    NSString *typeStr = [valueList componentsJoinedByString:@"\n"];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.minimumLineHeight = 25;
    style.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:typeStr attributes:@{NSParagraphStyleAttributeName: style, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
    return attrStr;
}

- (NSAttributedString *)priceAttrStr{
    if (_rewardP.basicInfo.roles.count <= 0) {
        return nil;
    }
    NSArray *valueList = [_rewardP.basicInfo.roles valueForKey:@"totalPrice"];
    NSString *priceStr = [valueList componentsJoinedByString:@" 元\n"];
    priceStr = [priceStr stringByAppendingString:@" 元"];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.minimumLineHeight = 25;
    style.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr attributes:@{NSParagraphStyleAttributeName: style, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
    
    NSUInteger startLoc = 0;
    for (int index = 0; index < valueList.count; index++) {
        NSRange diffColorRange = [priceStr rangeOfString:[valueList[index] description] options:NSLiteralSearch range:NSMakeRange(startLoc, priceStr.length - startLoc)];
        if (diffColorRange.location != NSNotFound) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xF5A623"] range:diffColorRange];
            startLoc = diffColorRange.location + diffColorRange.length;
        }
    }
    return attrStr;
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        CGFloat contentWidth = kScreen_Width - 15* 2 - 15 - 30;
        cellHeight += 45;
        cellHeight += 15 + 18 + 5 + rewardP.basicInfo.roles.count * 25 + 15;
        cellHeight += 18 + 5 + [rewardP.basicInfo.rewardDemand getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)] + 15 + 15;
    }
    return cellHeight;
}
@end
