//
//  NSError+CYExtension.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "NSError+CYExtension.h"

// The domain for errors originating from CYModel.
static NSString * const CYModelErrorDomain = @"CYModelErrorDomain";

// An exception was thrown and caught.
static const NSInteger CYModelErrorExceptionThrown = 1;

// Associated with the NSException that was caught.
static NSString * const CYModelThrownExceptionErrorKey = @"CYModelThrownException";

@implementation NSError (CYExtension)

+ (instancetype)cy_modelErrorWithException:(NSException *)exception {
    NSParameterAssert(exception != nil);
    NSDictionary * userInfo = @{
                               NSLocalizedDescriptionKey: exception.description,
                               NSLocalizedFailureReasonErrorKey: exception.reason,
                               CYModelThrownExceptionErrorKey: exception
                               };
    return [NSError errorWithDomain:CYModelErrorDomain code:CYModelErrorExceptionThrown userInfo:userInfo];
}

@end
