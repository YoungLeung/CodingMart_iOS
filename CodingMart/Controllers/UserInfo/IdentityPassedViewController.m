//
//  IdentityPassedViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "IdentityPassedViewController.h"
#import "IdentityAuthenticationModel.h"
#import "UIImageView+WebCache.h"
#import "Login.h"

@interface IdentityPassedViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *identityNumL;

@property (weak, nonatomic) IBOutlet UIView *headerV;
@property (weak, nonatomic) IBOutlet UILabel *headerL;

@property (strong,nonatomic) IdentityAuthenticationModel *model;

@end

@implementation IdentityPassedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    CGFloat headerLHeight = [_headerL.text getHeightWithFont:_headerL.font constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)];
    _headerV.height = 40 + headerLHeight;
    
    [_userIconV sd_setImageWithURL:[[Login curLoginUser].avatar urlImageWithCodePathResize:70* 2]];
    _nameL.text = [Login curLoginUser].name;
    NSString *displayStr = _model.identity;
    if (displayStr.length > 5) {
        displayStr = [displayStr stringByReplacingCharactersInRange:NSMakeRange(3, displayStr.length - 5) withString:@"*********"];
    }
    _identityNumL.text = displayStr;
}


- (void)setIdentity_server_CacheDataDic:(NSDictionary *)identity_server_CacheDataDic{
    _identity_server_CacheDataDic = identity_server_CacheDataDic;
    _model = _identity_server_CacheDataDic? [NSObject objectOfClass:@"IdentityAuthenticationModel" fromJSON:_identity_server_CacheDataDic]: [IdentityAuthenticationModel new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 20;
}
@end
