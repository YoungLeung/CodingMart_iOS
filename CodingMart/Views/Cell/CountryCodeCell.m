//
//  CountryCodeCell.m
//  CodingMart
//
//  Created by Ease on 16/5/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CountryCodeCell.h"

@interface CountryCodeCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UILabel *rightL;

@end

@implementation CountryCodeCell
- (void)setCountryCodeDict:(NSDictionary *)countryCodeDict{
    _countryCodeDict = countryCodeDict;
    _leftL.text = _countryCodeDict[@"country"];
    _rightL.text = [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]];
}
@end
