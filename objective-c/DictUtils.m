//
//  DictUtils.m
//  Share
//
//  Created by Lin Zhang on 11-5-16.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "DictUtils.h"

@implementation NSDictionary (Utils)

- (NSString *)sortedQueryString;
{
  NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity:[[self allKeys] count]];
  NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
  for (NSString *key in sortedKeys) {
    NSString *part = [[NSString alloc] initWithFormat:@"%@=%@", key, [self valueForKey:key]];
    [parts addObject:part];
    [part release];
  }
  NSString *queryString = [parts componentsJoinedByString:@"&"];
  [parts release];

  return queryString;
}

@end
