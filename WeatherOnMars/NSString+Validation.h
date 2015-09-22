//
//  NSString+Validation.h
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidEmail;
- (BOOL)matchesRegularExpression:(NSString *)regularExpression;

@end
