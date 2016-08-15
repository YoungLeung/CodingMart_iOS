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
        _imageV.backgroundColor = self.backgroundColor = [UIColor clearColor];
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
    if (imageNames.count <= 0) {
        return;
    }
    MartFunctionTipView *tipV = [MartFunctionTipView new];
    tipV.imageNames = imageNames;
    [tipV show];
}

+ (void)showFunctionImages:(NSArray *)imageNames onlyOneTime:(BOOL)onlyOneTime{
    if (imageNames.count <= 0) {
        return;
    }
    if (onlyOneTime) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *hasShowedImages = @[].mutableCopy;
        for (NSString *imageName in imageNames) {
            if ([defaults objectForKey:imageName]) {
                [hasShowedImages addObject:imageName];
            }else{
                [defaults setObject:@1 forKey:imageName];
            }
        }
        NSMutableArray *needShowImages = imageNames.mutableCopy;
        [needShowImages removeObjectsInArray:hasShowedImages];
        imageNames = needShowImages;
    }
    [self showFunctionImages:imageNames];
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
