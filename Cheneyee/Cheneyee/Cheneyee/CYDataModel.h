//
//  CYDataModel.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 dataModel 的基类

#import <Foundation/Foundation.h>
#import "CYMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYDataModel : NSObject <YYModel, NSCopying, NSCoding>

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

/// A dictionary representing the properties of the receiver.
/// The default implementation combines the values corresponding to all +propertyKeys into a dictionary, with any nil values represented by NSNull.
/// This property must never be nil.
@property (nonatomic, copy, readonly) NSDictionary *dictionaryValue;

/// Merges the value of the given key on the receiver with the value of the same key from the given model object, giving precedence to the other model object.
/// By default, this method looks for a '-merge<Key>FromModel:' method on the receiver, and invokes it if found. If not found, and `model` is not nil, the value for the given key is taken from 'model'.
- (void)mergeValueForKey:(NSString *)key fromModel:(CYDataModel *)model;

/// Merges the values of the given model object into the receiver, using -mergeValueForKey:fromModel: for each key in +propertyKeys.
/// 'model' must be an instance of the receiver's class or a subclass thereof.
- (void)mergeValuesForKeysFromModel:(CYDataModel *)model;

@end

/// Implements validation logic for CYDataModel.
@interface CYDataModel (Validation)

/// Validates the model.
/// The default implementation simply invokes -validateValue:forKey:error: with all +propertyKeys and their current value. If -validateValue:forKey:error: returns a new value, the property is set to that new value.
/// error - If not NULL, this may be set to any error that occurs during validation
/// Returns YES if the model is valid, or NO if the validation failed.
- (BOOL)validate:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
