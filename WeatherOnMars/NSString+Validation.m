//
//  NSString+Validation.m
//  VE
//
//  Copyright (c) 2015 Viktor Edelberg. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidEmail {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    return [self matchesRegularExpression:emailRegex];
}

- (BOOL)matchesRegularExpression:(NSString *)regularExpression {
    NSPredicate *regularExpressionPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL regularExpressionDidMatch = [regularExpressionPredicate evaluateWithObject:self];
    return regularExpressionDidMatch;
}

@end
