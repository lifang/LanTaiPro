//
//  DataService.m
//  LanTaiPro
//
//  Created by lantan on 14-6-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DataService.h"

@implementation DataService

- (id)init
{
    self = [super init];
    if (!self) {
        
    }
    return self;
}


+ (DataService *)sharedService
{
    static dispatch_once_t once;
    static DataService *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}
@end
