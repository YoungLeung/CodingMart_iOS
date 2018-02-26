//
//  CodingShareView.m
//  Coding_iOS
//
//  Created by Ease on 15/9/2.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#define kCodingShareView_NumPerLine 4
#define kCodingShareView_TopHeight 60.0
#define kCodingShareView_BottomHeight 60.0
#define kCodingShareView_Padding 15.0

#import "MartShareView.h"
#import <UMengSocial/UMSocial.h>

#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "ReportIllegalViewController.h"
#import "SDWebImageManager.h"
//#import <Masonry/Masonry.h>

@interface MartShareView ()<UMSocialUIDelegate>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UIButton *dismissBtn;
@property (strong, nonatomic) UIScrollView *itemsScrollView;

@property (strong, nonatomic) NSArray *shareSnsValues;
@property (weak, nonatomic) NSObject *objToShare;
@end

@implementation MartShareView
#pragma mark init M
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = ({
                UIView *view = [[UIView alloc] initWithFrame:kScreen_Bounds];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                [view bk_whenTapped:^{
                    [self p_dismiss];
                }];
                view;
            });
            [self addSubview:_bgView];
        }
        if (!_contentView) {
            _contentView = [UIView new];
            _contentView.backgroundColor = [UIColor colorWithHexString:@"0xF0F0F0"];
            if (!_titleL) {
                _titleL = ({
                    UILabel *label = [UILabel new];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = [UIColor colorWithHexString:@"0x666666"];
                    label;
                });
                [_contentView addSubview:_titleL];
                [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_contentView);
                    make.top.equalTo(_contentView).offset(10);
                    make.height.mas_equalTo(20);
                }];
            }
            if (!_dismissBtn) {
                _dismissBtn = ({
                    UIButton *button = [UIButton new];
                    button.backgroundColor = [UIColor whiteColor];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 2.0;
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x808080"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x4289DB"] forState:UIControlStateHighlighted];
                    [button addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
                    button;
                });
                [_contentView addSubview:_dismissBtn];
                [_dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_contentView).offset(kCodingShareView_Padding);
                    make.right.equalTo(_contentView).offset(-kCodingShareView_Padding);
                    make.bottom.equalTo(_contentView).offset(-kCodingShareView_Padding);
                    make.height.mas_equalTo(40);
                }];
            }
            if (!_itemsScrollView) {
                _itemsScrollView = ({
                    UIScrollView *scrollView = [UIScrollView new];
                    scrollView;
                });
                [_contentView addSubview:_itemsScrollView];
                [_itemsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_contentView);
                    make.top.equalTo(_contentView).offset(kCodingShareView_TopHeight);
                    make.bottom.equalTo(_contentView).offset(-kCodingShareView_BottomHeight);
                }];
            }
            [_contentView setY:kScreen_Height];
            [self addSubview:_contentView];
        }
    }
    return self;
}

- (void)setShareSnsValues:(NSArray *)shareSnsValues{
    if (![_shareSnsValues isEqualToArray:shareSnsValues]) {
        _shareSnsValues = shareSnsValues;
        [[_itemsScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int index = 0; index < _shareSnsValues.count; index++) {
            NSString *snsName = _shareSnsValues[index];
            CodingShareView_Item *item = [CodingShareView_Item itemWithSnsName:snsName];
            CGPoint pointO = CGPointZero;
            pointO.x = [CodingShareView_Item itemWidth] * (index%kCodingShareView_NumPerLine);
            pointO.y = [CodingShareView_Item itemHeight] * (index/kCodingShareView_NumPerLine);
            [item setOrigin:pointO];
            item.clickedBlock = ^(NSString *snsName){
                [self p_shareItemClickedWithSnsName:snsName];
            };
            [_itemsScrollView addSubview:item];
        }
        CGFloat contentHeight = kCodingShareView_TopHeight + kCodingShareView_BottomHeight + ((_shareSnsValues.count - 1)/kCodingShareView_NumPerLine + 1)* [CodingShareView_Item itemHeight];
        [self.contentView setSize:CGSizeMake(kScreen_Width, contentHeight)];
    }
}

#pragma mark common M
+ (instancetype)sharedInstance{
    static MartShareView *shared_instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

+ (NSDictionary *)snsNameDict{
    static NSDictionary *snsNameDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        snsNameDict = @{
                        @"coding-net": @"Coding冒泡",
                        @"copylink": @"复制链接",
                        @"sina": @"新浪微博",
                        @"qzone": @"QQ空间",
                        @"qq": @"QQ好友",
                        @"wxtimeline": @"朋友圈",
                        @"wxsession": @"微信好友",
                        @"inform": @"举报",
                        };
    });
    return snsNameDict;
}

