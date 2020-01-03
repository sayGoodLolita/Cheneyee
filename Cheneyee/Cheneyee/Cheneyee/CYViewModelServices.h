//
//  CYViewModelServices.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
// 视图模型服务层测协议 (导航栏操作的服务层 + 网络的服务层)

#import <Foundation/Foundation.h>
#import "CYNavigationProtocol.h"
#import "CYHTTPService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CYViewModelServices <NSObject, CYNavigationProtocol>

/// 全局通过这个 Client 来请求网络数据, 处理用户信息
@property (nonatomic, readonly, strong) CYHTTPService * client;


@end

NS_ASSUME_NONNULL_END
