//
//  HighPaidAreaCell.m
//  CodingMart
//
//  Created by Ease on 2016/11/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "HighPaidAreaCell.h"
#import "HighPaidAreaCCell.h"

@interface HighPaidAreaCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@end

@implementation HighPaidAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    [_collectionV registerNib:[UINib nibWithNibName:kCellIdentifier_HighPaidAreaCCell bundle:nil] forCellWithReuseIdentifier:kCellIdentifier_HighPaidAreaCCell];
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_collectionV reloadData];
}

- (IBAction)areaBtnClicked:(id)sender {
    if (_itemClickedBlock) {
        _itemClickedBlock(nil);
    }
}

+ (CGFloat)cellHeight{
    return 225;
}

#pragma UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(_dataList.count, 4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HighPaidAreaCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_HighPaidAreaCCell forIndexPath:indexPath];
    ccell.curReward = _dataList[indexPath.row];
    return ccell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (_itemClickedBlock) {
        _itemClickedBlock(_dataList[indexPath.row]);
    }
}

@end
