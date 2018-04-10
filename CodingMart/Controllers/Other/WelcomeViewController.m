//
//  WelcomeViewController.m
//  CodingMart
//
//  Created by Ease on 16/4/6.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kWelcomePageNum 4

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "iCarousel.h"
#import "SMPageControl.h"

@interface WelcomeViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) UIButton *loginBtn, *useBtn;
@property (strong, nonatomic) iCarousel *myCarousel;
@property (strong, nonatomic) SMPageControl *myPageControl;
@end

@implementation WelcomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x373D47"];
    [self setupButtons];
    [self setupContent];
}

#pragma mark - button
- (void)setupButtons{
    CGFloat padding = 20;
    CGFloat width = (kScreen_Width - 3* padding)/ 2;
    CGFloat height = kScaleFrom_iPhone6_Desgin(50);
    CGFloat buttonY = kScreen_Height - height - kScaleFrom_iPhone6_Desgin(40) - kSafeArea_Bottom;
    if (!_loginBtn) {
        _loginBtn = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(padding, buttonY, width, height)];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
            button.cornerRadius = 3.0;

            [button setTitle:@"登录码市" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:@"0x4289DB"];
            [button addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            button;
        });
    }
    if (!_useBtn) {
        _useBtn = ({
            UIButton *button = [UIButton new];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
            button.cornerRadius = 3.0;
            
            [button setTitle:@"先用用看" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:@"0xADBBCB"];
            [button addTarget:self action:@selector(useBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            button;
        });
        [_useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-padding);
            make.left.equalTo(self.loginBtn.mas_right).offset(padding);
            make.centerY.height.with.equalTo(self.loginBtn);
        }];
    }
}

- (void)loginBtnClicked{
    [MobClick event:kUmeng_Event_UserAction label:@"欢迎页_登录码市"];
    LoginViewController *vc = [LoginViewController storyboardVCWithUserStr:nil];
    vc.loginSucessBlock = ^(){
        [UIViewController updateTabVCListWithSelectedIndex:0];
    };
    [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
}

- (void)useBtnClicked{
    [MobClick event:kUmeng_Event_UserAction label:@"欢迎页_先用用看"];
    [UIViewController updateTabVCListWithSelectedIndex:0];
}

#pragma mark - content
- (void)setupContent{
    if (!_myCarousel) {
        CGFloat carouselY = kScaleFrom_iPhone6_Desgin(80);
        if (kScreen_Height == 480) {//矮屏尺寸的特殊搞一搞
            carouselY = 40;
        }
        CGFloat carouselH = kScreen_Height - carouselY - kScaleFrom_iPhone6_Desgin(160) - kSafeArea_Bottom;
        _myCarousel = ({
            iCarousel *icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, carouselY, kScreen_Width, carouselH)];
            icarousel.dataSource = self;
            icarousel.delegate = self;
            icarousel.type = iCarouselTypeRotary;
            icarousel.pagingEnabled = YES;
            icarousel.bounces = NO;
            
            [self.view addSubview:icarousel];
            icarousel;
        });
    }
    if (!_myPageControl) {
        _myPageControl = ({
            SMPageControl *pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_myCarousel.frame) + 20, kScreen_Width, 20)];
            pageControl.userInteractionEnabled = NO;
            pageControl.pageIndicatorImage = [UIImage imageNamed:@"welcome_page_unselected"];
            pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"welcome_page_selected"];
            pageControl.numberOfPages = kWelcomePageNum;
            pageControl.currentPage = 0;
            [self.view addSubview:pageControl];
            pageControl;
        });
    }

}

#pragma mark iCarousel M
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return kWelcomePageNum;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    CardView *itemView;
    if (view) {
        itemView = (CardView *)view;
    }else{
        CGFloat itemW = 0.75* CGRectGetWidth(carousel.bounds);
        CGFloat itemX = (kScreen_Width - itemW)/ 2;
        itemView = [[CardView alloc] initWithFrame:CGRectMake(itemX, 0, itemW, CGRectGetHeight(carousel.bounds))];
    }
    switch (index) {
        case 1:
            [itemView setImage:@"welcome_1" title:@"省钱" text:@"海量认证开发者，精简 IT 建设成本"];
            break;
        case 2:
            [itemView setImage:@"welcome_2" title:@"省心" text:@"全云端开发工具，过程全透明"];
            break;
        case 3:
            [itemView setImage:@"welcome_3" title:@"安全" text:@"双向协议保障，在线交付验收"];
            break;
        default:
            [itemView setImage:@"welcome_0" title:nil text:@"『 码市是一个软件外包服务平台，通过智能匹配系统快速连接开发者与需求方，提供在线的项目管理工具与资金托管服务，提高软件交付的效率，保障需求方和开发者权益，帮助软件开发行业实现高效的资源匹配。』"];
            break;
    }
    return itemView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch (option) {
        case iCarouselOptionWrap:
            return NO;
        case iCarouselOptionSpacing://--1
            return value* 1.2;
        case iCarouselOptionCount://--4
            return 20;
        case iCarouselOptionOffsetMultiplier://--1
            return value* 1.5;
        case iCarouselOptionShowBackfaces://--1
            return NO;
        case iCarouselOptionVisibleItems://--4
        case iCarouselOptionArc://--弧 6.2
        case iCarouselOptionAngle://--0
        case iCarouselOptionRadius://--半径 140
        case iCarouselOptionTilt:
        case iCarouselOptionFadeMin://
        case iCarouselOptionFadeMax://
        case iCarouselOptionFadeRange://--1
        case iCarouselOptionFadeMinAlpha://--0
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _myPageControl.currentPage = carousel.currentItemIndex;
}


@end

@interface CardView ()
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UILabel *titleL, *textL, *detailTextL;
@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cornerRadius = 6.0;
        
        _imageV = [UIImageView new];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageV];
        
        _titleL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:kScaleFrom_iPhone6_Desgin(32)];
            label.textColor = [UIColor colorWithHexString:@"0x434A54"];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _textL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:kScaleFrom_iPhone6_Desgin(14)];
            label.textColor = [UIColor colorWithHexString:@"0x434A54"];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _detailTextL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:kScaleFrom_iPhone6_Desgin(12)];
            label.textColor = [UIColor colorWithHexString:@"0x434A54"];
            label.numberOfLines = 0;
            [self addSubview:label];
            label;
        });
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(kScaleFrom_iPhone6_Desgin(30));
            make.width.height.equalTo(self.mas_width);
        }];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageV.mas_bottom).offset(5);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(40));
        }];
        [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleL.mas_bottom).offset(15);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(20));
        }];
        [_detailTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.imageV.mas_bottom).offset(5);
//            make.bottom.equalTo(self).offset(-40);
        }];
    }
    return self;
}

- (void)setImage:(NSString *)imageName title:(NSString *)title text:(NSString *)text{
    _imageV.image = [UIImage imageNamed:imageName];
    BOOL hasTitle = title.length > 0;
    _titleL.hidden = !hasTitle;
    _textL.hidden = !hasTitle;
    _detailTextL.hidden = hasTitle;
    if (hasTitle) {
        _titleL.text = title;
        _textL.text = text;
    }else{
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 5;
        style.alignment = NSTextAlignmentJustified;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName: style, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
        _detailTextL.attributedText = attrText;
    }
}

@end
