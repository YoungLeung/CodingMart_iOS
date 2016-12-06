//
//  MPayOrderPayCell.m
//  CodingMart
//
//  Created by Ease on 2016/11/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrderPayCell.h"

@interface MPayOrderPayCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeL;
@end

@implementation MPayOrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurOrder:(MPayOrder *)curOrder{
    _curOrder = curOrder;
    _orderIdL.text = _curOrder.orderId;
    _titleL.text = _curOrder.name;
    _totalFeeL.text = [NSString stringWithFormat:@"￥%@", _curOrder.totalFee];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[MPayOrder class]]) {
        MPayOrder *mPayOrder = (MPayOrder *)obj;
        CGFloat contentW = kScreen_Width - 15* 2 - 70 - 10;
        CGFloat contentH = [mPayOrder.name getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, CGFLOAT_MAX)];
        contentH = MAX(contentH, 20);
        cellHeight += (44 * 3 - 20) + contentH;
    }
    return cellHeight;
}
@end
