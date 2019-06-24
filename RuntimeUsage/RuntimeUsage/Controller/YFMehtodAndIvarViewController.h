//
//  YFMehtodAndIvarViewController.h
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFMehtodAndIvarViewController : YFBaseViewController

/** 标题 */
@property (nonatomic, copy) NSString *navItemTitle;

/** 类型  1: 方法 2: 属性 */
@property (nonatomic, assign) int type;

@end

NS_ASSUME_NONNULL_END
