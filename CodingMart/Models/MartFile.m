//
//  MartFile.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartFile.h"

@implementation MartFile
- (NSString *)url{
    return _url ?: _fileUrl;
}

- (NSString *)filename{
    return _filename ?: _fileName;
}
@end
