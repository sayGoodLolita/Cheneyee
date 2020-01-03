//
//  NSError+CYExtension.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (CYExtension)

// Creates a new error for an exception that occured during updating an CYDataModel
//
// exception - The exception that was thrown while updating the model.
//             This argument must not be nil.
//
// Returns an error that takes its localized description and failure reason
// from the exception.
+ (instancetype)cy_modelErrorWithException:(NSException *)exception;


@end

NS_ASSUME_NONNULL_END
