//
//  CaseListViewController.m
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CaseListViewController.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "CaseListView.h"
#import "CaseInfo.h"

@interface CaseListViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) NSArray *typeTitleList, *typeValueList;
@property (strong, nonatomic) NSMutableDictionary *casesDict;

@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;
@end

@implementation CaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"码市案例";
    _typeTitleList = @[@"全部", @"网站", @"APP", @"微信开发", @"HTML5"];
    _typeValueList = @[@"", @"1", @"5", @"2", @"3"];//「网站 - 1」这里是个特殊处理，在其他地方正常使用「网站 - 0」
    _casesDict = [NSMutableDictionary new];
    
    CGFloat segment_height = 44.0;
    //添加myCarousel
    _myCarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(segment_height, 0, 0, 0));
        }];
        icarousel;
    });

    //添加滑块
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, segment_height) Items:_typeTitleList selectedBlock:^(NSInteger index) {
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    _mySegmentControl.backgroundColor = [UIColor whiteColor];
    _mySegmentControl.defaultTextColor = [UIColor colorWithHexString:@"0x222222"];
    [self.view addSubview:_mySegmentControl];

}

#pragma mark iCarousel M
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _typeTitleList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    CaseListView *listView = (CaseListView *)view;
    if (!listView) {
        __weak typeof(self) weakSelf = self;
        listView = [[CaseListView alloc] initWithFrame:carousel.bounds];
        listView.itemClickedBlock = ^(id clickedItem){
            [weakSelf goToCaseInfo:clickedItem];
        };
    }else if (listView.dataList){
        _casesDict[listView.type] = listView.dataList;//保存旧值
    }
    listView.type = _typeValueList[index];
    listView.dataList = _casesDict[listView.type];//填充新值
    
    [listView setSubScrollsToTop:(index == carousel.currentItemIndex)];
    
    if (index == carousel.currentItemIndex) {
        [listView lazyRefreshData];
    }
    return listView;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    [self.view endEditing:YES];
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0 && round(offset) != offset) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj setSubScrollsToTop:(obj == carousel.currentItemView)];
    }];
    
    CaseListView *listView = (CaseListView *)carousel.currentItemView;
    [listView lazyRefreshData];
}

#pragma mark GoTo VC
- (void)goToCaseInfo:(CaseInfo *)info{
    [self goToWebVCWithUrlStr:[NSString stringWithFormat:@"/cases/%@", info.reward_id] title:@"案例详情"];
}
@end
