//
//  AnswsCollectionCell.m
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "AnswsCollectionCell.h"

@interface AnswsCollectionCell ()
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation AnswsCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI
{
    self.contentLabel=[UILabel new];
    self.contentLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.backgroundColor=[UIColor colorWithHexString:@"F3F3F3"];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)setATitle:(NSString *)aTitle
{
    _aTitle=aTitle;
    self.contentLabel.text=aTitle;
}

-(void)setIsMark:(BOOL)isMark
{
    _isMark=isMark;
    
    if (self.ansModel==AnswerModel_ShowAll)
    {
        if (isMark)
        {
             self.contentLabel.backgroundColor=[UIColor colorWithHexString:@"dbf3e6"];
             self.contentLabel.textColor=[UIColor colorWithHexString:@"4cbb79"];
        }
        else
        {
            self.contentLabel.backgroundColor=[UIColor colorWithHexString:@"F3F3F3"];
            self.contentLabel.textColor=[UIColor blackColor];
        }
        
    }else
    {
        if (isMark)
        {
            self.contentLabel.backgroundColor=[UIColor colorWithHexString:@"FF4B80" andAlpha:0.2];
            self.contentLabel.textColor=[UIColor colorWithHexString:@"FF4B80"];
        }
        else
        {
            self.contentLabel.backgroundColor=[UIColor colorWithHexString:@"F3F3F3"];
            self.contentLabel.textColor=[UIColor blackColor];
        }
    }
}

@end
