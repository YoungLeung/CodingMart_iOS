//
//  IdentityAuthenticationModel.h
//  CodingMart
//
//  Created by HuiYang on 15/11/18.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

//id=用户编号&name=姓名&identity=身份证&alipay=支付宝帐号&identity_img_front=身份证照片正面 URL&identity_img_back=身份证照片背面 URL&identity_img_auth=授权说明照片 URL

@interface IdentityAuthenticationModel : NSObject

-(id)initForlocalCache;

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *identity;
@property(nonatomic,strong)NSString *alipay;
@property(nonatomic,strong)NSString *identity_img_front;
@property(nonatomic,strong)NSString *identity_img_back;
@property(nonatomic,strong)NSString *identity_img_auth;

//             未认证 0
//             认证通过 1
//             认证失败 2
//             认证中 3
@property(nonatomic,strong)NSNumber *identityIsPass;

@property(nonatomic,assign)BOOL canPost;
@property(nonatomic,assign)BOOL isAgree;

- (NSDictionary *)toParams;

- (BOOL)isSameTo:(IdentityAuthenticationModel *)obj;

+(void)cacheUserName:(NSString*)userName;
+(NSString*)getcacheUserName;
@end
