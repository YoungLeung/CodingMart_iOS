//
//  CountryCodeListViewController.h
//  CodingMart
//
//  Created by Ease on 16/5/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface CountryCodeListViewController : EABaseTableViewController
@property (copy, nonatomic) void(^selectedBlock)(NSDictionary *countryCodeDict);//country, country_code, iso_code


+ (instancetype)storyboardVC;

@end
