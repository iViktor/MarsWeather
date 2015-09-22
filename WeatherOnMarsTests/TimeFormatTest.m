//
//  TimeFormatTest.m
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDate+DateUtils.h"

@interface TimeFormatTest : XCTestCase

@end

@implementation TimeFormatTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRFC1123 {
    NSString *expectedDateString = @"Tue, 13 Aug 1968 01:14:30 GMT";
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:13];
    [comps setMonth:8];
    [comps setYear:1968];
    [comps setHour:1];
    [comps setMinute:14];
    [comps setSecond:30];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *testDate = [cal dateFromComponents:comps];
    
    NSString *rfc1234String = [testDate RFC1123String];
    XCTAssertEqualObjects(expectedDateString, rfc1234String, @"Date format is not like expected for RFC 1123.");
}


@end
