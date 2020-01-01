//
//  CYDataModel.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 dataModel 的基类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYDataModel : NSObject <NSCopying, NSCoding>

/// 将 json (NSData, NSString, NSDictionary) 转换为 model
+ (instancetype)modelWithJSON:(id)json;

/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/// json 数组转换为模型数组
+ (NSArray *)modelArrayWithJSON:(id)json;

/// 将 model 转换为 json 对象
- (id)toJSONObject;

/// 将 model 转换为 data
- (NSData *)toJSONData;

/// 将 model 转换为 jsonStr
- (NSString *)toJSONString;

/// 返回所有 @property 声明的属性, 除了只读属性. 属性列表不包括成员变量
+ (NSSet *)propertyKeys;

/// 通过一个 model 来替换属性值
- (void)mergeValueForKey:(NSString *)key fromModel:(CYDataModel *)model;

/// 通过一个 model 替换所有值
- (void)mergeValuesForKeysFromModel:(CYDataModel *)model;

@end

/// 为 CYDataModel 添加验证逻辑
@interface CYDataModel (Validation)

/// 验证模型是否有效
- (BOOL)validate:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
