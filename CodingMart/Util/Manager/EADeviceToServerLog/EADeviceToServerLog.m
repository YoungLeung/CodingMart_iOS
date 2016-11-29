//
//  EADeviceToServerLog.m
//  CodingMart
//
//  Created by Ease on 2016/11/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kEALogKey_StartTime @"startTime"
#define kEALogKey_FinishTime @"finishTime"
#define kEALogKey_Error @"error"

#import <netdb.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import "EADeviceToServerLog.h"
#import "EANetTraceRoute.h"
#import "Login.h"

@interface EADeviceToServerLog ()
@property (strong, nonatomic) NSMutableDictionary *logDict;
@property (strong, nonatomic) NSArray *hostStrList, *portList;
@end

@implementation EADeviceToServerLog

+ (instancetype)shareManager{
    static EADeviceToServerLog *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hostStrList = @[@"coding.net",
                         @"git.coding.net",
                         @"mart.coding.net"];
        _portList = @[@(80),
                      @(443)];
    }
    return self;
}

- (void)p_resetLog{
    if (!_logDict) {
        _logDict = @{}.mutableCopy;
    }else{
        [_logDict removeAllObjects];
    }
//    添加 App 信息
    _logDict[@"userAgent"] = [NSObject userAgent];
    _logDict[@"globalKey"] = [Login curLoginUser].global_key;
}

- (void)p_addLog:(NSDictionary *)dict{
    for (NSString *key in dict) {
        _logDict[key] = dict[key];
    }
}

- (NSNumber *)p_curTime{
    return @((long)(1000 *[[NSDate date] timeIntervalSince1970]));
}

- (NSString*)p_dictionaryToJson:(NSDictionary *)dict{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)start{
    [self postOnce];
}

- (void)postOnce{
    [self p_resetLog];
    __weak typeof(self) weakSelf = self;
    [self getLocalIPBlock:^(NSDictionary *dictLocalIP) {
        [weakSelf p_addLog:dictLocalIP];
        [weakSelf getHostIPsBlock:^(NSDictionary *dictHostIPs) {
            [weakSelf p_addLog:dictHostIPs];
            [weakSelf getHostPortsBlock:^(NSDictionary *dictHostPorts) {
                [weakSelf p_addLog:dictHostPorts];
                [weakSelf getHostMtrsBlock:^(NSDictionary *dictHostMtrs) {
                    [weakSelf p_addLog:dictHostMtrs];
                    [weakSelf getGitsBlock:^(NSDictionary *dictGits) {
                        [weakSelf p_addLog:dictGits];
                        NSLog(@"%@", [weakSelf p_dictionaryToJson:weakSelf.logDict]);
                    }];
                }];
            }];
        }];
    }];
}

- (void)getLocalIPBlock:(void(^)(NSDictionary *dictLocalIP))block{
    NSURL *url = [NSURL URLWithString:@"http://ip.cn"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:@"curl/7.41.0" forHTTPHeaderField:@"User-Agent"];
    NSMutableDictionary *dictLocalIP = @{kEALogKey_StartTime: [self p_curTime]}.mutableCopy;
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dictLocalIP[@"log"] = dataStr;
        dictLocalIP[kEALogKey_FinishTime] = [self p_curTime];
        if (error) {
            dictLocalIP[kEALogKey_Error] = error.description;
        }
        block(@{@"localIp": dictLocalIP});
    }];
    [task resume];
}

- (void)getHostIPsBlock:(void(^)(NSDictionary *dictHostIPs))block{
    static NSMutableArray *dictHostIPList;
    if (dictHostIPList.count == _hostStrList.count){
        block(@{@"hostIp": dictHostIPList});
        dictHostIPList = nil;
    }else{
        if (!dictHostIPList) {
            dictHostIPList = @[].mutableCopy;
        }
        __weak typeof(self) weakSelf = self;
        [self getHost:_hostStrList[dictHostIPList.count] ipBlock:^(NSDictionary *dictHostIP) {
            [dictHostIPList addObject:dictHostIP];
            [weakSelf getHostIPsBlock:block];
        }];
    }
}

- (void)getHost:(NSString *)hostStr ipBlock:(void(^)(NSDictionary *dictHostIP))block{
    NSMutableDictionary *dictHostIP = @{kEALogKey_StartTime: [self p_curTime]}.mutableCopy;
    dictHostIP[@"host"] = hostStr;
    dictHostIP[@"ip"] = [self p_getIPWithHostName:hostStr];
    dictHostIP[kEALogKey_FinishTime] = [self p_curTime];
    if (!dictHostIP[@"ip"]) {
        dictHostIP[kEALogKey_Error] = @"域名 ip 解析失败";
    }
    block(dictHostIP);
}

