//
//  DeviceUtils.h
//  Share
//
//  Created by Lin Zhang on 11-7-4.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (Utils)

+ (NSString *)uniqueIdentifier;
+ (NSString *)systemVersion;
+ (NSString *)systemName;
+ (NSString *)name;
+ (NSString *)model;
+ (NSString *)localeIdentifier;

@end
