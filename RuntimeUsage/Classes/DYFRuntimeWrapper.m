//
//  DYFRuntimeWrapper.m
//
//  Created by dyf on 2019/6/17.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "DYFRuntimeWrapper.h"
#import <objc/message.h>

static Class _modelClass;
static id    _model;

@implementation DYFRuntimeWrapper

#pragma mark -- 获得方法、属性

+ (NSArray *)yf_getAllMethodsWithClass:(Class)cls {
    NSMutableArray *methodNames = [NSMutableArray arrayWithCapacity:0];
    
    unsigned int count = 0;
    
    Method *methodList = class_copyMethodList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        SEL method = method_getName(methodList[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(method) encoding:NSUTF8StringEncoding];
        [methodNames addObject:methodName];
    }
    
    return methodNames.copy;
}

+ (NSArray *)yf_getAllIvarsWithClass:(Class)cls {
    NSMutableArray *ivarNames = [NSMutableArray arrayWithCapacity:0];
    
    unsigned int count = 0;
    
    Ivar *ivarList = class_copyIvarList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        [ivarNames addObject:ivarName];
    }
    
    return ivarNames.copy;
}

#pragma mark -- 添加方法

+ (BOOL)yf_addMethodWithClass:(Class)cls methodName:(NSString *)methodName impClass:(Class)impCls impName:(NSString *)impName {
    SEL mSel = NSSelectorFromString(methodName);
    
    SEL impSel = NSSelectorFromString(impName);
    IMP imp = class_getMethodImplementation(impCls, impSel);
    
    const char *types = method_getTypeEncoding(class_getInstanceMethod(cls, mSel));
    
    BOOL ret = class_addMethod(cls, mSel, imp, types);
    
    return ret;
}

+ (BOOL)yf_addMethodWithClass:(Class)cls methodName:(NSString *)methodName impClass:(Class)impCls impName:(NSString *)impName types:(NSString *)types {
    const char *mTypes = [types UTF8String];
    
    SEL mSel = NSSelectorFromString(methodName);
    
    SEL impSel = NSSelectorFromString(impName);
    IMP imp = class_getMethodImplementation(impCls, impSel);
    
    BOOL ret = class_addMethod(cls, mSel, imp, mTypes);
    
    return ret;
}

#pragma mark -- 交换两个方法

+ (void)yf_exchangeMethodWithSourceClass:(Class)sourceCls sourceSel:(SEL)sourceSel targetClass:(Class)targetCls targetSel:(SEL)targetSel {
    Method sourceMethod = class_getInstanceMethod(sourceCls, sourceSel);
    Method targetMethod = class_getInstanceMethod(targetCls, targetSel);
    
    method_exchangeImplementations(sourceMethod, targetMethod);
}

#pragma mark -- 取代方法

+ (void)yf_replaceMethodWithSourceClass:(Class)sourceCls sourceSel:(SEL)sourceSel targetClass:(Class)targetCls targetSel:(SEL)targetSel {
    Method targetMethod = class_getInstanceMethod(targetCls, targetSel);
    IMP targetImp = method_getImplementation(targetMethod);
    const char *types = method_getTypeEncoding(targetMethod);
    
    class_replaceMethod(sourceCls, sourceSel, targetImp, types);
}

#pragma mark -- 字典模型转换

+ (id)yf_modelWithDict:(NSDictionary *)dict modelClass:(Class)modelCls {
    id model = [[modelCls alloc] init];
    
    NSArray *propertyList = [self yf_getAllObjcProperties:modelCls];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([propertyList containsObject:key]) {
            [model setValue:obj forKey:key];
        }
    }];
    
    return model;
}

+ (NSArray *)yf_getAllObjcProperties:(Class)modelCls {
    NSMutableArray *mArray = [NSMutableArray array];
    
    unsigned int outCount = 0;
    
    objc_property_t *propertyList = class_copyPropertyList(modelCls, &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [mArray addObject:propertyName];
    }
    
    return mArray.copy;
}

#pragma mark -- 归档解档

+ (BOOL)yf_archive:(Class)modelCls model:(id)model filePath:(NSString *)path {
    [[self alloc] yf_archiveAndUnarchive:modelCls model:model];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:model toFile:path];
    
    return ret;
}

+ (id)yf_unarchive:(Class)modelCls filePath:(NSString *)path {
    [[self alloc] yf_archiveAndUnarchive:modelCls model:nil];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)yf_archiveAndUnarchive:(Class)modelCls model:(id)model {
    _modelClass = modelCls;
    _model = model;
    [DYFRuntimeWrapper yf_replaceMethodWithSourceClass:modelCls sourceSel:@selector(initWithCoder:) targetClass:[self class] targetSel:@selector(initWithCoder:)];
    [DYFRuntimeWrapper yf_replaceMethodWithSourceClass:modelCls sourceSel:@selector(encodeWithCoder:) targetClass:[self class] targetSel:@selector(encodeWithCoder:)];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    _model = [super init];
    
    if (_model) {
        NSArray *ivarNames = [DYFRuntimeWrapper yf_getAllIvarsWithClass:_modelClass];
        for (NSString *key in ivarNames) {
            id value = [coder decodeObjectForKey:key];
            [_model setValue:value forKey:key];
        }
    }
    
    return _model;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSArray *ivarNames = [DYFRuntimeWrapper yf_getAllIvarsWithClass:_modelClass];
    for (NSString *key in ivarNames) {
        id value = [_model valueForKey:key];
        [coder encodeObject:value forKey:key];
    }
}

@end
