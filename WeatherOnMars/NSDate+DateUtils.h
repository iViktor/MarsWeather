//
//  NSDate+DateUtils.h
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateUtils)

- (NSDate *)dateWithOutTime;
+ (NSDate *)dateForServerDateTimeString:(NSString *)dateTimeString;
+ (NSDate *)dateWithUnixTimeStamp:(NSString *)unixTimeStamp;
- (NSTimeInterval)unixTimeStamp;
- (NSString *)RFC1123String;

@end
