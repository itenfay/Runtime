//
//  YFModel.h
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFModel : YFBaseModel
// 名字
@property (nonatomic, copy) NSString *name;

// 性别
@property (nonatomic, copy) NSString *gender;

// 年龄
@property (nonatomic, copy) NSString *age;

@end

NS_ASSUME_NONNULL_END
