//
//  FeedBackInfo.h
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackInfo : NSObject
@property (strong, nonatomic) NSString *name, *phone, *email, *content, *j_captcha, *global_key;
@property (strong, nonatomic) NSArray *typeList;

+ (FeedBackInfo *)makeFeedBack;
- (NSString *)hasErrorTip;
- (NSDictionary *)toPostParams;
@end
