//
//  ExamCardTitleCell.m
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExamCardTitleCell.h"
#import "CodingExamModel.h"

@interface ExamCardTitleCell()
@property (nonatomic, strong) UILabel *lblTitle;


@end

@implementation ExamCardTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lblTitle];
   
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)updateExamCardTitleCell:(CodingExamModel *)item
{
    self.lblTitle.text=[NSString stringWithFormat:@"%ld.%@",(long)item.sort.integerValue,item.question];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.numberOfLines = 0;
        _lblTitle.font =[UIFont boldSystemFontOfSize:17];
        _lblTitle.textColor=[UIColor colorWithHexString:@"222222"];
    }
    return _lblTitle;
}

@end
