//
//  CannotLoginViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, CannotLoginReasonType) {
    CannotLoginReasonForget = 0,
    CannotLoginReasonNonSet
};

@interface CannotLoginViewController : BaseTableViewController
@property (assign, nonatomic) CannotLoginReasonType reasonType;
@property (strong, nonatomic) NSString *userStr;
@end
