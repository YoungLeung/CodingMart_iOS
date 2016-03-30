//
//  MartBannersView.m
//  Coding_iOS
//
//  Created by Ease on 15/7/29.
//  Copyright (c) 2015年 Coding. All rights reserved.
//
#define kPaddingLeftWidth 0

#import "MartBannersView.h"
#import "SMPageControl.h"
#import "AutoSlideScrollView.h"
#import "UIImageView+WebCache.h"

@interface MartBannersView ()
@property (assign, nonatomic) CGFloat padding_top, padding_bottom, image_width, ratio;

@property (strong, nonatomic) SMPageControl *myPageControl;
@property (strong, nonatomic) AutoSlideScrollView *mySlideView;
@property (strong, nonatomic) NSMutableArray *imageViewList;
@end

@implementation MartBannersView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self p_setupConfig];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self p_setupConfig];
        CGFloat viewHeight = _padding_top + _padding_bottom + _image_width * _ratio;
        [self setSize:CGSizeMake(kScreen_Width, viewHeight)];
    }
    return self;
}

- (void)p_setupConfig{
    _padding_top = 0;
    _padding_bottom = 0;
    _image_width = kScreen_Width;
    _ratio = 7.0/15;
}

- (void)setCurBannerList:(NSArray *)curBannerList{
    if ([[_curBannerList valueForKey:@"title"] isEqualToArray:[curBannerList valueForKey:@"title"]]) {
        return;
    }
    _curBannerList = curBannerList;
    
    if (!_myPageControl) {
        _myPageControl = ({
            SMPageControl *pageControl = [[SMPageControl alloc] init];
            pageControl.userInteractionEnabled = NO;
            pageControl.backgroundColor = [UIColor clearColor];
            pageControl.pageIndicatorImage = [UIImage imageNamed:@"banner_page_unselected"];
            pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"banner_page_selected"];
            pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame) - _padding_bottom - 10 - 5, kScreen_Width, 10);
            pageControl.numberOfPages = _curBannerList.count;
            pageControl.currentPage = 0;
            pageControl.alignment = SMPageControlAlignmentCenter;
            pageControl;
        });
        [self addSubview:_myPageControl];
    }
    
    if (!_mySlideView) {
        _mySlideView = ({
            __weak typeof(self) weakSelf = self;
            AutoSlideScrollView *slideView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, _padding_top, _image_width, _image_width * _ratio) animationDuration:5.0];
            slideView.layer.masksToBounds = YES;
            slideView.scrollView.scrollsToTop = NO;
            
            slideView.totalPagesCount = ^NSInteger(){
                return weakSelf.curBannerList.count;
            };
            slideView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                if (weakSelf.curBannerList.count > pageIndex) {
                    UIImageView *imageView = [weakSelf p_reuseViewForIndex:pageIndex];
                    MartBanner *curBanner = weakSelf.curBannerList[pageIndex];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:curBanner.image] placeholderImage:[UIImage imageNamed:@"placeholder_banner"]];
                    return imageView;
                }else{
                    return [UIView new];
                }
            };
            slideView.currentPageIndexChangeBlock = ^(NSInteger currentPageIndex){
                weakSelf.myPageControl.currentPage = currentPageIndex;
            };
            slideView.tapActionBlock = ^(NSInteger pageIndex){
                if (weakSelf.tapActionBlock && weakSelf.curBannerList.count > pageIndex) {
                    weakSelf.tapActionBlock(weakSelf.curBannerList[pageIndex]);
                }
            };
            
            slideView;
        });
        [self insertSubview:_mySlideView belowSubview:_myPageControl];
    }
    [self reloadData];
}

- (UIImageView *)p_reuseViewForIndex:(NSInteger)pageIndex{
    if (!_imageViewList) {
        _imageViewList = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, _padding_top, _image_width, _image_width * _ratio)];
            view.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            [_imageViewList addObject:view];
        }
    }
    UIImageView *imageView;
    NSInteger currentPageIndex = self.mySlideView.currentPageIndex;
    if (pageIndex == currentPageIndex) {
        imageView = _imageViewList[1];
    }else if (pageIndex == currentPageIndex + 1
              || (labs(pageIndex - currentPageIndex) > 1 && pageIndex < currentPageIndex)){
        imageView = _imageViewList[2];
    }else{
        imageView = _imageViewList[0];
    }
    return imageView;
}

- (void)reloadData{
    self.hidden = _curBannerList.count <= 0;
    if (_curBannerList.count <= 0) {
        return;
    }
    NSInteger currentPageIndex = MIN(self.mySlideView.currentPageIndex, _curBannerList.count - 1) ;
    _myPageControl.numberOfPages = _curBannerList.count;
    _myPageControl.currentPage = currentPageIndex;
        [_mySlideView reloadData];
}

@end
