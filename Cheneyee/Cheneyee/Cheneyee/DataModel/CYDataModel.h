//
//  CYDataModel.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 dataModel 的基类

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <IGListDiffable.h>

NS_ASSUME_NONNULL_BEGIN

/// Block
typedef void (^VoidBlock)(void);
typedef BOOL (^BoolBlock)(void);
typedef int  (^IntBlock) (void);
typedef id _Nullable   (^IDBlock)  (void);

typedef void (^VoidBlock_int)(int);
typedef BOOL (^BoolBlock_int)(int);
typedef int  (^IntBlock_int) (int);
typedef id _Nullable   (^IDBlock_int)  (int);

typedef void (^VoidBlock_string)(NSString *);
typedef BOOL (^BoolBlock_string)(NSString *);
typedef int  (^IntBlock_string) (NSString *);
typedef id _Nullable   (^IDBlock_string)  (NSString *);

typedef void (^VoidBlock_id)(id);
typedef BOOL (^BoolBlock_id)(id);
typedef int  (^IntBlock_id) (id);
typedef id _Nonnull   (^IDBlock_id)  (id);

@interface CYDataModel : NSObject <IGListDiffable, YYModel, NSCopying, NSCoding>

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
