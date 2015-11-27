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
@property (nonatomic, strong) UILabel *lblMark;
@property (nonatomic, strong) UIView *lblTitleBgView;


@end

@implementation ExamCardQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.lblTitleBgView addSubview:self.lblTitle];
        [self.lblTitleBgView addSubview:self.lblMark];

        [self.contentView addSubview:self.lblTitleBgView];
        
        self.lblTitleBgView.layer.masksToBounds=YES;
        self.lblTitleBgView.layer.cornerRadius=3;
        self.lblTitleBgView.layer.borderWidth=0.5;
        self.lblTitleBgView.layer.borderColor=[UIColor colorWithHexString:@"e3e3e3"].CGColor;
        
        
        [self.lblTitleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self.lblMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(8));
            make.width.equalTo(@(19));
            make.left.equalTo(self.lblTitleBgView.mas_left).offset(5);
            make.height.equalTo(@(24));
        }];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblTitleBgView.mas_top);
            make.right.equalTo(self.lblTitleBgView.mas_right);
            make.left.equalTo(self.lblMark.mas_right);
            make.bottom.equalTo(self.lblTitleBgView.mas_bottom);
        }];
    }
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    return self;
}

- (void)updateExamCardQuestionCell:(CodingExamOptionsModel *)item isViewModel:(BOOL)markFail isMarkSelect:(BOOL)isMarkSelect
{
    self.lblMark.text=[NSString stringWithFormat:@"%@.",item.mark];
    self.lblTitle.text=[NSString stringWithFormat:@"%@",item.content];
    
    if(markFail && isMarkSelect)
    {
        if (self.model.isRight)
        {
            self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
            self.lblTitle.textColor=[UIColor whiteColor];
            self.lblMark.textColor=self.lblTitle.textColor;
        }else
        {
            self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"FF4B80"];
            self.lblTitle.textColor=[UIColor whiteColor];
            self.lblMark.textColor=self.lblTitle.textColor;
        }
    }else if (markFail &&!isMarkSelect)
    {
        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
        self.lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
        self.lblMark.textColor=self.lblTitle.textColor;
    }else if (!markFail && isMarkSelect)
    {
        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
        self.lblTitle.textColor=[UIColor whiteColor];
        self.lblMark.textColor=self.lblTitle.textColor;
    }else if (!markFail &&!isMarkSelect)
    {
        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
        self.lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
        self.lblMark.textColor=self.lblTitle.textColor;

    }
    
}

- (void)updateExamCardQuestionCell:(CodingExamOptionsModel *)item
{
    self.lblMark.text=[NSString stringWithFormat:@"%@.",item.mark];
    self.lblTitle.text=[NSString stringWithFormat:@"%@",item.content];
  
//    if (self.markSelect)
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
//    }else
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"D9D9D9"];
//    }
    
}

//-(void)setMarkSelect:(BOOL)markSelect
//{
//    _markSelect=markSelect;
//    
//    //查看未做模式下
//    if (markSelect)
//    {
//      
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
//        self.lblTitle.textColor=[UIColor whiteColor];
//        self.lblMark.textColor=self.lblTitle.textColor;
//        
//        
//    }else
//    {
//        
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
//        self.lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
//        self.lblMark.textColor=self.lblTitle.textColor;
//    }
//    
//}
//
//-(void)setMarkFail:(BOOL)markFail
//{
//    _markFail=markFail;
//    //错题模式
//    if (markFail)
//    {
//
//    if (self.model.isRight)
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"44C07F"];
//        self.lblTitle.textColor=[UIColor whiteColor];
//        self.lblMark.textColor=self.lblTitle.textColor;
// 
//    }else
//    {
//        
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"FF4B80"];
//        self.lblTitle.textColor=[UIColor whiteColor];
//        self.lblMark.textColor=self.lblTitle.textColor;
//
//    }
//        
//    }else
//    {
//        self.lblTitleBgView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
//        self.lblTitle.textColor=[UIColor colorWithHexString:@"666666"];
//        self.lblMark.textColor=self.lblTitle.textColor;
//    }
//    
//}



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

- (UILabel *)lblMark {
    if (!_lblMark) {
        _lblMark = [UILabel new];
        _lblMark.numberOfLines = 0;
        _lblMark.backgroundColor=[UIColor clearColor];
        _lblMark.font=[UIFont systemFontOfSize:17];
        _lblMark.textColor=[UIColor colorWithHexString:@"666666"];
    }
    return _lblMark;
}


@end
