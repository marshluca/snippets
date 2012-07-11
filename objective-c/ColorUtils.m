//
//  ColorUtils.m
//  Share
//
//  Created by Lin Zhang on 11-6-15.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "ColorUtils.h"


@implementation UIColor (Utils)

+ (UIColor *)randomColor
{
	static BOOL seeded = NO;
	if (!seeded) {
		seeded = YES;
		srandom(time(NULL));
	}

	CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;

	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
