//
//  PriceListCell.m
//  CodingMart
//
//  Created by Frank on 16/6/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PriceListCell.h"
#import "UIImageView+WebCache.h"

@interface PriceListCell ()

@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UILabel *titleLabel, *priceLabel, *timeLabel;
@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation PriceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addContent];
    }
    return self;
}

- (void)addContent {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 15, 15)];
    [imageView setImage:[UIImage imageNamed:@"price_shopping_basket"]];
    [self addSubview:imageView];
    
    // 平台、模块数量
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 7, 13, kScreen_Width - 40, 15)];
    [_topLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_topLabel setTextColor:[UIColor colorWithHexString:@"696969"]];
    [self addSubview:_topLabel];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, kScreen_Width, 80)];
    [_centerView setBackgroundColor:[UIColor colorWithHexString:@"f6f8fb"]];
    [self addSubview:_centerView];
    
    // 图片
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    [_iconImageView setImage:[UIImage imageNamed:@"price_list_placehoder"]];
    [_centerView addSubview:_iconImageView];
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 12, 10, _centerView.width - _iconImageView.right - 12 - 15, 18)];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_centerView addSubview:_titleLabel];
    
    // 报价
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, _titleLabel.width, 14)];
    [_priceLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_priceLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [_centerView addSubview:_priceLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _priceLabel.bottom + 8, _titleLabel.width, 14)];
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_timeLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [_centerView addSubview:_timeLabel];
    
    // 按钮
    UILabel *viewListLabel = [[UILabel alloc] initWithFrame:CGRectMake(_centerView.width - 93 - 15, _centerView.bottom + 10, 93, 25)];
    [viewListLabel setText:@"查看功能清单"];
    [viewListLabel setTextColor:[UIColor colorWithHexString:@"434a54"]];
    [viewListLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [viewListLabel setTextAlignment:NSTextAlignmentCenter];
    [viewListLabel.layer setCornerRadius:3.0f];
    [viewListLabel.layer setBorderWidth:0.5];
    [viewListLabel.layer setBorderColor:[UIColor colorWithHexString:@"b5b5b5"].CGColor];
    [self addSubview:viewListLabel];
}

- (void)updateCell:(PriceList *)list {
    // 平台模块数
    [_titleLabel setText:list.name];
    
    // 标题
    [_topLabel setText:[NSString stringWithFormat:@"%@个平台，%@个功能模块", list.platformCount, list.moduleCount]];
    
    // 报价
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName, [UIColor colorWithHexString:@"666666"], nil];
    NSString *priceString = [NSString stringWithFormat:@"预估报价：%@ - %@ 元", list.fromPrice, list.toPrice];
    NSMutableAttributedString *priceAttributeString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:dict];
    [priceAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"EEA551"] range:NSMakeRange([priceString rangeOfString:@"预估报价："].length, priceString.length - [priceString rangeOfString:@"预估报价："].length - 1)];
    [_priceLabel setAttributedText:priceAttributeString];
    
    // 时间
    [_timeLabel setText:[NSString stringWithFormat:@"预估周期：%@ - %@ 工作日", list.fromTerm, list.toTerm]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellID {
    return NSStringFromClass([PriceListCell class]);
}

@end
