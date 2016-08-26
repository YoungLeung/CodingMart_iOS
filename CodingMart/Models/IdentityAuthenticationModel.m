//
//  IdentityAuthenticationModel.m
//  CodingMart
//
//  Created by HuiYang on 15/11/18.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "IdentityAuthenticationModel.h"
#import "DCKeyValueObjectMapping.h"
#import "User.h"
#import "Login.h"
#import "NSString+Verify.h"

//#define kLocalModelKey @"kLocalModelKey"



@interface IdentityAuthenticationModel ()
@property(nonatomic,strong)NSMutableDictionary *localCache;

@end

@implementation IdentityAuthenticationModel
@synthesize id=_id;

-(id)initForlocalCache
{
    DCKeyValueObjectMapping *parser =[DCKeyValueObjectMapping mapperForClass:[IdentityAuthenticationModel class] ];
    
    self = [parser parseDictionary:[IdentityAuthenticationModel loadLocalCacheDic]];
    self.localCache=[IdentityAuthenticationModel loadLocalCacheDic];
   
    return self;
}


- (NSDictionary *)toParams
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"id"] = self.id;
    params[@"identity"] = _identity;
//    params[@"identity_img_auth"] = _identity_img_auth;
    params[@"identity_img_back"] = _identity_img_back;
    params[@"identity_img_front"] = _identity_img_front;
    params[@"name"] = _name;
//    params[@"alipay"] = _alipay;
    return params;
}

-(BOOL)canPost
{
    if (self.identity.length>15 && self.identity.length<30 && self.name.length <30 &&([self.alipay validateEmail]||[self.alipay validateMobile]))
    {
        return YES;
    }else
    {
       return  NO;
    }
}

+(NSMutableDictionary*)loadLocalCacheDic
{
    NSMutableDictionary *dic=nil;
    NSUserDefaults *df =[NSUserDefaults standardUserDefaults];
    if ([df objectForKey:[self localModelStoreKey]])
    {
        //缓存存在
        dic=[NSMutableDictionary dictionaryWithDictionary:[df objectForKey:[self localModelStoreKey]]];
    }else
    {
        dic=[[NSMutableDictionary alloc]init];
    }
    return dic;
}



-(void)updateLocalCache
{
    [[NSUserDefaults standardUserDefaults]setObject:self.localCache forKey:[IdentityAuthenticationModel localModelStoreKey]];
    
}

+(void)cacheUserName:(NSString*)userName;
{
    if (userName)
    {
          [[NSUserDefaults standardUserDefaults]setObject:userName forKey:[IdentityAuthenticationModel localModelStoreKey]];
    }
}

+(NSString*)getcacheUserName
{
    NSString *user=nil;
    user= [[NSUserDefaults standardUserDefaults]objectForKey:[IdentityAuthenticationModel localModelStoreKey]];
    return user;
    
}

+(NSString*)localModelStoreKey
{
    NSString *key =[NSString stringWithFormat:@"kLocalModelKey-%@",[[Login curLoginUser].id stringValue]];
    return key;
}

-(NSString*)id
{
    NSNumber *nub =[Login curLoginUser].id;
    return [nub stringValue];
}

-(void)setIdentityIsPass:(NSNumber *)identityIsPass
{
    _identityIsPass=identityIsPass;
    
    [self.localCache setObject:identityIsPass forKey:@"identityIsPass"];
    [self updateLocalCache];
}

- (BOOL)isSameTo:(IdentityAuthenticationModel *)obj
{
    return
    ([NSObject isSameStr:self.name to:obj.name] &&
     [NSObject isSameStr:self.identity to:obj.identity] &&
     [NSObject isSameStr:self.alipay to:obj.alipay] &&
     [NSObject isSameStr:self.identity_img_front to:obj.identity_img_front] &&
     [NSObject isSameStr:self.identity_img_back to:obj.identity_img_back] &&
     [NSObject isSameStr:self.identity_img_auth to:obj.identity_img_auth]
     );
    return NO;
}

@end
