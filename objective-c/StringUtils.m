//
//  StringUtils.m
//  Share
//
//  Created by Lin Zhang on 11-5-11.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "StringUtils.h"


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (Utils)

- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if ('0' <= c && c <= '9' || 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z' || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}

	return result;
}

+ (NSString*)base64encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";

    const char *source = [str UTF8String];
    int strlength  = strlen(source);

    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }

    return [[[NSString alloc] initWithBytesNoCopy:characters
                                           length:length
                                         encoding:NSASCIIStringEncoding
                                     freeWhenDone:YES]
                                         autorelease];
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [[self mutableCopy] autorelease];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

+ (NSString*)localizedString:(NSString*)key
{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
}


@end



/*
 *       NSString (Hash)
 */

#import <CommonCrypto/CommonDigest.h>


NSString* md5( NSString *str )
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@implementation NSString (Hash)

- (NSString*)MD5Hash {
    return md5(self);
}

@end



/*
 *       NSString (Random)
 */

#import <regex.h>
#import <string.h>


@implementation NSString (Random)

+ (NSString*)randomString:(int)length
{
    char str[36] = "0123456789abcdefghijklmnopqrstuvwxyz";

    srand((unsigned int)time((time_t *)NULL));

    NSString *result = [NSString string];
    for(int i=0; i<length; i++)
    {
        result = [result stringByAppendingFormat:@"%c",str[(rand()%36)]];
    }

    return result;
}

@end



/*
 *       NSString (Replace)
 */

@implementation NSString(Replace)

- (NSString*)removeNull
{
    NSArray *nullArray = [NSArray arrayWithObjects:@"<null>",@"(null)",nil];
    for (NSString *str in nullArray) {
        self = [self stringByReplacingOccurrencesOfString:str withString:@""];
    }

    return self;
}

- (BOOL)isBlank
{
    NSArray *blankArray = [NSArray arrayWithObjects:@" ",@"\n",nil];
    for (NSString *str in blankArray) {
        self = [self stringByReplacingOccurrencesOfString:str withString:@""];
    }

    if ([self isEqualToString:@""]) return YES;

    return NO;
}

- (BOOL)matches:(NSString *) regex withSubstring:(NSMutableArray *) substring{
	BOOL result = NO;
    regex_t re;
    int ret;
    const char *str = [self UTF8String];
    char buf[strlen([self UTF8String]) + 1];
    if ((ret =regcomp(&re, [regex UTF8String], REG_EXTENDED)) == 0) {
		size_t nmatch = re.re_nsub +1;
		regmatch_t pmatch[nmatch];
		if (0 == regexec(&re, [self UTF8String], nmatch, pmatch, 0)) {
			result = YES;
			if (substring  != nil){
				for (int i=1; i < nmatch; i++){
					if (pmatch[i].rm_so == pmatch[i].rm_eo & pmatch[i].rm_so == -1) {
						// there is no matching charaters for this partial expression
						[substring addObject:@""];
					}
					else {
						// return the found expressions
                        int len = pmatch[i].rm_eo - pmatch[i].rm_so;
                        buf[len] = 0;
                        strncpy(buf, &str[pmatch[i].rm_so], len);
                        [substring addObject:[NSString stringWithUTF8String:buf]];
					}
				}
			}
		}
    }
    else {
        char errbuf[100];
        regerror(ret, &re,errbuf,sizeof errbuf);
        NSLog(@"regcomp: %s",errbuf);
    }

    regfree(&re);

    return result;
}

@end



/*
 *       NSString (Height)
 */

@implementation NSString (Height)

- (CGFloat)heightForFont:(UIFont *)font
{
	CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(280.0f, 1000000.0f)
                       lineBreakMode:UILineBreakModeWordWrap];

	return size.height;
}

@end
