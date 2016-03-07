//
//  MartNotification.m
//  CodingMart
//
//  Created by Ease on 16/3/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartNotification.h"

@implementation MartNotification
- (void)setContent:(NSString *)content{
    if (_content != content) {
        _htmlMedia = [HtmlMedia htmlMediaWithString:content showType:MediaShowTypeAll];
        _content = _htmlMedia.contentDisplay;
        NSUInteger reasonLocation = [_content rangeOfString:@"原因"].location;
        
        _hasReason = reasonLocation != NSNotFound;
        if (_hasReason) {
            _contentMain = [_content substringToIndex:reasonLocation - 1];
            _contentReason = [_content substringFromIndex:reasonLocation];
        }else{
            _contentMain = _content;
            _contentReason = nil;
        }
    }
}
@end