- (NSString *)p_getIPWithHostName:(NSString *)hostName{
    struct hostent *hs;
    struct sockaddr_in server;
    if ((hs = gethostbyname([hostName UTF8String])) != NULL) {
        server.sin_addr = *((struct in_addr*)hs->h_addr_list[0]);
        return [NSString stringWithUTF8String:inet_ntoa(server.sin_addr)];
    }
    return nil;
}

- (void)getHostPortsBlock:(void(^)(NSDictionary *dictHostPorts))block{
    static NSMutableArray *dictHostPortList;
    if (dictHostPortList.count == _hostStrList.count * _portList.count){
        block(@{@"portScan": dictHostPortList});
        dictHostPortList = nil;
    }else{
        if (!dictHostPortList) {
            dictHostPortList = @[].mutableCopy;
        }
        __weak typeof(self) weakSelf = self;
        [self getHost:_hostStrList[dictHostPortList.count / _portList.count] port:_portList[dictHostPortList.count % _portList.count] block:^(NSDictionary *dictHostPort) {
            [dictHostPortList addObject:dictHostPort];
            [weakSelf getHostPortsBlock:block];
        }];
    }
}

- (void)getHost:(NSString *)hostStr port:(NSNumber *)port block:(void(^)(NSDictionary *dictHostPort))block{
    NSMutableDictionary *dictHostPort = @{kEALogKey_StartTime: [self p_curTime]}.mutableCopy;
    dictHostPort[@"host"] = hostStr;
    dictHostPort[@"port"] = port;
    NSString *errorStr = nil;
    dictHostPort[@"result"] = @([self p_canLinkToHost:hostStr port:port errorStr:&errorStr]);
    if (errorStr) {
        dictHostPort[kEALogKey_Error] = errorStr;
    }
    dictHostPort[kEALogKey_FinishTime] = [self p_curTime];
    block(dictHostPort);
}

- (BOOL)p_canLinkToHost:(NSString *)hostStr port:(NSNumber *)port errorStr:(NSString **)errorStr{
    int socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    struct hostent *hs;
    if (socketFileDescriptor == -1) {
        *errorStr = @"创建 socket 失败";
        return NO;
    }else if ((hs = gethostbyname([hostStr UTF8String])) == NULL){
        *errorStr = @"IP 地址解析失败";
        return NO;
    }else{
        struct sockaddr_in socketParameters;
        socketParameters.sin_family = AF_INET;
        socketParameters.sin_addr = *((struct in_addr*)hs->h_addr_list[0]);
        socketParameters.sin_port = htons(port.intValue);
        int ret = connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
        close(socketFileDescriptor);
        if (ret == -1) {
            *errorStr = @"socket 连接失败";
            return NO;
        }else{//链接成功
            return YES;
        }
    }
}

- (void)getHostMtrsBlock:(void(^)(NSDictionary *dictHostMtrs))block{
    static NSMutableArray *dictHostMtrList;
    if (dictHostMtrList.count == _hostStrList.count){
        block(@{@"hostMtr": dictHostMtrList});
        dictHostMtrList = nil;
    }else{
        if (!dictHostMtrList) {
            dictHostMtrList = @[].mutableCopy;
        }
        __weak typeof(self) weakSelf = self;
        [self getHost:_hostStrList[dictHostMtrList.count] mtrBlock:^(NSDictionary *dictHostMtr) {
            [dictHostMtrList addObject:dictHostMtr];
            [weakSelf getHostMtrsBlock:block];
        }];
    }
}

- (void)getHost:(NSString *)hostStr mtrBlock:(void(^)(NSDictionary *dictHostMtr))block{
    NSMutableDictionary *dictHostMtr = @{kEALogKey_StartTime: [self p_curTime]}.mutableCopy;
    dictHostMtr[@"host"] = hostStr;
    [EANetTraceRoute getTraceRouteOfHost:hostStr block:^(NSArray *traceRouteList) {
        dictHostMtr[@"mtr"] = traceRouteList;
        dictHostMtr[kEALogKey_FinishTime] = [self p_curTime];
        block(dictHostMtr);
    }];
}

- (void)getGitsBlock:(void(^)(NSDictionary *dictGits))block{
    
    
    block(nil);
}

@end
