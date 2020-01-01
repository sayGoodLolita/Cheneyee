//
//  CYDataModel.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYDataModel.h"
#import "CYEXTRuntimeExtensions.h"
#import "CYReflection.h"
#import "NSError+CYExtension.h"
#import <YYModel/YYModel.h>
#import <IGListDiffable.h>
#import <ReactiveObjC/ReactiveObjC.h>

/// 验证对象的值, 并在必要时赋值
static BOOL CYValidateAndSetValue(id obj, NSString * key, id value, BOOL forceUpdate, NSError ** error) {
    // 标记为延迟释放, 防止 ARC 双倍释放或泄露新旧值
    __autoreleasing id validatedValue = value;
    @try {
        if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
        if (forceUpdate || value != validatedValue) {
            [obj setValue:validatedValue forKey:key];
        }
        return YES;
    } @catch (NSException * ex) {
        NSLog(@"*** Caught exception setting key \"%@\" : %@", key, ex);
#if DEBUG
        @throw ex;
#else
        if (error != NULL) {
            *error = [NSError cy_modelErrorWithException:ex];
        }
        return NO;
#endif
    }
}

@interface CYDataModel () <IGListDiffable, YYModel>

@end

@implementation CYDataModel

#pragma mark - IGListDiffable
- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}

#pragma YYModel
// 将 json (NSData, NSString, NSDictionary) 转换为 model
+ (instancetype)modelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [self yy_modelWithDictionary:dictionary];
}

// json 数组转换为模型数组
+ (NSArray *)modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:self.class json:json];
}

- (id)toJSONObject {
    return self.yy_modelToJSONObject;
}

- (NSData *)toJSONData {
    return self.yy_modelToJSONData;
}

- (NSString *)toJSONString {
    return self.yy_modelToJSONString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return self.yy_modelCopy;
}

- (NSUInteger)hash {
    return self.yy_modelHash;
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    return self.yy_modelDescription;
}

+ (NSSet *)propertyKeys {
    NSSet * cachedKeys = objc_getAssociatedObject(self, _cmd);
    if (cachedKeys != nil) return cachedKeys;
    NSMutableSet * keys = NSMutableSet.set;
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL * stop) {
        cy_propertyAttributes * attributes = cy_copyPropertyAttributes(property);
        @onExit {
            free(attributes);
        };
        if (attributes->readonly && attributes->ivar == NULL) return;
        NSString * key = @(property_getName(property));
        [keys addObject:key];
    }];
    // 不使用 OBJC_ASSOCIATION_COPY_NONATOMIC 来保证线程安全
    objc_setAssociatedObject(self, _cmd, keys, OBJC_ASSOCIATION_COPY);
    return keys;
}

#pragma mark reflection
+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL * stop))block {
    Class cls = self;
    BOOL stop = NO;
    while (!stop && ![cls isEqual:CYDataModel.class]) {
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        cls = cls.superclass;
        if (properties == NULL) continue;
        @onExit {
            free(properties);
        };
        for (unsigned i = 0; i < count; i++) {
            block(properties[i], &stop);
            if (stop) break;
        }
    }
}

#pragma mark Merging
- (void)mergeValueForKey:(NSString *)key fromModel:(CYDataModel *)model {
    NSParameterAssert(key != nil);
    SEL selector = CYSelectorWithCapitalizedKeyPattern("merge", key, "FromModel:");
    if (![self respondsToSelector:selector]) {
        if (model != nil) [self setValue:[model valueForKey:key] forKey:key];
        return;
    }
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    invocation.target = self;
    invocation.selector = selector;
    [invocation setArgument:&model atIndex:2];
    [invocation invoke];
}

- (void)mergeValuesForKeysFromModel:(CYDataModel *)model {
    NSSet * propertyKeys = model.class.propertyKeys;
    for (NSString * key in self.class.propertyKeys) {
        if (![propertyKeys containsObject:key]) continue;
        [self mergeValueForKey:key fromModel:model];
    }
}

#pragma mark Validation
- (BOOL)validate:(NSError **)error {
    for (NSString * key in self.class.propertyKeys) {
        id value = [self valueForKey:key];
        BOOL success = CYValidateAndSetValue(self, key, value, NO, error);
        if (!success) return NO;
    }
    return YES;
}

@end