+ (instancetype)showShareViewWithObj:(NSObject *)curObj{
    return [[self sharedInstance] showShareViewWithObj:curObj];
}

+(NSArray *)supportSnsValuesWithObj:(NSObject *)obj{
    NSMutableArray *resultSnsValues = [@[
                                         @"wxsession",
                                         @"wxtimeline",
                                         @"qq",
                                         @"qzone",
                                         @"sina",
                                         @"coding-net",
                                         @"copylink",
                                         @"inform",
                                         ] mutableCopy];
    if (![self p_canOpen:@"weixin://"]) {
        [resultSnsValues removeObjectsInArray:@[
                                                @"wxsession",
                                                @"wxtimeline",
                                                ]];
    }
    if (![self p_canOpen:@"mqqapi://"]) {
        [resultSnsValues removeObjectsInArray:@[
                                                @"qq",
                                                @"qzone",
                                                ]];
    }
    if (![self p_canOpen:@"weibosdk://request"]) {
        [resultSnsValues removeObjectsInArray:@[@"sina"]];
    }
    if (![self p_canOpen:@"coding-net://"]) {
        [resultSnsValues removeObjectsInArray:@[@"coding-net"]];
    }
    if (!obj) {
        [resultSnsValues removeObjectsInArray:@[@"coding-net", @"copylink", @"inform"]];
    }
    return resultSnsValues;
}

+(BOOL)p_canOpen:(NSString*)url{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

- (instancetype)showShareViewWithObj:(NSObject *)curObj{
    self.objToShare = curObj;
    [self p_show];
    return self;
}

- (void)p_show{
    [self p_checkTitle];
    [self p_checkShareSnsValues];
    
    if (self.shareSnsValues.count <= 0) {
        return;
    }
    
    [kKeyWindow addSubview:self];

    //animate to show
    CGPoint endCenter = self.contentView.center;
    endCenter.y -= CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.contentView.center = endCenter;
    } completion:nil];
}
- (void)p_dismiss{
    //animate to dismiss
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)p_dismissWithCompletionBlock:(void (^)(void))completionBlock{
    //animate to dismiss
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completionBlock) {
            completionBlock();
        }
    }];
}
- (void)p_checkShareSnsValues{
    self.shareSnsValues = [MartShareView supportSnsValuesWithObj:_objToShare];
}

- (void)p_shareItemClickedWithSnsName:(NSString *)snsName{
    void (^completion)() = ^(){
        [self p_doShareToSnsName:snsName];
    };
    [self p_dismissWithCompletionBlock:completion];
}

- (void)p_doShareToSnsName:(NSString *)snsName{
    if ([_objToShare isKindOfClass:[Reward class]]) {
        [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"项目分享_%@", snsName]];
    }
    if ([snsName isEqualToString:@"copylink"]) {
        [[UIPasteboard generalPasteboard] setString:[self p_shareLinkStr]];
        [NSObject showHudTipStr:@"链接已拷贝到粘贴板"];
    }else if ([snsName isEqualToString:@"coding-net"]){
        [self goToCoding];
    }else if ([snsName isEqualToString:@"inform"]){
        [self goToInform];
    }else{
        [[UMSocialControllerService defaultControllerService] setSocialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        if (snsPlatform) {
            snsPlatform.snsClickHandler([EABaseViewController presentingVC],[UMSocialControllerService defaultControllerService],YES);
        }
    }
}
#pragma mark objToShare
- (void)p_checkTitle{
    NSString *title;
    if ([_objToShare isKindOfClass:[Reward class]]) {
        title = @"项目分享到";
    }else if ([_objToShare isKindOfClass:[UIWebView class]]){
        title = @"链接分享到";
    }else if ([_objToShare isKindOfClass:[NSURL class]]){
        title = @"链接分享到";
    }else{
        title = @"App 分享到";
    }
    _titleL.text = title;
}

