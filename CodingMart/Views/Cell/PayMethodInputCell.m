//
//  PayMethodInputCell.m
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodInputCell.h"

@interface PayMethodInputCell ()<UITextFieldDelegate>

@end

@implementation PayMethodInputCell

- (void)awakeFromNib {
    // Initialization code
    _textF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)cellHeight{
    return 44.0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length <= 0) {
        return YES;
    }
    
    BOOL shouldChange = YES;
    NSInteger textLength = textField.text.length;
    BOOL stringIsDot = [string isEqualToString:@"."];
    
    NSRange dotRange = [textField.text rangeOfString:@"."];
    if (dotRange.location == NSNotFound) {
        if (stringIsDot) {
            shouldChange = textLength - (range.location + range.length) <= 2;//插入小数点
        }
    }else{
        if (stringIsDot) {
            shouldChange = range.location <= dotRange.location && range.location + range.length > dotRange.location;//替换小数点
        }else{
            shouldChange = !(textLength - (dotRange.location + dotRange.length) >= 2 && textLength - (range.location + range.length) <= 2);//小数点后最多两位
        }
    }
    return shouldChange;
}
@end
