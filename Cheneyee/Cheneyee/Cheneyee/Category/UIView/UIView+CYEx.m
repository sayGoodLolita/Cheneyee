//
//  UIView+CYEx.m
//  CYRebatee
//
//  Created by Cheney Mars on 2019/9/27.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "UIView+CYEx.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIView (CYEx)

- (void)setColors:(NSArray *)colors {
    [self layoutIfNeeded];
    CAGradientLayer * gradientLayer = CAGradientLayer.layer;
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)]; // 渐变点
    gradientLayer.colors = [colors.rac_sequence map:^id _Nullable(UIColor *  _Nullable color) {
        return (__bridge id)color.CGColor;
    }].array; // 渐变数组
    [self.layer addSublayer:gradientLayer];
}

- (NSArray *)colors {
    return nil;
}

@end

