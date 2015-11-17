//
//  ExamCardQuestionCell.m
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExamCardQuestionCell.h"
#import "CodingExamOptionsModel.h"

@interface ExamCardQuestionCell()
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIView *lblTitleBgView;

@end

@implementation ExamCardQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.lblTitleBgView addSubview:self.lblTitle];

        [self.contentView addSubview:self.lblTitleBgView];
        
        
        [self.lblTitleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblTitleBgView.mas_top);
            make.right.equalTo(self.lblTitleBgView.mas_right);
            make.left.equalTo(self.lblTitleBgView.mas_left).offset(5);
            make.bottom.equalTo(self.lblTitleBgView.mas_bottom);
        }];
    }
    return self;
}

- (void)updateExamCardQuestionCell:(CodingExamOptionsModel *)item
{
    self.lblTitle.text=[NSString stringWithFormat:@"%@.%@",item.mark,item.content];
    
//    if (self.markSelect)
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
//    }else
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"D9D9D9"];
//    }
    
}

-(void)setMarkSelect:(BOOL)markSelect
{
    _markSelect=markSelect;
    
    if (markSelect)
    {
        if (self.markFail)
        {
            self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"FF4B80"];
            self.lblTitle.textColor=[UIColor whiteColor];
        }else
        {
            self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
            self.lblTitle.textColor=[UIColor whiteColor];
        }
    }else
    {
        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"D9D9D9"];
        self.lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView*)lblTitleBgView
{
    if (!_lblTitleBgView)
    {
        _lblTitleBgView =[UIView new];
        _lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"D9D9D9"];
    }
    return _lblTitleBgView;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.numberOfLines = 0;
        _lblTitle.backgroundColor=[UIColor clearColor];
        _lblTitle.font=[UIFont systemFontOfSize:17];
        _lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
    }
    return _lblTitle;
}


@end
