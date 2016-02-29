//
//  CaseListCell.m
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CaseListCell.h"

@interface CaseListCell ()
@property (strong, nonatomic) UIImageView *cardBGV, *logoV;
@property (strong, nonatomic) UILabel *nameL, *amountL, *termL, *characterL;
@property (strong, nonatomic) UIView *h_lineV, *v_lineV;
@end

@implementation CaseListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_cardBGV) {
            _cardBGV = ({
                UIImageView *item = [UIImageView new];
                item.image = [[UIImage imageNamed:@"case_card_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
                [self.contentView addSubview:item];
                item;
            });
            _logoV = ({
                UIImageView *item = [UIImageView new];
                item.contentMode = UIViewContentModeScaleAspectFit;
                [self.contentView addSubview:item];
                item;
            });;
            _h_lineV = ({
                UIView *item = [UIView new];
                item.backgroundColor = [UIColor colorWithHexString:@"0xD9D9D9"];
                [self.contentView addSubview:item];
                item;
            });
            _v_lineV = ({
                UIView *item = [UIView new];
                item.backgroundColor = [UIColor colorWithHexString:@"0xD9D9D9"];
                [self.contentView addSubview:item];
                item;
            });
            _nameL = ({
                UILabel *item = [UILabel new];
                item.font = [UIFont systemFontOfSize:15];
                item.textColor = [UIColor colorWithHexString:@"0x222222"];
                item.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:item];
                item;
            });
            _amountL = ({
                UILabel *item = [UILabel new];
                item.font = [UIFont systemFontOfSize:10];
                item.textColor = [UIColor colorWithHexString:@"0x666666"];
                item.textAlignment = NSTextAlignmentRight;
                [self.contentView addSubview:item];
                item;
            });
            _termL = ({
                UILabel *item = [UILabel new];
                item.font = [UIFont systemFontOfSize:10];
                item.textColor = [UIColor colorWithHexString:@"0x666666"];
                item.textAlignment = NSTextAlignmentLeft;
                [self.contentView addSubview:item];
                item;
            });
            _characterL = ({
                UILabel *item = [UILabel new];
                item.font = [UIFont systemFontOfSize:10];
                item.textColor = [UIColor colorWithHexString:@"0x666666"];
                item.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:item];
                item;
            });
            
            [_cardBGV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 15, 5, 15));
            }];
            [_logoV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.equalTo(_cardBGV);
                make.top.equalTo(_cardBGV).offset(15);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(_h_lineV.mas_top).offset(-15);
            }];
            [_h_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_cardBGV).offset(12);
                make.right.equalTo(_cardBGV).offset(-12);
                make.height.mas_equalTo(0.5);
            }];
            [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cardBGV);
                make.height.mas_equalTo(20);
                make.top.equalTo(_h_lineV.mas_bottom).offset(15);
            }];
            [_amountL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_v_lineV.mas_left).offset(-5);
            }];
            [_termL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_v_lineV.mas_right).offset(5);
            }];
            [_v_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(10);
                make.width.mas_equalTo(0.5);
                make.top.equalTo(_nameL.mas_bottom).offset(10);
                make.centerX.equalTo(_cardBGV);
                make.centerY.equalTo(@[_amountL, _termL]);
            }];
            [_characterL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_v_lineV.mas_bottom).offset(5);
                make.centerX.equalTo(_cardBGV);
            }];
        }
    }
    return self;
}

- (void)setInfo:(CaseInfo *)info{
    _info = info;
    
    _logoV.image = [UIImage imageNamed:@"placeholder_reward_cover"];
    _nameL.text = @"信我科技 微信开发";
    _amountL.attributedText = [self p_attrStrWithTitle:@"金额" value:@"￥8000"];
    _termL.attributedText = [self p_attrStrWithTitle:@"项目时间" value:@"30 天"];
    _characterL.attributedText = [self p_attrStrWithTitle:@"参与角色" value:@"设计师、攻城狮"];
}

- (NSAttributedString *)p_attrStrWithTitle:(NSString *)title value:(NSString *)value{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", title, value]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x999999"] range:NSMakeRange(0, title.length)];
    return attr;
}

+ (CGFloat)cellHeight{
    return 170;
}
@end
