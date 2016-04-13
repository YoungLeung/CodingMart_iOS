//
//  EASingleSelectView.m
//  CodingMart
//
//  Created by Ease on 16/4/13.
//  Copyright © 2016年 net.coding. All rights reserved.
//



#import "EASingleSelectView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface EASingleSelectView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UIView *topLineV;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UITableView *listView;
@end

@implementation EASingleSelectView
- (instancetype)init{
    self = [super init];
    if (self) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        WEAKSELF;
        [_bgView bk_whenTapped:^{
            [weakSelf dismiss];
        }];
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _contentView.layer.cornerRadius = 2.0;
        [self addSubview:_contentView];
        CGFloat barOrTitleHeight = 44.0;
        _topLineV = [UIView new];
        _topLineV.backgroundColor = [UIColor colorWithHexString:@"0x4289DB"];
        [_contentView addSubview:_topLineV];
        [_topLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(barOrTitleHeight);
            make.left.equalTo(_contentView).offset(15);
            make.right.equalTo(_contentView).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = [UIColor blackColor];
        [_contentView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_topLineV);
            make.top.equalTo(_contentView);
        }];
        _listView = [[UITableView alloc] initWithFrame:self.bounds];
        _listView.backgroundColor = [UIColor clearColor];
        [_listView registerClass:[EASingleSelectViewCell class] forCellReuseIdentifier:kCCellIdentifier_EASingleSelectViewCell];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.rowHeight = 44.0;
        [self.contentView addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLineV);
            make.top.equalTo(_topLineV.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleL.text = _title;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_listView reloadData];
}

- (void)setDisableList:(NSMutableArray<NSString *> *)disableList{
    _disableList = disableList;
    [_listView reloadData];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.y = self.height;
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([[self superview] isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)[self superview] setScrollEnabled:YES];
        }
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)view setScrollEnabled:NO];
    }
    self.frame = view.bounds;
    _bgView.alpha = 0.0;
    CGFloat contentHeight = MIN(view.height/ 2, 44 + 44* _dataList.count);
    _contentView.frame = CGRectMake(15, view.height, view.width - 30, contentHeight);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.centerY = self.height/2;
    } completion:nil];
}

+ (instancetype)showInView:(UIView *)view withTitle:(NSString *)title dataList:(NSArray<NSString *> *)dataList disableList:(NSArray<NSString *> *)disableList andConfirmBlock:(void(^)(NSString *selectedStr))block{
    EASingleSelectView *eaView = [EASingleSelectView new];
    eaView.title = title;
    eaView.dataList = dataList;
    eaView.disableList = disableList? disableList.mutableCopy: @[].mutableCopy;
    eaView.confirmBlock = block;
    [eaView showInView:view];
    return eaView;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EASingleSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCCellIdentifier_EASingleSelectViewCell forIndexPath:indexPath];
    cell.text = _dataList[indexPath.row];
    cell.canChoose = ![_disableList containsObject:_dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *dataStr = _dataList[indexPath.row];
    if ([_disableList containsObject:dataStr]) {
        return;
    }else{
        [self dismiss];
        if (_confirmBlock) {
            _confirmBlock(dataStr);
        }
    }
}

@end


@interface EASingleSelectViewCell ()
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation EASingleSelectViewCell

- (void)setText:(NSString *)text{
    _text = text;
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
    }
    _contentLabel.text = _text;
}

- (void)setCanChoose:(BOOL)canChoose{
    _canChoose = canChoose;
    _contentLabel.textColor = [UIColor colorWithHexString:canChoose? @"0x666666": @"0xCCCCCC"];
    self.selectionStyle = canChoose? UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
}

@end