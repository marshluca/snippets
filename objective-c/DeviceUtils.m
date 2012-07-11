//
//  DeviceUtils.m
//  Share
//
//  Created by Lin Zhang on 11-7-4.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "DeviceUtils.h"


@implementation UIDevice (Utils)

+ (NSString *)uniqueIdentifier
{
    return  [[self currentDevice] uniqueIdentifier];
}

+ (NSString *)systemVersion
{
    return  [[self currentDevice] systemVersion];
}

+ (NSString *)systemName
{
    return  [[self currentDevice] systemName];
}

+ (NSString *)name
{
    return  [[self currentDevice] name];
}

+ (NSString *)model
{
    return  [[self currentDevice] model];
}

+ (NSString *)localeIdentifier
{
    return  [[NSLocale currentLocale] localeIdentifier];
}

@end
