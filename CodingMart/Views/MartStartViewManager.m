//
//  MartStartViewManager.m
//  CodingMart
//
//  Created by Ease on 15/11/25.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kMartStartViewPath @"ea_mart_start_banner"

#import "MartStartViewManager.h"
#import "Coding_NetAPIManager.h"
#import "SDWebImageManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface MartStartViewManager ()

@end

@implementation MartStartViewManager
+ (void)refreshStartModel{
    [[Coding_NetAPIManager sharedManager] get_StartModelBlock:^(id data, NSError *error) {
        if (!error) {
            [self p_handleRemoteData:data];
        }
    }];
}

+ (void)p_handleRemoteData:(id)data{
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //保存数据
    [NSObject saveResponseData:data toPath:kMartStartViewPath];
    
    //下载图片
    MartStartModel *model = [NSObject objectOfClass:@"MartStartModel" fromJSON:data[@"data"]];
    if (model) {
        NSURL *imageURL = [NSURL URLWithString:model.image];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if (![manager diskImageExistsForURL:imageURL]) {
            [manager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && cacheType != SDImageCacheTypeDisk) {
                    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
                }
            }];
        }
    }
}

+ (MartStartView *)makeStartView{
    NSDictionary *data = [NSObject loadResponseWithPath:kMartStartViewPath];
    MartStartModel *model = [NSObject objectOfClass:@"MartStartModel" fromJSON:data[@"data"]];
    if (!model || model.image.length <= 0) {
        return nil;
    }
    NSURL *imageURL = [NSURL URLWithString:model.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if ([manager diskImageExistsForURL:imageURL]) {
        model.sd_image = [[manager imageCache] imageFromDiskCacheForKey:imageURL.absoluteString];
    }
    if (!model.sd_image) {
        return nil;
    }
    return [MartStartView viewWithModel:model];
}

@end


@implementation MartStartModel

@end

@interface MartStartView ()
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UIButton *skipBtn;
@end

@implementation MartStartView

+ (instancetype)viewWithModel:(MartStartModel *)model{
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(MartStartModel *)model{
    self = [super initWithFrame:kScreen_Bounds];
    if (self) {
        _model = model;
        
        _imageV = [[UIImageView alloc] initWithImage:_model.sd_image];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        [_imageV bk_whenTapped:^{
            [weakSelf imageViewTapped];;
        }];
        
        _skipBtn = [UIButton new];
        [_skipBtn setImage:[UIImage imageNamed:@"skip_button"] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_imageV];
        [self addSubview:_skipBtn];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            CGFloat padding = 20;
            make.top.equalTo(self).offset(20 + padding);
            make.right.equalTo(self).offset(-padding);
        }];
    }
    return self;
}

- (void)imageViewTapped{
    static bool has_taped = false;
    if (has_taped) {//只处理一次
        return;
    }else{
        has_taped = true;
    }
    
    [[UIViewController presentingVC] goToWebVCWithUrlStr:_model.link title:nil];
    [self dismiss];
}

- (void)dismiss{
    static bool has_dismissed = false;
    if (has_dismissed) {//只显示一次，也只消失一次
        return;
    }else{
        has_dismissed = true;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(weakSelf);
        }
    }];
}

- (void)show{
    self.alpha = 1.0;
    [kKeyWindow addSubview:self];
    [kKeyWindow bringSubviewToFront:self];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismiss];
    });
}

- (void)showWithCompletion:(void(^)(MartStartView *easeStartView))completionHandler{
    _completionHandler = completionHandler;
    [self show];
}

@end