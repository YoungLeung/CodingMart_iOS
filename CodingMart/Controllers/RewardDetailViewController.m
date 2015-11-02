//
//  RewardDetailViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/29.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardDetailViewController.h"

@interface RewardDetailViewController ()
@property (strong, nonatomic) UIView *bottomV;
@end

@implementation RewardDetailViewController
- (void)setCurReward:(Reward *)curReward{
    _curReward = curReward;
    self.curUrlStr = [NSString stringWithFormat:@"/p/%@", _curReward.id.stringValue];
    self.titleStr = _curReward.title;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self refreshBottomView];
}

- (void)refreshBottomView{
    if (_curReward.status.integerValue == 5) {//招募中的 Reward
        if (!_bottomV) {
            _bottomV = [UIView new];
            _bottomV.backgroundColor = self.view.backgroundColor;
            [_bottomV addLineUp:YES andDown:NO andColor:[UIColor colorWithHexString:@"0xDDDDDD"]];
            [self.view addSubview:_bottomV];
            [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(64);
            }];
        }
        [[_bottomV subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }];
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        if (rand()%2) {
            UIButton *button = [self p_joinBtn];
            [_bottomV addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.bottomV).insets(UIEdgeInsetsMake(10, 15, 10, 15));
            }];
        }else{
            UIButton *button1 = [self p_canceledBtn];
            UIButton *button2 = [self p_rejectedBtn];
            [_bottomV addSubview:button1];
            [_bottomV addSubview:button2];
            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bottomV).offset(15);
                make.right.equalTo(button2.mas_left).offset(-15);
                make.width.top.bottom.equalTo(button2);
            }];
            [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomV).offset(-15);
                make.top.equalTo(self.bottomV).offset(10);
                make.bottom.equalTo(self.bottomV).offset(-10);
            }];
        }
    }else{
        if (_bottomV) {
            [_bottomV removeFromSuperview];
        }
        self.webView.scrollView.contentInset = UIEdgeInsetsZero;
    }
}

- (UIButton *)p_bottomBtnWithTitle:(NSString *)title bgColorHexStr:(NSString *)colorHexStr{
    UIButton *button = [UIButton new];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3.0;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:colorHexStr];
    return button;
}

- (UIButton *)p_joinBtn{
    return [self p_bottomBtnWithTitle:@"参与悬赏" bgColorHexStr:@"0x3BBD79"];
}
- (UIButton *)p_waitingBtn{
    return [self p_bottomBtnWithTitle:@"待审核" bgColorHexStr:@"0xBBCED7"];
}
- (UIButton *)p_rejectedBtn{
    return [self p_bottomBtnWithTitle:@"已拒绝" bgColorHexStr:@"0xE3706E"];
}
- (UIButton *)p_canceledBtn{
    return [self p_bottomBtnWithTitle:@"已取消" bgColorHexStr:@"0xDDDDDD"];
}
- (UIButton *)p_reJoinBtn{
    return [self p_bottomBtnWithTitle:@"重新报名" bgColorHexStr:@"0x3BBD79"];
}
- (UIButton *)p_passedBtn{
    return [self p_bottomBtnWithTitle:@"已通过" bgColorHexStr:@"0x549FD5"];
}

- (void)bottomBtnClicked:(UIButton *)sender{
    NSLog(@"bottomBtnClicked : %@", sender.titleLabel.text);
}

@end
