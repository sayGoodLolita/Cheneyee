//
//  Cheneyee.h
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/8/31.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//
/**
    必选
    pod "AFNetworking"
    pod "ReactiveObjC"
    pod "MJRefresh"
    pod "YYModel"
    pod "IQKeyboardManager"
    pod "IGListKit"
    pod "Masonry"

    推荐
    pod "QMUIKit"
 */

// 创建单例
#define CY_SINGLETON_DEF(_type_) + (_type_ *)sharedInstance;\
+(instancetype) alloc __attribute__((unavailable("使用 sharedInstance 初始化")));\
+(instancetype) new __attribute__((unavailable("使用 sharedInstance 初始化")));\
-(instancetype) copy __attribute__((unavailable("使用 sharedInstance 初始化")));\
-(instancetype) mutableCopy __attribute__((unavailable("使用 sharedInstance 初始化")));\

#define CY_SINGLETON_IMP(_type_) + (_type_ *)sharedInstance{\
static _type_ *theSharedInstance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
theSharedInstance = super.new;\
});\
return theSharedInstance;\
}


#ifdef DEBUG
#define NSLog(FORMAT, ...) do {fprintf(stderr,"%s [line %d] %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);} while(0)
#else
#define NSLog(...)
#endif

#define CYSharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/// 创建 16 进制颜色
#define HEXCOLOR(hexValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:1.0]

#define CYColorCreater(r, g, b, al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]

#define CYRandomColor CYColorCreater(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#import "CYRouter.h"

#import "CYNavigationControllerStack.h"
#import "CYListViewController.h"
#import "CYWebViewController.h"
#import "CYNavigationController.h"
#import "CYTabBarController.h"
#import "UIView+CYEx.h"

#import "CYViewModelServicesImpl.h"

#import "CYHTTPService.h"
#import "CYAppStorePay.h"

#import "CYTools.h"
#import "CYFileManager.h"
