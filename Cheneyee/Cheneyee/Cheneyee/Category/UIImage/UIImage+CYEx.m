//
//  UIImage+CYEx.m
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/8/31.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "UIImage+CYEx.h"
#import <objc/runtime.h>

@implementation UIImage (CYEx)

+ (void)load {
    Method oldMethod = class_getClassMethod(self, @selector(imageNamed:));
    Method newMethod = class_getClassMethod(self, @selector(cy_imageNamed:));
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (UIImage *)cy_imageNamed:(NSString *)name {
    return [[self cy_imageNamed:name] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
}

@end
