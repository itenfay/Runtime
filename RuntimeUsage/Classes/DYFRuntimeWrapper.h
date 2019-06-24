//
//  DYFRuntimeWrapper.h
//
//  Created by dyf on 2019/6/17.
//  Copyright © 2019 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYFRuntimeWrapper : NSObject

#pragma mark -- 获得方法、属性

/**
 获取一个类中所有的实例方法
 
 @param cls 需要检查的类
 
 @return 方法字符串数组
 */
+ (NSArray *)yf_getAllMethodsWithClass:(Class)cls;

/**
 获取一个类中的所有属性名
 
 @param cls 需要检查的类
 
 @return 属性字符串数组
 */
+ (NSArray *)yf_getAllIvarsWithClass:(Class)cls;

#pragma mark -- 添加方法

/**
 添加一个方法
 
 @param cls        添加方法的类
 @param methodName 方法名
 @param impCls     实现方法的类
 @param impName    实现方法的方法名
 
 @return 是否添加成功
 */
+ (BOOL)yf_addMethodWithClass:(Class)cls
                   methodName:(NSString *)methodName
                     impClass:(Class)impCls
                      impName:(NSString *)impName;

/**
 添加一个方法
 
 @param cls        添加方法的类
 @param methodName 方法名
 @param impCls     实现方法的类
 @param impName    实现方法的方法名
 @param types      添加方法的类型（可以参考 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100, 举例: v@:@, v-->返回值是void，@-->参数一是id , ：-->参数二是方法, @ --> 参数三是id）
 
 @return 是否添加成功
 */
+ (BOOL)yf_addMethodWithClass:(Class)cls
                   methodName:(NSString *)methodName
                     impClass:(Class)impCls
                      impName:(NSString *)impName
                        types:(NSString *)types;

#pragma mark -- 交换两个方法

/**
 交换两个方法
 
 @param sourceCls 源方法所在的类
 @param sourceSel 源方法
 @param targetCls 目标方法所在的类
 @param targetSel 目标方法
 */
+ (void)yf_exchangeMethodWithSourceClass:(Class)sourceCls
                               sourceSel:(SEL)sourceSel
                             targetClass:(Class)targetCls
                               targetSel:(SEL)targetSel;

#pragma mark -- 取代方法

/**
 取代某个方法
 
 @param sourceCls 要取代的方法的类
 @param sourceSel 要取代的方法名
 @param targetCls 取代的方法的类
 @param targetSel 取代的方法名
 */
+ (void)yf_replaceMethodWithSourceClass:(Class)sourceCls
                              sourceSel:(SEL)sourceSel
                            targetClass:(Class)targetCls
                              targetSel:(SEL)targetSel;

#pragma mark -- 字典模型转换

/**
 字典转换为模型对象
 
 @param dict 字典
 @param modelCls 模型类
 
 @return 转换后的模型
 */
+ (id)yf_modelWithDict:(NSDictionary *)dict
            modelClass:(Class)modelCls;

#pragma mark -- 归档解档

/**
 归档
 
 @param modelCls 要归档的类
 @param model    要归档的模型
 @param path     文件路径
 
 @return 是否归档成功
 */
+ (BOOL)yf_archive:(Class)modelCls
             model:(id)model
          filePath:(NSString *)path;

/**
 解档
 
 @param modelCls 要解档的类
 @param path     文件路径
 
 @return 解档后的模型对象
 */
+ (id)yf_unarchive:(Class)modelCls
          filePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