- (NSString *)p_shareLinkStr{
    NSString *linkStr;
    if ([_objToShare isKindOfClass:[Reward class]]) {
        linkStr = [(Reward *)_objToShare toShareLinkStr];
    }else if ([_objToShare isKindOfClass:[UIWebView class]]){
        linkStr = [(UIWebView *)_objToShare request].URL.absoluteString;
    }else if ([_objToShare isKindOfClass:[NSURL class]]){
        linkStr = [(NSURL *)_objToShare absoluteString];
    }else{
        linkStr = [NSObject baseURLStr];
    }
    return linkStr;
}
- (NSString *)p_shareTitle{
    NSString *title;
    if ([_objToShare isKindOfClass:[Reward class]]) {
        title = [(Reward *)_objToShare name];
    }else if ([_objToShare isKindOfClass:[UIWebView class]]){
        title = @"码市";
    }else{
        title = @"码市 - 基于云技术的软件外包服务平台";
    }
    return title;
}
- (NSString *)p_shareText{
    NSString *text;
    if ([_objToShare isKindOfClass:[Reward class]]) {
        text = [(Reward *)_objToShare plain_content];
    }else if ([_objToShare isKindOfClass:[UIWebView class]]){
        text =[(UIWebView *)_objToShare stringByEvaluatingJavaScriptFromString:@"document.title"];
    }else{
        text = @"#Coding 码市# 你有想法，我来实现；基于云技术的软件外包服务平台 http://mart.coding.net";
    }
    return text;
}
- (NSString *)p_imageUrlSquare:(BOOL)needSquare{
    __block NSString *imageUrl = nil;
    if ([_objToShare isKindOfClass:[Reward class]]) {
        imageUrl = [(Reward *)_objToShare cover];
        if (needSquare) {
            imageUrl = [imageUrl urlImageWithCodePathResize:100 crop:YES].absoluteString;
        }
    }
    return imageUrl;
}

- (NSURL *)p_shareCodingTweetURL{
    NSString *callback, *type, *content;
    BOOL has_image_in_pasteboard = NO;
    callback = kAppScheme;
    type = @"tweet";
    if ([_objToShare isKindOfClass:[Reward class]]) {
        content = [NSString stringWithFormat:@"#Coding 码市# 分享了一个项目《%@》[网页链接](%@)", [self p_shareTitle], [self p_shareLinkStr]];
    }else if (_objToShare){
        content = [NSString stringWithFormat:@"#Coding 码市# %@ %@", [self p_shareTitle], [self p_shareLinkStr]];
    }else{
        content = [NSString stringWithFormat:@"#Coding 码市# 基于云技术的软件外包服务平台 %@", [self p_shareLinkStr]];
    }
    content = [content URLEncoding];
    
    NSString *imageStr = [self p_imageUrlSquare:NO];
    if (imageStr.length > 0) {
        NSURL *imageURL = [NSURL URLWithString:imageStr];
        if (imageURL) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            if ([manager diskImageExistsForURL:imageURL]) {
                UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:imageURL.absoluteString];
                if (image) {
                    has_image_in_pasteboard = YES;
                    [[UIPasteboard generalPasteboard] setImage:image];
                }
            }
        }
    }
    NSURL *shareURL;
    NSString *shareStr = [NSString stringWithFormat:@"coding-net://mart.coding.net?callback=%@&type=%@&content=%@&has_image_in_pasteboard=%@", callback, type, content, has_image_in_pasteboard? @(1): @(0)];
    shareURL = [NSURL URLWithString:shareStr];
    return shareURL;
}

#pragma mark Coding Tweet
- (void)goToCoding{
//    coding-net
    [[UIApplication sharedApplication] openURL:[self p_shareCodingTweetURL]];
}

- (void)goToInform{
    [ReportIllegalViewController showReportWithIllegalContent:[self p_shareLinkStr] andType:IllegalContentTypeWebsite];
}

