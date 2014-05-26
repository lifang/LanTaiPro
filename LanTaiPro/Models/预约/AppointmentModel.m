//
//  AppointmentModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "AppointmentModel.h"

@implementation AppointmentModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"reservations_normal": mts_key(reservationsNormal),
              @"reservations_accepted": mts_key(reservationsAccept),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(reservationsNormal) : AppointModel.class,
             mts_key(reservationsAccept) : AppointModel.class};
}

@end
