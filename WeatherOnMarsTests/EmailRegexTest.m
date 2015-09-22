//
//  EmailRegexTest.m
//  WeatherOnMars
//
//  Copyright © 2015 Viktor Edelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Validation.h"

@interface EmailRegexTest : XCTestCase

@end

@implementation EmailRegexTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicEmailFormat {
    XCTAssertTrue([@"hallo@hey.de" isValidEmail]);
}

- (void)testWrongEmailFormat {
    XCTAssertFalse([@"helloKitty" isValidEmail]);
    XCTAssertFalse([@"hello@kitty" isValidEmail]);
    XCTAssertFalse([@"hello.kitty" isValidEmail]);
}

- (void)testNastyEmailFormat {
    XCTAssertTrue([@"jan-marc@web.de" isValidEmail]);
}

@end
