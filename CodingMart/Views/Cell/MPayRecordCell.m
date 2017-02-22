//
//  MPayActivityCell.m
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayRecordCell.h"
#import "NSDate+Helper.h"

@interface MPayRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation MPayRecordCell

static NSDictionary *statusNameDict;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrder:(MPayOrder *)order{
    if (!statusNameDict) {
        statusNameDict = @{@"UnknownStatus": @"未知状态",
                           @"Pending": @"正在处理",
                           @"Success": @"已完成",
                           @"Fail": @"处理失败",
                           @"Cancel": @"已取消",};
        
    }
    _order = order;
    
    _titleL.text = _order.title;
    _feeL.text = [NSString stringWithFormat:@"%@%@", _order.symbol, _order.totalFee];
    NSString *orderTypeName = _order.tradeType;
    if ([_order.orderType isEqualToString:@"WithDraw"]) {
        //TODO 这里有个「查看进度」按钮
    }else if ([_order.orderType isEqualToString:@"Refund"]){
        orderTypeName = ([_order.productType isEqualToString:@"Reward"]? @"项目订金退款":
                         [_order.productType isEqualToString:@"RewardStage"]? @"项目阶段退款": orderTypeName);
    }
    _typeL.text = orderTypeName;
    _statusL.text = statusNameDict[_order.status];
    _timeL.text = [_order.createdAt stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    return 90.0;
}

@end
