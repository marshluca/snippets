//
//  ImageUtils.m
//  Share
//
//  Created by Lin Zhang on 11-6-15.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "ImageUtils.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation UIImage (Utils)

CGFloat degreesToRadiens(CGFloat degrees){
	return degrees * M_PI / 180.0f;
}

+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
	NSError* error;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:NULL];
	if(error || !data) {
		return nil;
	} else {
		return [UIImage imageWithData:data];
	}
}

+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent {
	return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathCompontent]];
}

- (UIImage*)scaleToSize:(CGSize)size {	

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(size);
	}
#else
	UIGraphicsBeginImageContext(size);
#endif
	
	[self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size;
	CGFloat vScaleFactor = imageSize.height / size;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	CGRect imageRect = CGRectMake(borderSize, borderSize, newWidth, newHeight);
	
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)), NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
	}
#else
	UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
#endif
	
	
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(imageContext);
	CGPathRef path = NULL;
	
	if (aRadius > 0.0f) {
		
		CGFloat radius;	
		radius = MIN(aRadius, floorf(imageRect.size.width/2));
		float x0 = CGRectGetMinX(imageRect), y0 = CGRectGetMinY(imageRect), x1 = CGRectGetMaxX(imageRect), y1 = CGRectGetMaxY(imageRect);
		
		CGContextBeginPath(imageContext);
		CGContextMoveToPoint(imageContext, x0+radius, y0);
		CGContextAddArcToPoint(imageContext, x1, y0, x1, y1, radius);
		CGContextAddArcToPoint(imageContext, x1, y1, x0, y1, radius);
		CGContextAddArcToPoint(imageContext, x0, y1, x0, y0, radius);
		CGContextAddArcToPoint(imageContext, x0, y0, x1, y0, radius);
		CGContextClosePath(imageContext);
		path = CGContextCopyPath(imageContext);
		CGContextClip(imageContext);
		
	} 
	
	[self drawInRect:imageRect];	
	CGContextRestoreGState(imageContext);
	
	if (borderSize > 0.0f) {
		
		CGContextSetLineWidth(imageContext, borderSize);
		[aColor != nil ? aColor : [UIColor blackColor] setStroke];
		
		if(path == NULL){
			
			CGContextStrokeRect(imageContext, imageRect);
			
		} else {
			
			CGContextAddPath(imageContext, path);
			CGContextStrokePath(imageContext);
			
		}
	}
	
	if(path != NULL){
		CGPathRelease(path);
	}
	
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if (aBlurRadius > 0.0f) {
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)), NO, [[UIScreen mainScreen] scale]);
		} else {
			UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
		}
#else
		UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
#endif
		
		CGContextRef imageShadowContext = UIGraphicsGetCurrentContext();
		
		if (aShadowColor!=nil) {
			CGContextSetShadowWithColor(imageShadowContext, aOffset, aBlurRadius, aShadowColor.CGColor);
		} else {
			CGContextSetShadow(imageShadowContext, aOffset, aBlurRadius);
		}
		
		[scaledImage drawInRect:CGRectMake(aBlurRadius, aBlurRadius, scaledImage.size.width, scaledImage.size.height)];
		scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	}
	
	return scaledImage;	
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor{
	return [self aspectScaleToMaxSize:size	withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:aOffset shadowBlurRadius:aRadius shadowColor:aColor];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:aRadius shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToSize:(CGSize)size{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size.width;
	CGFloat vScaleFactor = imageSize.height / size.height;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	// center vertically or horizontally in size passed
	CGFloat leftOffset = (size.width - newWidth) / 2;
	CGFloat topOffset = (size.height - newHeight) / 2;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
	}
#else
	UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
#endif
	
	[self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;	
}

- (CGSize)aspectScaleSize:(CGFloat)size{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size;
	CGFloat vScaleFactor = imageSize.height / size;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	return CGSizeMake(newWidth, newHeight);
	
}

- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	const CGFloat *color = CGColorGetComponents(aColor.CGColor);
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
	CGContextFillRect(context, rect);
	
	CGContextRestoreGState(context);
}

- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors{
	
	NSAssert([colors count]==2, @"an array containing two UIColor variables must be passed to drawInRect:withAlphaMaskGradient:");
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	
	const CGFloat *top = CGColorGetComponents(((UIColor*)[colors objectAtIndex:0]).CGColor);
	const CGFloat *bottom = CGColorGetComponents(((UIColor*)[colors objectAtIndex:1]).CGColor);
	
	CGColorSpaceRef _rgb = CGColorSpaceCreateDeviceRGB();
	size_t _numLocations = 2;
	CGFloat _locations[2] = { 0.0, 1.0 };
	CGFloat _colors[8] = { top[0], top[1], top[2], top[3], bottom[0], bottom[1], bottom[2], bottom[3] };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(_rgb, _colors, _locations, _numLocations);
	CGColorSpaceRelease(_rgb);
	
	CGPoint start = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
	CGPoint end = CGPointMake(CGRectGetMidX(rect), rect.size.height);
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
	
}

- (UIImage*)scaleAndRotateImage:(float)maxRelosution
{
    CGImageRef imgRef = self.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxRelosution || height > maxRelosution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = maxRelosution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = maxRelosution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

@end



/*
 *
 */
@implementation UIImage (scale)

+ (UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size 
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (UIImage*)createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
	
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);

    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return [UIImage imageWithCGImage:imageMasked];
}


+ (UIImage*)getRectImageFromImage:(UIImage *)image withRect:(CGRect)rect
{
    rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    float minx = 0.0, maxx = CGRectGetMaxX(rect);
    float miny = 0.0, maxy = CGRectGetMaxY(rect);

    UIGraphicsBeginImageContext(CGSizeMake(maxx, maxy));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, minx, miny);
    CGContextAddLineToPoint(context, maxx, miny);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextAddLineToPoint(context, minx, maxy);
    CGContextAddLineToPoint(context, minx, miny);
    CGContextDrawPath(context, kCGPathFillStroke);

    float width = image.size.width > (maxx- 6.0) ? (maxx-6.0) : image.size.width;
    float heigth = image.size.height > (maxy- 6.0) ? (maxy-6.0) : image.size.height;
    [image drawInRect:CGRectMake(3.0, 3.0, width, heigth) ];
    //[image drawAtPoint:CGPointMake(3.0, 3.0) ];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

@end
