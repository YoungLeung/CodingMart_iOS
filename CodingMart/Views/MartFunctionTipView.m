//
//  MartFunctionTipView.m
//  CodingMart
//
//  Created by Ease on 16/8/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartFunctionTipView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface MartFunctionTipView ()
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) NSArray *imageNames;
@property (assign, nonatomic) NSUInteger curIndex;
@end

@implementation MartFunctionTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageV = [UIImageView new];
        _imageV.frame = self.frame = kScreen_Frame;
        [self addSubview:_imageV];
        
        WEAKSELF;
        _imageV.userInteractionEnabled = YES;
        [_imageV bk_whenTapped:^{
            [weakSelf tapped];
        }];
    }
    return self;
}

- (void)tapped{
    _curIndex += 1;
    if (_imageNames.count > _curIndex) {
        _imageV.image = [UIImage imageNamed:_imageNames[_curIndex]];
    }else{
        [self dismiss];
    }
}

+ (void)showFunctionImages:(NSArray *)imageNames{
    MartFunctionTipView *tipV = [MartFunctionTipView new];
    tipV.imageNames = imageNames;
    [tipV show];
}

- (void)show{
    if (_imageNames.count <= 0) {
        return;
    }
    _curIndex = 0;
    _imageV.image = [UIImage imageNamed:_imageNames[_curIndex]];
    [kKeyWindow addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
