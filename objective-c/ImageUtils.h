//
//  ImageUtils.h
//  Share
//
//  Created by Lin Zhang on 11-6-15.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Utils)

/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Creates an image with a path compontent relative to
 * the main bundle's resource path
 */
+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent;

/*
 * Scales the image to the given size, NOT aspect
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 * Aspect scale with border color, and corner radius, and shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size
                  withBorderSize:(CGFloat)borderSize
                     borderColor:(UIColor*)aColor
                    cornerRadius:(CGFloat)aRadius
                    shadowOffset:(CGSize)aOffset
                shadowBlurRadius:(CGFloat)aBlurRadius
                     shadowColor:(UIColor*)aShadowColor;

/*
 * Aspect scale with a shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size
                withShadowOffset:(CGSize)aOffset
                      blurRadius:(CGFloat)aRadius
                           color:(UIColor*)aColor;

/*
 * Aspect scale with corner radius
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius;

/*
 * Aspect scales the image to a max size
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size;

/*
 * aspect scales the image to a rect size
 */
- (UIImage*)aspectScaleToSize:(CGSize)size;

/*
 * aspect scales the image to a rect size
 */
- (UIImage *)scaleAndRotateImage:(float)maxResolution;

/*
 * Masks the context with the image, then fills with the color
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor;

/*
 * Masks the context with the image, then fills with the gradient (two colors in an array)
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors;


@end


/*
 *
 */
@interface UIImage (scale)

+(UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size;
+(UIImage*)createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+(UIImage*)getRectImageFromImage:(UIImage *)image withRect:(CGRect)rect;

@end
