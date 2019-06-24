//
//  YFModel+AddingAttr.m
//
//  Created by dyf on 2019/6/23.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "YFModel+AddingAttr.h"
#import <objc/message.h>

static NSString *kHomeAddress = @"kHomeAddress";

@implementation YFModel (AddingAttr)

- (NSString *)address {
    return objc_getAssociatedObject(self, &kHomeAddress);
}

- (void)setAddress:(NSString *)address {
    objc_setAssociatedObject(self, &kHomeAddress, address, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
