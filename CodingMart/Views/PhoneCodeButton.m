//
//  PhoneCodeButton.m
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PhoneCodeButton.h"

@interface PhoneCodeButton ()
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;
@end

@implementation PhoneCodeButton

- (instancetype)init{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _normalStateTitle = self.titleLabel.text;
    self.enabled = self.isEnabled;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    UIColor *foreColor = [UIColor colorWithHexString:enabled? @"0x4289DB": @"0xCCCCCC"];
    if (!_hasBG) {
        [self doBorderWidth:1.0 color:foreColor cornerRadius:2.0];
        [self setTitleColor:foreColor forState:UIControlStateNormal];
    }else{
        self.backgroundColor = foreColor;
    }
    if (!_normalStateTitle) {
        _normalStateTitle = @"发送验证码";
    }
    if (enabled) {
        [self setTitle:_normalStateTitle forState:UIControlStateNormal];
    }else if ([self.titleLabel.text isEqualToString:_normalStateTitle]){
        [self setTitle:@"正在发送..." forState:UIControlStateNormal];
    }
}

- (void)startUpTimer{
    _durationToValidity = 60;
    
    if (self.isEnabled) {
        self.enabled = NO;
    }
    [self setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%.0f 秒", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

@end
