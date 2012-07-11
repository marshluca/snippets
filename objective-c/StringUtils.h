//
//  StringUtils.h
//  Share
//
//  Created by Lin Zhang on 11-5-11.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Utils)
- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
+ (NSString*)localizedString:(NSString*)key;
+ (NSString*)base64encode:(NSString*)str;
@end

@interface NSString (Hash)
- (NSString*)MD5Hash;
@end

@interface NSString (Random)
+ (NSString*)randomString:(int)length;
@end

@interface NSString (Replace)
- (NSString*)removeNull;
- (BOOL)isBlank;
- (BOOL)matches:(NSString *)regex withSubstring:(NSMutableArray *)substring;
@end

@interface NSString (Height)
- (CGFloat)heightForFont:(UIFont *)font;
@end
