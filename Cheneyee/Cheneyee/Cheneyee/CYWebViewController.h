//
//  CYWebViewController.h
//  Player
//
//  Created by Cheney Mars on 2019/11/18.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewController.h"
#import "CYWebViewModel.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYWebViewController : CYViewController

@property (nonatomic, strong, readonly) WKWebView * webView;


@end

NS_ASSUME_NONNULL_END
