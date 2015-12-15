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

@implementation MartCaptchaCell

- (void)awakeFromNib {
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
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/getCaptcha", [NSObject codingURLStr]]] placeholderImage:nil options:(SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageHandleCookies) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_activityIndicator stopAnimating];
    }];
}

@end
