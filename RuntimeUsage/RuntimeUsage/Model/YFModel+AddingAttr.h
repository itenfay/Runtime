//
//  YFModel+AddingAttr.h
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFModel.h"

NS_ASSUME_NONNULL_BEGIN

// 利用Runtime为分类添加属性
@interface YFModel (AddingAttr)

// 居住地址
@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
