//
//  NSDate+DateUtils.m
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import "NSDate+DateUtils.h"


@implementation NSDate (DayFormat)

- (NSDate *)dateWithOutTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *roundingComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:roundingComponents];
}

+ (NSDate *)dateForServerDateTimeString:(NSString *)dateTimeString {
//    NSLog(@"%@ dateTimeString %@", NSStringFromSelector(_cmd), dateTimeString);
    static NSDateFormatter *dateFormatter;
//    static NSDateFormatter *sUserVisibleDateFormatter;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSz"];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    }
    
//    if (!sUserVisibleDateFormatter) {
//        sUserVisibleDateFormatter = [[NSDateFormatter alloc] initWithForcedLocale];
//        [sUserVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [sUserVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    }
    
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    //    NSString *userVisibleDateTimeString = [sUserVisibleDateFormatter stringFromDate:date];
    //    NSLog(@"Parsed date is %@", userVisibleDateTimeString);
    
    return date;
}

+ (NSDate *)dateWithUnixTimeStamp:(NSString *)unixTimeStamp {
    NSTimeInterval unixTimeInterval = (NSTimeInterval)unixTimeStamp.doubleValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeInterval];
    return date;
}

- (NSTimeInterval)unixTimeStamp {
    return [self timeIntervalSince1970];
}

- (NSString *)RFC1123String {
    static NSDateFormatter *formatterRFC12234 = nil;
    if(!formatterRFC12234) {
        formatterRFC12234 = [[NSDateFormatter alloc] init];
        formatterRFC12234.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatterRFC12234.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatterRFC12234.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss zzz'";
    }
    return [formatterRFC12234 stringFromDate:self];
}

@end
