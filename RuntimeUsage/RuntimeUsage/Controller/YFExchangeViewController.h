//
//  YFExchangeViewController.h
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFExchangeViewController : YFBaseViewController

/** 标题 */
@property (nonatomic, copy) NSString *navItemTitle;

/** 类型  1: 交换 2: 替换 */
@property (nonatomic, assign) int type;

@end

NS_ASSUME_NONNULL_END
