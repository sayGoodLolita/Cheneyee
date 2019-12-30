//
//  UIBarButtonItem+CYEx.m
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/8/31.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "UIBarButtonItem+CYEx.h"

@implementation UIBarButtonItem (CYEx)

+ (instancetype)itemWithImage:(NSString *)image command:(RACCommand *)command {
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    btn.rac_command = command;
    UIBarButtonItem * item = [UIBarButtonItem.alloc initWithCustomView:btn];
    return item;
}

@end
