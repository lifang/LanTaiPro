//
//  LTDataShare.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTDataShare.h"

@implementation LTDataShare

- (id)init{
    self = [super init];
    if (!self) {
        
    }
    return self;
}

+ (LTDataShare *)sharedService {
    static dispatch_once_t once;
    static LTDataShare *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}
@end
