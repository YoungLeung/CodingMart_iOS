//
//  ExamCardAnswCell.m
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExamCardAnswCell.h"

@interface ExamCardAnswCell ()
@property (nonatomic, strong) UILabel *lblTitle;

@end

@implementation ExamCardAnswCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        
        [self.contentView addSubview:self.lblTitle];
        
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    
    }
    return self;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.numberOfLines = 0;
        _lblTitle.backgroundColor=[UIColor clearColor];
        _lblTitle.font=[UIFont boldSystemFontOfSize:17];
        _lblTitle.textAlignment=NSTextAlignmentLeft;
        _lblTitle.textColor=[UIColor colorWithHexString:@"0x4289DB"];
    }
    return _lblTitle;
}

-(void)updateContentData:(CodingExamModel *)model
{
    NSString *string = [model.corrects_mark componentsJoinedByString:@","];
    self.lblTitle.text=[NSString stringWithFormat:@"正确答案:%@",string];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
