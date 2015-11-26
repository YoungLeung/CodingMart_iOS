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
    params[@"identity_img_auth"] = _identity_img_auth;
    params[@"identity_img_back"] = _identity_img_back;
    params[@"identity_img_front"] = _identity_img_front;
    params[@"name"] = _name;
    params[@"alipay"] = _alipay;
    return params;
}

-(BOOL)canPost
{
    if (self.identity.length>15 && self.identity.length<30 && self.name.length <30)
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

-(void)setId:(NSString *)id
{
    _id=id;
    if (id.length==0)
    {
        [self.localCache removeObjectForKey:@"id"];
    }else
    {
    [self.localCache setObject:id forKey:@"id"];
    }
    [self updateLocalCache];
}

-(void)setIdentityIsPass:(NSNumber *)identityIsPass
{
    _identityIsPass=identityIsPass;
    
    [self.localCache setObject:identityIsPass forKey:@"identityIsPass"];
    [self updateLocalCache];
}

-(void)setIdentity:(NSString *)identity
{
    _identity =identity;
    if (identity.length==0)
    {
        [self.localCache removeObjectForKey:@"identity"];
    }else
    {
    [self.localCache setObject:identity forKey:@"identity"];
    }
    [self updateLocalCache];
}

-(void)setIdentity_img_auth:(NSString *)identity_img_auth
{
    _identity_img_auth=identity_img_auth;
    if (identity_img_auth.length==0)
    {
        [self.localCache removeObjectForKey:@"identity_img_auth"];
    }else
    {
    [self.localCache setObject:identity_img_auth forKey:@"identity_img_auth"];
    }
    [self updateLocalCache];
}
-(void)setIdentity_img_back:(NSString *)identity_img_back
{
    _identity_img_back=identity_img_back;
    if (identity_img_back.length==0)
    {
        [self.localCache removeObjectForKey:@"identity_img_back"];
    }else
    {
    [self.localCache setObject:identity_img_back forKey:@"identity_img_back"];
    }
    [self updateLocalCache];
}
-(void)setIdentity_img_front:(NSString *)identity_img_front
{
    _identity_img_front=identity_img_front;
    if (identity_img_front.length==0)
    {
        [self.localCache removeObjectForKey:@"identity_img_front"];
    }else
    {
    
    [self.localCache setObject:identity_img_front forKey:@"identity_img_front"];
    }
    [self updateLocalCache];
}
-(void)setName:(NSString *)name
{
    _name=name;
    
    if (name.length==0)
    {
         [self.localCache removeObjectForKey:@"name"];
    }else
    {
         [self.localCache setObject:name forKey:@"name"];
    }

    [self updateLocalCache];
}
-(void)setAlipay:(NSString *)alipay
{
    _alipay=alipay;
    if (alipay.length==0)
    {
        [self.localCache removeObjectForKey:@"alipay"];
    }else
    {
    [self.localCache setObject:alipay forKey:@"alipay"];
    }
    [self updateLocalCache];
}

@end
