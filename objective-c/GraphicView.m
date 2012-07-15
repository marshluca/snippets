//
//  GraphicView.m
//  Graphics
//
//  Created by Lin Zhang on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GraphicView.h"

@implementation GraphicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"frame way");        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        NSLog(@"coder way");
    }    
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing text
    {
        UIColor *color = [UIColor colorWithRed:0.4 green:0.5 blue:0.8 alpha:0.3];
        [color set];
        
        // get color components
        CGColorRef colorRef = [color CGColor];
        const CGFloat *components = CGColorGetComponents(colorRef);    
        NSUInteger componentsCount = CGColorGetNumberOfComponents(colorRef);
        for (int counter = 0; counter < componentsCount; counter++) {
            NSLog(@"component %lu = %.02f", (unsigned long)counter+1, components[counter]);
        }
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.f];
        NSString *str = @"Only override drawRect if you perform custom drawing.";    
        CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(280, 480) lineBreakMode:UILineBreakModeWordWrap];
        [str drawInRect:CGRectMake(20, 100, size.width, size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];        
    }

    // Drawing image
    {
        UIImage *image = [UIImage imageNamed:@"xcode.png"];
        [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
        [image drawInRect:CGRectMake(100, 20, 200, 400) blendMode:kCGBlendModeNormal alpha:0.7];
    }
    
    // Drawing Routes
    {
        [[UIColor redColor] set];
        
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, 10.f);    
        CGContextMoveToPoint(currentContext, 50.f, 50.f);    
        CGContextAddLineToPoint(currentContext, 100.f, 100.f);
        CGContextAddLineToPoint(currentContext, 300.f, 20.f);
        CGContextSetLineJoin(currentContext, kCGLineJoinBevel);
        CGContextStrokePath(currentContext);        
    }
    
    // Drawing Line Path
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGPathMoveToPoint(path, NULL, screenBounds.origin.x, screenBounds.origin.y);
        CGPathAddLineToPoint(path, NULL, screenBounds.size.width, screenBounds.size.height);
        CGPathMoveToPoint(path, NULL, screenBounds.size.width, screenBounds.origin.y);
        CGPathAddLineToPoint(path, NULL, screenBounds.origin.x, screenBounds.size.height);
        
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextAddPath(currentContext, path);
        [[UIColor blueColor] setStroke];
        CGContextDrawPath(currentContext, kCGPathStroke);
        CGPathRelease(path);
    }
    
    // Drawing Rect Path
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectangle = CGRectMake(50.0f, 50.0f, 200.0f, 300.0f);
        CGPathAddRect(path, NULL, rectangle);
        
        [[UIColor redColor] setFill];
        [[UIColor blueColor] setStroke];
        
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, 20);
        CGContextSetLineJoin(currentContext, kCGLineJoinRound);
        CGContextSetLineCap(currentContext, kCGLineCapSquare);
        
        CGContextSetShadowWithColor(currentContext, CGSizeMake(10.0f, 10.0f), 20.0f, [[UIColor grayColor] CGColor]);
        
        CGContextAddPath(currentContext, path);
        CGContextDrawPath(currentContext, kCGPathFillStroke);
        CGPathRelease(path);
    }
}

- (void)drawRooftopAtTopPointof:(CGPoint)paramTopPoint textToDisplay:(NSString *)paramText
{
    
}

@end