#pragma mark UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    NSLog(@"didFinishGetUMSocialDataInViewController : %@",response);
    if(response.responseCode == UMSResponseCodeSuccess){
        NSString *snsName = [[response.data allKeys] firstObject];
        NSLog(@"share to sns name is %@",snsName);
        [NSObject performSelector:@selector(showStatusBarSuccessStr:) withObject:@"分享成功" afterDelay:0.3];
    }
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    //设置分享内容，和回调对象
    {
        socialData.shareText = [self p_shareText];
        socialData.shareImage = [UIImage imageNamed:@"app_icon"];
        NSString *imageUrl = [self p_imageUrlSquare:![platformName isEqualToString:@"sina"]];
        socialData.urlResource.url = imageUrl;
        socialData.urlResource.resourceType = imageUrl.length > 0? UMSocialUrlResourceTypeImage: UMSocialUrlResourceTypeDefault;
    }
    if ([platformName isEqualToString:@"wxsession"]) {
        UMSocialWechatSessionData *wechatSessionData = [UMSocialWechatSessionData new];
        wechatSessionData.title = [self p_shareTitle];
        wechatSessionData.url = [self p_shareLinkStr];
        wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
        socialData.extConfig.wechatSessionData = wechatSessionData;
    }else if ([platformName isEqualToString:@"wxtimeline"]){
        UMSocialWechatTimelineData *wechatTimelineData = [UMSocialWechatTimelineData new];
        wechatTimelineData.shareText = _objToShare? [NSString stringWithFormat:@"%@ - Coding 码市", [self p_shareTitle]]: [self p_shareTitle];
        wechatTimelineData.url = [self p_shareLinkStr];
        wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        socialData.extConfig.wechatTimelineData = wechatTimelineData;
    }else if ([platformName isEqualToString:@"qq"]){
        UMSocialQQData *qqData = [UMSocialQQData new];
        qqData.title = [self p_shareTitle];
        qqData.url = [self p_shareLinkStr];
        qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        socialData.extConfig.qqData = qqData;
    }else if ([platformName isEqualToString:@"qzone"]){
        UMSocialQzoneData *qzoneData = [UMSocialQzoneData new];
        qzoneData.title = [self p_shareTitle];
        qzoneData.url = [self p_shareLinkStr];
        socialData.extConfig.qzoneData = qzoneData;
    }else if ([platformName isEqualToString:@"sina"]){
        NSString *shareText;
        if ([_objToShare isKindOfClass:[Reward class]]) {
            shareText = [NSString stringWithFormat:@"#Coding 码市# 分享了一个项目《%@》%@", [self p_shareTitle], [self p_shareLinkStr]];
        }else if (_objToShare){
            shareText = [NSString stringWithFormat:@"#Coding 码市# %@ %@", [self p_shareTitle], [self p_shareLinkStr]];
        }else{
            shareText = [NSString stringWithFormat:@"#Coding 码市# 基于云技术的软件外包服务平台 %@", [self p_shareLinkStr]];
        }
        socialData.shareText = shareText;
        socialData.shareImage = nil;
    }
    NSLog(@"%@ : %@", platformName, socialData);
}

-(BOOL)isDirectShareInIconActionSheet{
    return YES;
}

@end

@interface CodingShareView_Item ()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleL;
@end

@implementation CodingShareView_Item

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [CodingShareView_Item itemWidth], [CodingShareView_Item itemHeight]);
        _button = [UIButton new];
        [self addSubview:_button];
        CGFloat padding_button = kScaleFrom_iPhone5_Desgin(kCodingShareView_Padding);
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(padding_button);
            make.right.equalTo(self).offset(-padding_button);
            make.height.mas_equalTo([CodingShareView_Item itemWidth] - 2*padding_button);
        }];
        _titleL = ({
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithHexString:@"0x666666"];
            label;
        });
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(15);
            make.top.equalTo(self.button.mas_bottom).offset(kCodingShareView_Padding);
        }];
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClicked{
//    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"umeng_social_%@", _snsName]];
    if (self.clickedBlock) {
        self.clickedBlock(_snsName);
    }
}

- (void)setSnsName:(NSString *)snsName{
    if (![_snsName isEqualToString:snsName]) {
        _snsName = snsName;
        NSString *imageName = [NSString stringWithFormat:@"share_btn_%@", snsName];
        NSString *title = [[MartShareView snsNameDict] objectForKey:snsName];
        [_button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        _titleL.text = title;
    }
}

+ (instancetype)itemWithSnsName:(NSString *)snsName{
    CodingShareView_Item *item = [self new];
    item.snsName = snsName;
    return item;
}

+ (CGFloat)itemWidth{
    return kScreen_Width/kCodingShareView_NumPerLine;
}

+ (CGFloat)itemHeight{
    return [self itemWidth] + 20;
}

@end
