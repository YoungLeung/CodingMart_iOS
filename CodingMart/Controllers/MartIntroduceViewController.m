//
//  MartIntroduceViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/9.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartIntroduceViewController.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"

@interface MartIntroduceViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;
@property (strong, nonatomic) NSArray *segmentTitleList;

@property (strong, nonatomic) IBOutlet UIScrollView *aboutV;
@property (strong, nonatomic) IBOutlet UIScrollView *processV;
@property (strong, nonatomic) IBOutlet UIScrollView *contactV;
@property (weak, nonatomic) IBOutlet UIView *aboutWidthV;
@property (weak, nonatomic) IBOutlet UIView *processWidthV;
@property (weak, nonatomic) IBOutlet UIView *contactWidthV;
@property (weak, nonatomic) IBOutlet UILabel *aboutPrice0;
@property (weak, nonatomic) IBOutlet UILabel *aboutPrice1;
@property (weak, nonatomic) IBOutlet UILabel *aboutPrice2;
@property (weak, nonatomic) IBOutlet UILabel *aboutVersionL;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoL;
@property (weak, nonatomic) IBOutlet UILabel *processL0;
@property (weak, nonatomic) IBOutlet UILabel *processL1;
@property (weak, nonatomic) IBOutlet UILabel *processL2;

@end

@implementation MartIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"码市介绍";
    _segmentTitleList = @[@"关于码市", @"码市流程", @"联系我们"];
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
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, segment_height) Items:_segmentTitleList selectedBlock:^(NSInteger index) {
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    _mySegmentControl.backgroundColor = [UIColor whiteColor];
    _mySegmentControl.defaultTextColor = [UIColor colorWithHexString:@"0x222222"];
    [self.view addSubview:_mySegmentControl];
    [self setupUI];
}

- (void)setupUI{
    //窄屏上字号处理
    if (kScreen_Width == 320) {
        _aboutPrice0.font = _aboutPrice1.font = _aboutPrice2.font = [UIFont systemFontOfSize:13];
    }
    //视图限宽
    [_aboutWidthV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreen_Width);
    }];
    [_processWidthV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreen_Width);
    }];
    [_contactWidthV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreen_Width);
    }];
    //内容
    _aboutVersionL.text = [NSString stringWithFormat:@"版本号：V%@", [NSObject appVersion]];
    [_contactInfoL addAttrDict:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} toStr:@"码市科技有限公司"];

    [_processL0 addAttrDict:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} toStr:@"无忧交付"];
    [_processL1 addAttrDict:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} toStr:@"便捷跟踪"];
    [_processL2 addAttrDict:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} toStr:@"无忧质保"];
}

#pragma mark iCarousel M
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _segmentTitleList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    UIView *currentItemView;
    if (index == 0) {
        currentItemView = _aboutV;
    }else if (index == 1){
        currentItemView = _processV;
    }else{
        currentItemView = _contactV;
    }
    currentItemView.frame = carousel.bounds;
    return currentItemView;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
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
}

@end
