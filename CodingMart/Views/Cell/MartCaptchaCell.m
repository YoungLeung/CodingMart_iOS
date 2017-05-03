//
//  MartCaptchaCell.m
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "MartCaptchaCell.h"

#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "Coding_NetAPIManager.h"

@implementation MartCaptchaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    __weak typeof(self) wealSelf = self;
    [_imgV bk_whenTapped:^{
        [wealSelf refreshImgData];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self refreshImgData];
}

- (void)refreshImgData{
    if (_activityIndicator.isAnimating) {
        return;
    }
    [_activityIndicator startAnimating];
    __weak typeof(self) weakSelf = self;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/account/captcha" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        [weakSelf.activityIndicator stopAnimating];
        if ([data isKindOfClass:[NSDictionary class]] && data[@"image"]) {
            NSString *imageStr = data[@"image"];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[imageStr componentsSeparatedByString:@","].lastObject options:0];
            weakSelf.imgV.image = [UIImage imageWithData:imageData];
        }
    }];
    
//    [_imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getCaptcha", [NSObject codingURLStr]]] placeholderImage:nil options:(SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageHandleCookies) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [_activityIndicator stopAnimating];
//    }];
}

@end
