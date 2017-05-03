//
//  MartCaptchaCell.h
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_MartCaptchaCell @"MartCaptchaCell"

#import <UIKit/UIKit.h>

@interface MartCaptchaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)refreshImgData;
@end
