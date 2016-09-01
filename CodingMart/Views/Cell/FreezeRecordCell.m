//
//  FreezeRecordCell.m
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FreezeRecordCell.h"
#import "NSDate+Helper.h"

@interface FreezeRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UILabel *dataL;

@property (weak, nonatomic) IBOutlet UILabel *amountL;
@end

@implementation FreezeRecordCell

- (void)setRecord:(FreezeRecord *)record{
    _record = record;
    _sourceL.text = _record.source;
    _amountL.text = _record.amount;
    _dataL.text = [_record.createdAt stringWithFormat:@"yyyy-MM-dd"];
}

+ (CGFloat)cellHeight{
    return 75;
}
@end
