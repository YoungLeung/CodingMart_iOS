//
//  EAMultiSelectView.m
//  CodingMart
//
//  Created by Ease on 15/11/2.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EAMultiSelectView.h"
@interface EAMultiSelectView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UIView *topLineV, *bottomLineV, *splitLineV;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UIButton *cancelBtn, *confirmBtn;
@property (strong, nonatomic) UICollectionView *listView;
@end

@implementation EAMultiSelectView
- (instancetype)init{
    self = [super init];
    if (self) {
        _maxSelectNum = NSUIntegerMax;
        
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _contentView.layer.cornerRadius = 2.0;
        [self addSubview:_contentView];
        CGFloat barOrTitleHeight = 44.0;
        _topLineV = [UIView new];
        _bottomLineV = [UIView new];
        _splitLineV = [UIView new];
        _topLineV.backgroundColor = [UIColor colorWithHexString:@"0x4289DB"];
        _bottomLineV.backgroundColor = [UIColor colorWithHexString:@"0xCCCCCC"];
        _splitLineV.backgroundColor = [UIColor colorWithHexString:@"0xCCCCCC"];
        [_contentView addSubview:_topLineV];
        [_contentView addSubview:_bottomLineV];
        [_contentView addSubview:_splitLineV];
        [_topLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(barOrTitleHeight);
            make.left.equalTo(_contentView).offset(15);
            make.right.equalTo(_contentView).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        [_bottomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView).offset(-barOrTitleHeight);
            make.height.mas_equalTo(0.5);
        }];
        [_splitLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomLineV);
            make.centerX.equalTo(_contentView);
            make.bottom.equalTo(_contentView);
            make.width.mas_equalTo(0.5);
        }];
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = [UIColor blackColor];
        [_contentView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_topLineV);
            make.top.equalTo(_contentView);
        }];
        _listView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
        [_listView registerClass:[EAMultiSelectViewCCell class] forCellWithReuseIdentifier:kCCellIdentifier_EAMultiSelectViewCCell];
        _listView.dataSource = self;
        _listView.delegate = self;
        [self.contentView addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLineV);
            make.top.equalTo(_topLineV.mas_bottom);
            make.bottom.equalTo(_bottomLineV.mas_top);
        }];
        _cancelBtn = [UIButton new];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_contentView);
            make.right.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
        }];
        _confirmBtn = [UIButton new];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_contentView);
            make.left.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
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

- (void)setSelectedList:(NSMutableArray *)selectedList{
    _selectedList = selectedList;
    [_listView reloadData];
}

- (void)cancelBtnClicked{
    [self dismiss];
}

- (void)confirmBtnClicked{
    if (_confirmBlock) {
        _confirmBlock(_selectedList);
    }
    [self dismiss];
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
    _contentView.frame = CGRectMake(15, view.height, view.width - 30, view.height/2);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.centerY = self.height/2;
    } completion:nil];
}
+ (instancetype)showInView:(UIView *)view withTitle:(NSString *)title dataList:(NSArray<NSString *> *)dataList selectedList:(NSArray<NSString *> *)selectedList andConfirmBlock:(void(^)(NSArray<NSString *> *selectedList))block{
    EAMultiSelectView *eaView = [EAMultiSelectView new];
    eaView.title = title;
    eaView.dataList = dataList;
    eaView.selectedList = selectedList? selectedList.mutableCopy: @[].mutableCopy;
    eaView.confirmBlock = block;
    [eaView showInView:view];
    return eaView;
}
#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EAMultiSelectViewCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_EAMultiSelectViewCCell forIndexPath:indexPath];
    ccell.text = _dataList[indexPath.row];
    ccell.hasBeenSeleted = [_selectedList containsObject:_dataList[indexPath.row]];
    return ccell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(collectionView.frame)- 10)/2, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    EAMultiSelectViewCCell *ccell = (EAMultiSelectViewCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ccell.hasBeenSeleted = !ccell.hasBeenSeleted;
    
    NSString *dataStr = _dataList[indexPath.row];
    if ([_selectedList containsObject:dataStr]) {
        [_selectedList removeObject:dataStr];
    }else{
        if (_selectedList.count >= _maxSelectNum) {
            ccell.hasBeenSeleted = !ccell.hasBeenSeleted;
            [NSObject showHudTipStr:[NSString stringWithFormat:@"最多能选择 %ld 个", (unsigned long)_maxSelectNum]];
        }else{
            [_selectedList addObject:dataStr];
        }
    }
}
@end

@interface EAMultiSelectViewCCell ()
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation EAMultiSelectViewCCell
- (void)setText:(NSString *)text{
    _text = text;
    if (!_contentLabel) {
        self.contentView.layer.cornerRadius = 2.0;
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.minimumScaleFactor = 0.5;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    _contentLabel.text = _text;
}

- (void)setHasBeenSeleted:(BOOL)hasBeenSeleted{
    _hasBeenSeleted = hasBeenSeleted;
    _contentLabel.textColor = [UIColor colorWithHexString:hasBeenSeleted? @"0xFFFFFF": @"0x666666"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:hasBeenSeleted? @"0x4289DB": @"0xF3F3F3"];
}

@end